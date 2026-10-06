#!/usr/bin/env bash
# Active Markdown link checker (read-only).
#
# Usage:
#   check-active-markdown-links.sh                          # scan this repo, default skips
#   check-active-markdown-links.sh --self-test              # scan this script's fixtures
#   check-active-markdown-links.sh --root <dir>             # scan <dir>, default skips
#   check-active-markdown-links.sh [--root <dir>] --scope <file-or-dir> [--scope ...]
#
# Modes:
#   - default: walk the selected root (this repository, or --root) skipping
#     .git/node_modules/backups/old-reviews/fixtures and the known archived
#     plan directories. Unchanged from the previous behavior.
#   - --self-test: scan scripts/validation/fixtures and require the escaped-root
#     fixture to be detected. Takes no other arguments.
#   - --scope (repeatable): scan ONLY the explicitly listed files/directories.
#     Explicit scopes override the default archived-directory skip, so archive
#     files/dirs can be verified deliberately. Scope paths resolve absolute or
#     relative to the selected root; every scope (and every symlink it contains
#     or points through) must canonically resolve inside the selected root.
#
# Fail-closed guarantees: unknown or malformed arguments, a missing/unreadable
# or non-directory root, and missing/unreadable or root-escaping scopes all
# exit non-zero without scanning anything unintended. Link targets are checked
# for file existence and root containment only (lexical and canonical/symlink);
# Markdown anchors are not checked. The checker never writes.
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DEFAULT_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"

usage() {
  cat >&2 <<'EOF'
usage: check-active-markdown-links.sh [--self-test]
       check-active-markdown-links.sh [--root <repository-root>]
       check-active-markdown-links.sh [--root <repository-root>] --scope <file-or-dir> [--scope <file-or-dir>]...
EOF
}

selftest=0
root=""
scopes=()

while [ "$#" -gt 0 ]; do
  case "$1" in
    --self-test)
      if [ "$selftest" -eq 1 ] || [ -n "$root" ] || [ "${#scopes[@]}" -gt 0 ]; then
        echo "check-active-markdown-links: --self-test takes no other arguments" >&2
        exit 2
      fi
      selftest=1
      shift
      ;;
    --root)
      if [ "$selftest" -eq 1 ]; then
        echo "check-active-markdown-links: --self-test takes no other arguments" >&2
        exit 2
      fi
      if [ -n "$root" ]; then
        echo "check-active-markdown-links: --root given twice" >&2
        exit 2
      fi
      if [ "$#" -lt 2 ]; then
        echo "check-active-markdown-links: --root requires a value" >&2
        exit 2
      fi
      if [ -z "$2" ]; then
        # An empty --root must fail closed, never fall back to the default root.
        echo "check-active-markdown-links: --root requires a non-empty value" >&2
        exit 2
      fi
      root="$2"
      shift 2
      ;;
    --scope)
      if [ "$selftest" -eq 1 ]; then
        echo "check-active-markdown-links: --self-test takes no other arguments" >&2
        exit 2
      fi
      if [ "$#" -lt 2 ]; then
        echo "check-active-markdown-links: --scope requires a value" >&2
        exit 2
      fi
      if [ -z "$2" ]; then
        # An empty scope must fail closed, never widen into a whole-root scan.
        echo "check-active-markdown-links: --scope requires a non-empty value" >&2
        exit 2
      fi
      scopes+=("$2")
      shift 2
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    --)
      shift
      if [ "$#" -gt 0 ]; then
        echo "check-active-markdown-links: unexpected argument: $*" >&2
        usage
        exit 2
      fi
      ;;
    -*)
      echo "check-active-markdown-links: unknown option: $1" >&2
      usage
      exit 2
      ;;
    *)
      echo "check-active-markdown-links: unexpected argument: $1" >&2
      usage
      exit 2
      ;;
  esac
done

if [ "$selftest" -eq 1 ]; then
  mode="self-test"
elif [ "${#scopes[@]}" -gt 0 ]; then
  mode="scoped"
else
  mode="default"
fi
if [ -z "$root" ]; then
  root="$DEFAULT_ROOT"
fi

node - "$mode" "$root" ${scopes[@]+"${scopes[@]}"} <<'NODE'
const fs = require('fs');
const path = require('path');

const mode = process.argv[2];
const selfTest = mode === 'self-test';
const scoped = mode === 'scoped';
const rootArg = process.argv[3];
const scopeArgs = process.argv.slice(4);

function die(message) {
  console.error(`check-active-markdown-links: ${message}`);
  process.exit(1);
}

// Defense in depth: empty values must fail closed even if a caller bypasses
// the bash argument parser (no default-root fallback, no whole-root widening).
if (process.argv[3] === undefined || process.argv[3] === '') {
  die('root requires a non-empty value');
}
if (scopeArgs.some((s) => s === '')) {
  die('scope requires a non-empty value');
}

let rootLex;
try {
  rootLex = path.resolve(rootArg);
} catch {
  die(`root is missing or unreadable: ${rootArg}`);
}
let rootReal;
try {
  rootReal = fs.realpathSync(rootLex);
} catch {
  die(`root is missing or unreadable: ${rootArg}`);
}
let rootStat;
try {
  rootStat = fs.statSync(rootReal);
} catch {
  die(`root is missing or unreadable: ${rootArg}`);
}
if (!rootStat.isDirectory()) die(`root is not a directory: ${rootArg}`);
try {
  fs.accessSync(rootReal, fs.constants.R_OK);
} catch {
  die(`root is missing or unreadable: ${rootArg}`);
}

function inside(p) {
  if (p === rootLex || p === rootReal) return true;
  return p.startsWith(rootLex + path.sep) || p.startsWith(rootReal + path.sep);
}
function insideLexical(p) {
  if (p === rootLex) return true;
  return p.startsWith(rootLex + path.sep);
}

const skipPartsDefault = new Set(['.git', 'node_modules', 'backups', 'old-reviews', 'fixtures']);
const skipPartsScoped = new Set(['.git', 'node_modules']);
const skipPathPatterns = [
  /(^|\/)00-Meta-Workflow\/00-plans-completed(\/|$)/,
  /(^|\/)00-project\/plans\/Drag-Free-v2(\/|$)/,
  /(^|\/)00-project\/plans-completed(\/|$)/,
];
// Relative links that intentionally leave the repo (none by default).
const escapedRootAllowlist = [];
const linkPattern = /!?\[[^\]]*\]\(([^)]+)\)/g;
const problems = [];

const scanFiles = [];
const seenReal = new Set();
// Canonical visited-directory set: in-root symlinked directories can form
// self/parent cycles; every directory is registered by canonical path before
// recursion so each physical directory is walked exactly once.
const seenDirs = new Set();

function addFile(real) {
  if (!seenReal.has(real)) {
    seenReal.add(real);
    scanFiles.push(real);
  }
}

function walkDefault(dir, files) {
  for (const entry of fs.readdirSync(dir, { withFileTypes: true })) {
    if (skipPartsDefault.has(entry.name)) continue;
    const full = path.join(dir, entry.name);
    if (!scoped && !selfTest) {
      const rel = path.relative(rootLex, full);
      if (skipPathPatterns.some((pattern) => pattern.test(rel))) continue;
    }
    if (entry.isDirectory()) walkDefault(full, files);
    else if (entry.isFile() && entry.name.endsWith('.md')) files.push(full);
  }
  return files;
}

function walkScoped(dir) {
  if (seenDirs.has(dir)) return;
  seenDirs.add(dir);
  for (const entry of fs.readdirSync(dir, { withFileTypes: true })) {
    if (skipPartsScoped.has(entry.name)) continue;
    const full = path.join(dir, entry.name);
    if (entry.isSymbolicLink()) {
      let real;
      try {
        real = fs.realpathSync(full);
      } catch {
        continue; // dangling symlink inside a scoped tree: nothing to scan
      }
      if (!inside(real)) {
        problems.push(`${displayRel(full)} -> ${entry.name} (symlink escapes selected root)`);
        continue;
      }
      const st = fs.statSync(real);
      if (st.isDirectory()) walkScoped(real);
      else if (real.endsWith('.md')) addFile(real);
      continue;
    }
    if (entry.isDirectory()) walkScoped(full);
    else if (entry.isFile() && entry.name.endsWith('.md')) addFile(pathResolveReal(full));
  }
}

function pathResolveReal(p) {
  try {
    return fs.realpathSync(p);
  } catch {
    return p;
  }
}

function displayRel(file) {
  const rel = path.relative(rootLex, file);
  if (!rel.startsWith('..')) return rel;
  return path.relative(rootReal, file);
}

let scanRoot;
if (selfTest) {
  scanRoot = path.join(rootLex, 'scripts/validation/fixtures');
  let st;
  try {
    st = fs.statSync(scanRoot);
  } catch {
    die('self-test fixtures directory is missing');
  }
  if (!st.isDirectory()) die('self-test fixtures directory is missing');
  walkDefault(scanRoot, scanFiles);
} else if (scoped) {
  for (const s of scopeArgs) {
    const abs = path.isAbsolute(s) ? path.resolve(s) : path.resolve(rootLex, s);
    if (!insideLexical(abs) && !inside(abs)) {
      die(`scope escapes selected root: ${s}`);
    }
    let st;
    try {
      st = fs.lstatSync(abs);
    } catch {
      die(`scope is missing or unreadable: ${s}`);
    }
    let real;
    try {
      real = fs.realpathSync(abs);
    } catch {
      die(`scope is missing or unreadable: ${s}`);
    }
    if (!inside(real)) {
      die(`scope symlink escapes selected root: ${s}`);
    }
    const realStat = fs.statSync(real);
    if (realStat.isDirectory()) {
      try {
        fs.accessSync(real, fs.constants.R_OK);
      } catch {
        die(`scope is missing or unreadable: ${s}`);
      }
      walkScoped(real);
    } else {
      addFile(real);
    }
  }
} else {
  scanRoot = rootLex;
  walkDefault(scanRoot, scanFiles);
}

function stripFencedCode(markdown) {
  let inFence = false;
  return markdown
    .split('\n')
    .map((line) => {
      if (/^\s*```/.test(line)) {
        inFence = !inFence;
        return '';
      }
      return inFence ? '' : line;
    })
    .join('\n');
}

function isAllowlistedEscape(raw) {
  return escapedRootAllowlist.some((pattern) => pattern.test(raw));
}

for (const file of scanFiles) {
  const relFile = selfTest
    ? path.relative(scanRoot, file)
    : (scoped ? displayRel(file) : path.relative(rootLex, file));
  const text = stripFencedCode(fs.readFileSync(file, 'utf8'));
  for (const match of text.matchAll(linkPattern)) {
    const raw = match[1].trim();
    if (!raw || raw.startsWith('#')) continue;
    if (/^[a-z][a-z0-9+.-]*:/i.test(raw) || raw.startsWith('mailto:')) continue;
    const targetNoAnchor = raw.split('#')[0];
    // Root-absolute web paths (e.g. /docs/ai-sdk-core) are external, not repo files.
    if (targetNoAnchor.startsWith('/') && !targetNoAnchor.startsWith('//')) continue;
    if (!targetNoAnchor) continue;
    let decoded;
    try {
      decoded = decodeURIComponent(targetNoAnchor);
    } catch {
      const line = text.slice(0, match.index).split('\n').length;
      problems.push(`${relFile}:${line} -> ${raw} (malformed percent-encoding)`);
      continue;
    }
    const target = path.resolve(path.dirname(file), decoded);
    if (!inside(target)) {
      if (!isAllowlistedEscape(raw)) {
        const line = text.slice(0, match.index).split('\n').length;
        problems.push(`${relFile}:${line} -> ${raw} (escapes repository root)`);
      }
      continue;
    }
    if (fs.existsSync(target)) {
      // Canonical guard: a target inside the root lexically may still be a
      // symlink chain physically pointing outside the selected root.
      const targetReal = fs.realpathSync(target);
      if (!inside(targetReal)) {
        if (!isAllowlistedEscape(raw)) {
          const line = text.slice(0, match.index).split('\n').length;
          problems.push(`${relFile}:${line} -> ${raw} (escapes repository root via symlink)`);
        }
        continue;
      }
    } else {
      const line = text.slice(0, match.index).split('\n').length;
      problems.push(`${relFile}:${line} -> ${raw}`);
    }
  }
}

if (selfTest) {
  const escaped = problems.filter((p) => p.includes('escapes repository root'));
  if (escaped.length === 0) {
    console.error('Self-test failed: expected at least one escaped-root link in fixtures');
    process.exit(1);
  }
  console.log('Escaped-root fixture detection OK');
  process.exit(0);
}

if (problems.length) {
  console.error('Broken active markdown links:');
  for (const problem of problems) console.error(`- ${problem}`);
  process.exit(1);
}

console.log('Active markdown links OK');
NODE
