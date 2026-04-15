---
name: study-wiki
description: "Build and maintain a persistent Course Wiki — a compounding, interlinked study knowledge base of markdown files for courses, textbooks, and exam prep. TRIGGER when: user adds sources to raw/ (lecture slides, textbook chapters, problem sets, notes), pastes content to ingest, says 'add to wiki' or 'ingest this', asks course-related questions ('explain X', 'compare A and B', 'derive Y', 'summarize topic Z'), says 'drill', 'health check', 'lint wiki', 'find gaps', or asks for exam prep ('generate practice questions', 'revision plan', 'formula sheet'). Also triggers when raw/ has unprocessed files. DO NOT TRIGGER when: user asks about project source code or architecture, wants simple file operations, or asks general questions unrelated to course material."
---

# Course Wiki

Build and maintain a persistent, compounding study wiki as interlinked markdown. The wiki sits between you and your raw course material: the LLM reads sources once, compiles them into structured pages, and keeps everything current as new material arrives. Knowledge compounds — it is never re-derived from scratch on every query.

## Decision tree

```
Does wiki/ exist in the project?
├─ No → User says "init wiki" or "start a wiki" → Run INIT
├─ Yes →
│   ├─ New files in raw/ not yet in log.md? → Run INGEST
│   ├─ User asks a course-related question? → Run QUERY
│   ├─ User says "drill", "health check", "lint", "find gaps"? → Run DRILL
│   ├─ User asks for exam prep, practice questions, revision plan? → Run EXAM-PREP
│   ├─ User works through a problem set or exercise? → Run FILE-EXERCISE
│   ├─ User wants to assess mastery, says "rate my understanding", "what do I know"? → Run MASTERY-CHECK
│   └─ User pastes content or a URL to add? → Save to raw/, then INGEST
```

## Architecture

Three layers:

1. **Raw sources** (`raw/`) — Immutable course material. Lecture slides, textbook chapters, problem set PDFs, handwritten notes (photographed or typed), web clippings. The LLM reads from these but never modifies them. Source of truth.

2. **The wiki** (`wiki/`) — LLM-generated markdown files. Concept pages, formula sheets, derivation walkthroughs, worked examples, proof pages, topic summaries, cross-course connections, a master formula index, and a query log. The LLM owns this layer entirely. It creates pages, updates them when new lectures arrive, maintains cross-references, and keeps everything consistent. You read it; the LLM writes it.

3. **The schema** (`wiki/schema.md`) — Tells the LLM how the wiki is structured, what conventions to follow, and what workflows to run. Co-evolved with the user over time.

## Wiki structure

```
AGENTS.md                  # Study & teaching intent — how the LLM should approach this wiki
raw/                        # Immutable source documents (user curates)
raw/assets/                 # Downloaded images, diagrams, graphs
wiki/
├── index.md                # Content catalog — every page with link + summary
├── log.md                  # Append-only chronological record
├── schema.md               # Wiki conventions, co-evolved with user
├── overview.md             # High-level synthesis across all courses
├── mastery.md              # Knowledge gap tracker — per-topic grasp levels & history
├── courses/                # Per-course overview pages
│   └── <course>.md
├── concepts/               # Concept pages (e.g., concepts/eigenvalues.md)
├── formulas/               # Formula pages (e.g., formulas/bayes-theorem.md)
├── proofs/                 # Proof/derivation pages
├── examples/               # Worked examples
├── exercises/              # Filed problem-set solutions
├── sources/                # One summary per ingested source
├── queries/                # Filed query results worth keeping
└── exam-prep/              # Exam prep materials, question banks, revision plans
```

## Operations

### INIT
1. Create `wiki/` directory structure and `raw/` (with `raw/assets/`) if missing
2. Write `schema.md` with default conventions (customizable later)
3. Create empty `index.md`, `log.md`, and `mastery.md`
4. Write `overview.md` placeholder
5. Write `AGENTS.md` in the project root with the study/teaching intent (see AGENTS.md template)
6. Ask user for course name(s) and any course outline/syllabus to seed the structure
7. If a syllabus is provided, pre-populate `mastery.md` with all topics at level 0 (uncovered)
8. If `raw/` already has files, offer to run the normal interactive INGEST flow on them immediately

### INGEST
1. Read the new source in `raw/`
2. Discuss key takeaways with user — share 3-5 highlights, ask what to emphasize
3. Write a source summary page in `sources/`
4. Create or update concept pages in `concepts/`
5. Extract and create formula pages in `formulas/`
6. Create or update proof/derivation pages in `proofs/` (if applicable)
7. Update the formula index in `overview.md`
8. Cross-reference related pages across the wiki — update wikilinks
9. If a later lecture redefines or generalizes an earlier concept, update the earlier page
10. Update `index.md` with new/changed pages
11. Append to `log.md`: `## [YYYY-MM-DD] ingest | Source Title`, followed by `- Source: raw/...`, course, and pages created/updated
12. Update `mastery.md` for newly introduced or discussed topics, using each topic's `last assessed: YYYY-MM-DD` date to track freshness
13. A single lecture should typically touch 5-10 wiki pages

### QUERY
1. Read `index.md` to find relevant pages
2. Read those pages + follow cross-references
3. Synthesize answer with references to specific wiki pages
4. Answer formats: step-by-step derivation, formula comparison table, concept explanation, practice questions, concept map
5. If the answer is valuable synthesis, file it in `queries/`
6. Update `index.md` if new pages created
7. Append to `log.md`: `## [YYYY-MM-DD] query | Question summary`

### DRILL
1. Scan all wiki pages
2. Check for: concepts mentioned across pages but without their own page, formulas without derivations, examples without links to underlying concepts, orphan pages (no inbound links), broken wikilinks, thin pages, topics from the course outline not yet covered
3. Cross-reference with `mastery.md` — flag topics rated shaky (1-2) that also have wiki quality issues (thin pages, missing examples, no exercises filed)
4. Fix what you can or report to user
5. Suggest areas that need more work or new sources, prioritized by mastery level (weakest first)
6. Append to `log.md`: `## [YYYY-MM-DD] drill | Summary of findings`

### EXAM-PREP
1. Read `mastery.md` to identify weak areas (level 1-2) and unassessed topics
2. Read all pages tagged `exam-relevant: true` or in the relevant course scope
3. Identify high-priority topics: formula-dense pages, heavily cross-referenced concepts, topics rated shaky or below in mastery, pages flagged as "to revisit"
4. Generate exam-style questions from wiki content, weighted toward weak areas
5. Produce a targeted revision plan organized by priority — weakest topics first
6. Optionally generate a formula sheet or summary deck
7. File generated materials in `exam-prep/`
8. Update `index.md` and `log.md`

### FILE-EXERCISE
1. Record the problem, solution, and underlying concept it tests
2. Link to the relevant concept/formula/proof pages
3. Over time, identify patterns — recurring formulas, common proof techniques
4. File in `exercises/`, update `index.md` and `log.md`

### MASTERY-CHECK
1. Read `mastery.md` to get current grasp levels
2. Ask the user to self-assess on recent topics, or quiz them informally through a few targeted questions
3. Update the mastery profile with new assessments
4. Identify knowledge gaps: topics rated shaky or not yet assessed
5. Suggest a focused review plan for weak areas
6. After a learning session (ingest, query, or exercise), update `mastery.md` to reflect what was practiced

### MASTERY-UPDATE (automatic, after other operations)
After any INGEST, QUERY, FILE-EXERCISE, or EXAM-PREP session:
1. Review what topics were discussed or practiced
2. Ask the user how confident they feel about those topics (or infer from the interaction)
3. Update the relevant entries in `mastery.md`
4. If the user struggled with a concept, mark it for revisit and adjust the grasp level down
5. If the user demonstrated strong understanding, promote the grasp level up

## Mastery tracking

The wiki maintains a `mastery.md` file that persists knowledge state between learning sessions. This is the one wiki file the user is encouraged to review and edit directly — it represents their personal learning progress.

### Grasp levels

Every topic tracked in `mastery.md` has a grasp level:

| Level | Label | Meaning |
|-------|-------|---------|
| 5 | Mastered | Can teach it, apply in novel contexts, connect to other topics |
| 4 | Strong | Understand well, can apply correctly, minor gaps only |
| 3 | Comfortable | Get the idea, can work through with some effort |
| 2 | Shaky | Know the surface, but struggle with application or details |
| 1 | Exposed | Seen it in lecture/reading, but don't really get it yet |
| 0 | Uncovered | On the syllabus but haven't encountered yet |

### How mastery gets updated

- **During INGEST**: New topics are added at level 1 (exposed). If the user discusses a topic in depth and demonstrates understanding, start at 2-3.
- **During QUERY**: If the user asks about a topic, it signals they're engaging with it. After answering, ask how they feel about it and update.
- **During FILE-EXERCISE**: If the user solves correctly, promote. If they struggle or need hints, demote or hold.
- **During DRILL**: Reassess all topics — flag any where the grasp level seems stale (not updated in a while).
- **During MASTERY-CHECK**: Explicit self-assessment or quiz-based evaluation.
- **User can edit directly**: The user can open `mastery.md` and adjust levels at any time. The LLM respects manual overrides.

Freshness should be inferred from each topic's `last assessed: YYYY-MM-DD` date. A topic is stale once it has gone more than two weeks without reassessment.

### What mastery.md tracks

For each topic:
- Grasp level (0-5)
- `last assessed: YYYY-MM-DD`
- Evidence: what interactions informed the rating (queries answered, exercises solved, questions asked)
- Weak areas: specific subtopics or skills that need work
- Review history: how the level has changed over time (so the user can see progress)

## Page conventions

Every wiki page has YAML frontmatter:
```yaml
---
title: Page Title
type: concept | formula | proof | example | exercise | source | query | course | exam-prep | overview
course: Course Name          # optional, for multi-course wikis
lecture: "Lecture N"         # optional, which lecture it came from
tags: [tag1, tag2]
difficulty: beginner | intermediate | advanced   # optional
mastery: 0 | 1 | 2 | 3 | 4 | 5   # optional, user's grasp level (synced with mastery.md)
exam-relevant: true | false  # optional
to-revisit: true | false     # optional, flag for later review
created: YYYY-MM-DD
updated: YYYY-MM-DD
sources: [raw/filename.pdf]
---
```

- Use `[[wikilinks]]` for cross-references between pages
- Start every page with a 1-2 sentence summary
- Concept pages: definition, intuition, formal statement, connections, common pitfalls
- Formula pages: statement, derivation (link to proof page), when to use, worked examples
- Proof pages: theorem statement, step-by-step proof, intuition for each step, related proofs
- Example pages: problem, solution step-by-step, underlying concept link, variations

## Index.md format

Organized by category. Each entry:
```
- [Page Title](path.md) — one-line summary (lecture N, YYYY-MM-DD)
```

## Log.md format

Append-only. Each entry: `## [YYYY-MM-DD] operation | Title`. Parseable with `grep "^## \[" wiki/log.md`.

## Key rules

- The LLM writes and maintains the wiki. The user curates sources and asks questions.
- Never modify files in `raw/` — they are immutable.
- Every operation updates `index.md` and appends to `log.md`.
- Good query answers get filed back into the wiki — explorations compound.
- When new material redefines an earlier concept, go back and update the earlier page.
- Keep `mastery.md` in sync — after every learning interaction, consider whether grasp levels should change.
- When in doubt, read `log.md` tail, `index.md`, and `mastery.md` to understand current state.

See [references/operations.md](references/operations.md) for detailed workflows.
See [references/page-templates.md](references/page-templates.md) for page format examples.
