#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"

node - "$ROOT_DIR" <<'NODE'
const fs = require('fs');
const path = require('path');

const root = process.argv[2];
const skipParts = new Set(['.git', 'node_modules', 'backups', 'old-reviews']);
const skipPathPatterns = [
  /(^|\/)00-Meta-Workflow\/00-plans-completed(\/|$)/,
];
const linkPattern = /!?\[[^\]]*\]\(([^)]+)\)/g;
const problems = [];

function walk(dir, files = []) {
  for (const entry of fs.readdirSync(dir, { withFileTypes: true })) {
    if (skipParts.has(entry.name)) continue;
    const full = path.join(dir, entry.name);
    const rel = path.relative(root, full);
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

for (const file of walk(root)) {
  const relFile = path.relative(root, file);
  const text = stripFencedCode(fs.readFileSync(file, 'utf8'));
  for (const match of text.matchAll(linkPattern)) {
    const raw = match[1].trim();
    if (!raw || raw.startsWith('#')) continue;
    if (/^[a-z][a-z0-9+.-]*:/i.test(raw) || raw.startsWith('mailto:')) continue;
    const targetNoAnchor = raw.split('#')[0];
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
    if (!target.startsWith(root)) continue;
    if (!fs.existsSync(target)) {
      const line = text.slice(0, match.index).split('\n').length;
      problems.push(`${relFile}:${line} -> ${raw}`);
    }
  }
}

if (problems.length) {
  console.error('Broken active markdown links:');
  for (const problem of problems) console.error(`- ${problem}`);
  process.exit(1);
}

console.log('Active markdown links OK');
NODE
