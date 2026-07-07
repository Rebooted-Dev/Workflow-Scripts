#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
cd "$ROOT"

python3 - <<'PY'
from pathlib import Path
import re
import sys

root = Path.cwd()
skill_root = root / "11-Skills"
workflow_root = root / "workflows"
errors = []

def frontmatter(path):
    text = path.read_text(encoding="utf-8")
    if not text.startswith("---\n"):
        return "", text
    end = text.find("\n---\n", 4)
    if end == -1:
        errors.append(f"{path}: unterminated frontmatter")
        return "", text
    return text[4:end], text[end + 5:]

def yaml_name(fm):
    match = re.search(r"^name:\s*([A-Za-z0-9_.-]+)\s*$", fm, re.M)
    return match.group(1) if match else None

def agent_display_name(text):
    match = re.search(r"^\s*display_name:\s*[\"']?([^\"'\n]+)[\"']?\s*$", text, re.M)
    if not match:
        return None
    return re.sub(r"[^a-z0-9]+", "-", match.group(1).lower()).strip("-")

def workflow_skill_ids(fm):
    if not re.search(r"^skills:\s*$", fm, re.M):
        return []
    ids = []
    for match in re.finditer(r"^\s*(?:primary:\s*|- skill:\s*|-\s+)([A-Za-z0-9_.-]+)\s*$", fm, re.M):
        value = match.group(1)
        if value not in {"required", "conditional"}:
            ids.append(value)
    return ids

for skill_dir in sorted(p for p in skill_root.iterdir() if p.is_dir()):
    skill_md = skill_dir / "SKILL.md"
    agent_yaml = skill_dir / "agents" / "openai.yaml"
    if not skill_md.exists():
        errors.append(f"{skill_dir}: missing SKILL.md")
        continue
    fm, _ = frontmatter(skill_md)
    name = yaml_name(fm)
    if name != skill_dir.name:
        errors.append(f"{skill_md}: frontmatter name {name!r} does not match folder {skill_dir.name!r}")
    if not agent_yaml.exists():
        errors.append(f"{skill_dir}: missing agents/openai.yaml")
    else:
        agent_text = agent_yaml.read_text(encoding="utf-8")
        agent_name = yaml_name(agent_text) or agent_display_name(agent_text)
        if agent_name != skill_dir.name:
            errors.append(f"{agent_yaml}: name/display_name {agent_name!r} does not match folder {skill_dir.name!r}")

for wf in sorted(workflow_root.rglob("*.md")):
    fm, body = frontmatter(wf)
    for skill_id in workflow_skill_ids(fm):
        if not (skill_root / skill_id / "SKILL.md").exists():
            errors.append(f"{wf}: referenced skill {skill_id!r} is missing")
    if re.search(r"^skills:\s*$", fm, re.M) and "## Skill Hooks" not in body:
        errors.append(f"{wf}: has skills frontmatter but no Skill Hooks section")

if errors:
    print("workflow skill validation failed:", file=sys.stderr)
    for error in errors:
        print(f"- {error}", file=sys.stderr)
    sys.exit(1)

print("workflow skill validation passed")
PY
