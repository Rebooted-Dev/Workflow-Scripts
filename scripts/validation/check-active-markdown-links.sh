#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
SELF_TEST="${1:-}"

node - "$ROOT_DIR" "$SELF_TEST" <<'NODE'
const fs = require('fs');
const path = require('path');

const root = process.argv[2];
const selfTest = process.argv[3] === '--self-test';
const scanRoot = selfTest
  ? path.join(root, 'scripts/validation/fixtures')
  : root;
const skipParts = new Set(['.git', 'node_modules', 'backups', 'old-reviews', 'fixtures']);
const skipPathPatterns = [
  /(^|\/)00-Meta-Workflow\/00-plans-completed(\/|$)/,
  /(^|\/)00-project\/plans\/Drag-Free-v2(\/|$)/,
  /(^|\/)00-project\/plans-completed(\/|$)/,
];
// Relative links that intentionally leave the repo (none by default).
const escapedRootAllowlist = [];
const linkPattern = /!?\[[^\]]*\]\(([^)]+)\)/g;
const problems = [];

function walk(dir, files = []) {
  for (const entry of fs.readdirSync(dir, { withFileTypes: true })) {
    if (skipParts.has(entry.name)) continue;
    const full = path.join(dir, entry.name);
    const rel = path.relative(scanRoot, full);
    if (skipPathPatterns.some((pattern) => pattern.test(rel))) continue;
    if (entry.isDirectory()) walk(full, files);
    else if (entry.isFile() && entry.name.endsWith('.md')) files.push(full);
  }
  return files;
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

for (const file of walk(scanRoot)) {
  const relFile = path.relative(scanRoot, file);
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
    if (!target.startsWith(root)) {
      if (!isAllowlistedEscape(raw)) {
        const line = text.slice(0, match.index).split('\n').length;
        problems.push(`${relFile}:${line} -> ${raw} (escapes repository root)`);
      }
      continue;
    }
    if (!fs.existsSync(target)) {
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
