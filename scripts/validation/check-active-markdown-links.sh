#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
ROOT_DIR="${ACTIVE_MARKDOWN_ROOT:-$REPO_ROOT/workflows-drag-free}"

node - "$ROOT_DIR" <<'NODE'
const fs = require('fs');
const path = require('path');

const root = process.argv[2];
const skipParts = new Set(['.git', 'node_modules', 'backups', 'old-reviews']);
const skipPathPatterns = [
  /(^|\/)00-Meta-Workflow\/00-plans-completed(\/|$)/,
  /(^|\/)00-Drag-Free-v2(\/|$)/,
];
const linkPattern = /!?\[[^\]]*\]\(([^)]+)\)/g;
const inlineCodePattern = /`([^`\n]+)`/g;
const retiredPathPatterns = [
  /(?:^|\/)00-Meta-Workflow\/00-meta\//,
  /(?:^|\/)00-project-setup\/01-setup-project\.md(?:$|[#/])/,
];
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
  const lines = markdown.split('\n');
  const stripped = [...lines];
  let opener = null;
  let start = 0;
  for (let index = 0; index < lines.length; index += 1) {
    const line = lines[index].replace(/\r$/, '');
    if (!opener) {
      const match = line.match(/^ {0,3}(`{3,}|~{3,})(.*)$/);
      if (!match) continue;
      opener = { char: match[1][0], minimum: match[1].length };
      start = index;
      continue;
    }
    const escaped = opener.char === '`' ? '`' : '~';
    const closing = new RegExp(`^ {0,3}${escaped}{${opener.minimum},}[ \\t]*$`);
    if (!closing.test(line)) continue;
    for (let fencedIndex = start; fencedIndex <= index; fencedIndex += 1) stripped[fencedIndex] = '';
    opener = null;
  }
  return opener ? markdown : stripped.join('\n');
}

function stripShellHeredocTemplates(markdown) {
  const lines = markdown.split('\n');
  const stripped = [...lines];
  let delimiter = null;
  let start = 0;
  for (let index = 0; index < lines.length; index += 1) {
    const line = lines[index].replace(/\r$/, '');
    if (!delimiter) {
      const match = line.match(/^\s*cat\s+.*<<-?\s*['"]?([A-Za-z_][A-Za-z0-9_]*)['"]?\s*$/);
      if (!match) continue;
      delimiter = match[1];
      start = index;
      continue;
    }
    if (line.trim() !== delimiter) continue;
    for (let templateIndex = start; templateIndex <= index; templateIndex += 1) stripped[templateIndex] = '';
    delimiter = null;
  }
  return delimiter ? markdown : stripped.join('\n');
}

for (const file of walk(root)) {
  const relFile = path.relative(root, file);
  const text = stripFencedCode(stripShellHeredocTemplates(fs.readFileSync(file, 'utf8')));
  for (const match of text.matchAll(linkPattern)) {
    const raw = match[1].trim();
    if (!raw || raw.startsWith('#') || raw.startsWith('/')) continue;
    if (/^[a-z][a-z0-9+.-]*:/i.test(raw) || raw.startsWith('mailto:')) continue;
    const targetNoAnchor = raw.split('#')[0];
    if (!targetNoAnchor) continue;
    const decoded = decodeURIComponent(targetNoAnchor);
    const decodedPath = decoded.replace(/:\d+(?:-\d+)?$/, '');
    const target = path.resolve(path.dirname(file), decodedPath);
    if (!fs.existsSync(target)) {
      const line = text.slice(0, match.index).split('\n').length;
      problems.push(`${relFile}:${line} -> ${raw}`);
    }
  }
  const topLevel = relFile.split(path.sep)[0];
  const isActiveContract = path.basename(file) !== 'README.md' &&
    (topLevel === '00-core' || (/^\d\d-/.test(topLevel) && topLevel !== '00-project'));
  if (!isActiveContract) continue;
  for (const match of text.matchAll(inlineCodePattern)) {
    const raw = match[1].trim();
    const line = text.slice(0, match.index).split('\n').length;
    if (retiredPathPatterns.some((pattern) => pattern.test(raw))) {
      problems.push(`${relFile}:${line} -> retired inline path ${raw}`);
      continue;
    }
    // Inline relative Markdown paths are contract references too. Limit this
    // to a single path-shaped token so shell snippets and prose are ignored.
    if (/[<>]/.test(raw) || !/^(?:\.\.?\/)[^\s`]+\.md(?:#[^\s`]*)?$/.test(raw)) continue;
    const targetNoAnchor = raw.split('#')[0];
    const target = path.resolve(path.dirname(file), targetNoAnchor);
    if (!fs.existsSync(target)) problems.push(`${relFile}:${line} -> ${raw}`);
  }
}

if (problems.length) {
  console.error('Broken active markdown links:');
  for (const problem of problems) console.error(`- ${problem}`);
  process.exit(1);
}

console.log('Active markdown links OK');
NODE
