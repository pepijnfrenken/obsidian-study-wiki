# Study Wiki

A Factory skill that builds and maintains a persistent, compounding study wiki from your course materials. The LLM reads your sources once, compiles them into structured interlinked markdown pages, and keeps everything current as new material arrives.

## What It Does

- **Ingests** lecture slides, textbook chapters, problem sets, and notes into a structured wiki
- **Answers** course-related questions by synthesizing across all ingested material
- **Tracks mastery** per topic with a 0-5 grasp level, updated as you learn
- **Drills** the wiki for gaps, broken links, orphan pages, and thin content
- **Generates** exam prep materials: practice questions, revision plans, formula sheets
- **Files exercises** with links to underlying concepts and recurring patterns

## How It Works

The wiki has three layers:

1. **`raw/`** — Your immutable source documents. Drop in PDFs, notes, photos of whiteboards. The LLM reads from these but never modifies them.
2. **`wiki/`** — LLM-generated markdown pages: concepts, formulas, proofs, worked examples, cross-references, and a master index. The LLM owns this layer entirely.
3. **`wiki/schema.md`** — Conventions and structure, co-evolved with you over time.

The LLM acts as a tutor, not a note-taking tool. Pages are written to teach — concept pages start with intuition before formal definitions, formula pages explain why the formula looks the way it does, proof pages annotate each step with reasoning.

## Triggers

The skill activates when you:

- Add files to `raw/`
- Paste content or a URL to ingest
- Say "add to wiki" or "ingest this"
- Ask a course-related question ("explain X", "compare A and B", "derive Y")
- Say "drill", "health check", "lint wiki", or "find gaps"
- Ask for exam prep, practice questions, or a revision plan
- Work through a problem set or exercise

## Quick Start

1. Install the skill in your Factory project
2. Say "init wiki" to create the directory structure
3. Drop course materials into `raw/`
4. Say "ingest this" (or ask the wiki to process the new sources) to run the interactive ingest flow

## Mastery Tracking

Every topic gets a grasp level from 0 (uncovered) to 5 (mastered). The system updates levels based on your interactions — questions you ask, exercises you solve, concepts you struggle with. You can also edit `wiki/mastery.md` directly at any time. Staleness should be inferred from each topic's `last assessed: YYYY-MM-DD` date rather than from manual marker tags.

## Hooks

- **SessionStart**: Runs `scripts/check-wiki-drift.sh` to detect unprocessed sources in `raw/` and topics whose `last assessed` dates have gone stale
- **Stop**: If `raw/` changed during the task, nudges the agent to offer the normal interactive INGEST workflow instead of silently rewriting the wiki

The SessionStart command uses the host-provided `${CLAUDE_PLUGIN_ROOT}` path to locate the bundled script.

## File Overview

| File | Purpose |
|------|---------|
| `SKILL.md` | Skill definition, decision tree, and full operation specs |
| `AGENTS.md` | Teaching intent and interaction style guidelines |
| `hooks.json` | SessionStart drift detection and Stop-time ingest nudges |
| `scripts/check-wiki-drift.sh` | Detects unprocessed sources and date-based mastery drift |
| `references/operations.md` | Detailed workflow descriptions for each operation |
| `references/page-templates.md` | Page format examples and frontmatter conventions |

## Acknowledgments

The design of this wiki is inspired by **Andrej Karpathy's** [LLM Wiki](https://github.com/karpathy/llmwiki) concept — the idea of using an LLM to maintain a persistent, compounding knowledge base of interlinked markdown files that grows and improves over time rather than re-deriving knowledge from scratch on every query. This skill adapts that pattern specifically for coursework and exam preparation, adding mastery tracking, Socratic teaching, and structured study workflows on top of the core wiki architecture.
