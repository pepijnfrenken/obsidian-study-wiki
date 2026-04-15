# Study Wiki Operations — Detailed Reference

## INIT Workflow

When setting up a new wiki:

1. **Create directory structure:**
   ```
   raw/
   raw/assets/
   wiki/
   wiki/concepts/
   wiki/formulas/
   wiki/proofs/
   wiki/examples/
   wiki/exercises/
   wiki/sources/
   wiki/queries/
   wiki/courses/
   wiki/exam-prep/
   ```

2. **Write `wiki/schema.md`** with default conventions. Include:
   - Page naming convention (lowercase, hyphens, e.g., `bayes-theorem.md`)
   - Frontmatter fields and their meanings
   - Cross-referencing conventions (always use `[[wikilinks]]`)
   - How to handle multi-course wikis
   - Note: this file is co-evolved with the user — ask if they want to customize anything

3. **Create `wiki/index.md`:**
   ```markdown
   # Wiki Index

   ## Overview
   (no pages yet)

   ## Courses
   (no pages yet)

   ## Concepts
   (no pages yet)

   ## Formulas
   (no pages yet)

   ## Proofs & Derivations
   (no pages yet)

   ## Worked Examples
   (no pages yet)

   ## Exercises
   (no pages yet)

   ## Sources
   (no pages yet)

   ## Queries
   (no pages yet)

   ## Exam Prep
   (no pages yet)
   ```

4. **Create `wiki/log.md`:**
   ```markdown
   # Wiki Log
   ```

5. **Create `wiki/mastery.md`:**
   ```markdown
   # Mastery Profile

   > Tracks understanding across all topics. The LLM updates this after learning sessions.
   > You can also edit this directly — your manual ratings take precedence.

   ## Grasp Levels
   | Level | Label | Meaning |
   |-------|-------|---------|
   | 5 | Mastered | Can teach it, apply in novel contexts |
   | 4 | Strong | Understand well, minor gaps only |
   | 3 | Comfortable | Get the idea, can work through with effort |
   | 2 | Shaky | Know the surface, struggle with application |
   | 1 | Exposed | Seen it, don't really get it yet |
   | 0 | Uncovered | On the syllabus but not yet encountered |

   ## Topics
   (populated during ingest or from syllabus)

   ## Session Notes
   (appended after each learning session)
   ```

6. **Create `wiki/overview.md`:**
   ```markdown
   ---
   title: Overview
   type: overview
   created: YYYY-MM-DD
   updated: YYYY-MM-DD
   ---
   # Study Wiki Overview

   (This page will be updated as sources are ingested.)

   ## Formula Index
   (will be populated during ingest)
   ```

7. **Ask the user:**
   - Which course(s) are they studying?
   - Do they have a syllabus or course outline to seed the structure?
   - Any preferred conventions (naming, frontmatter, language)?

8. **If a syllabus was provided**, pre-populate `mastery.md` with all topics from the syllabus at level 0 (uncovered). Group by course if multi-course.

9. **If `raw/` already has files**, offer to run the normal interactive INGEST flow on them immediately.

---

## INGEST Workflow

When a new source is added to `raw/`:

1. **Read the source** — full content. Note format: lecture slides, textbook chapter, problem set, typed notes, images.

2. **Extract key information:**
   - Main concepts and definitions
   - Formulas and theorems (with precise statements)
   - Proofs and derivations
   - Worked examples
   - Notation conventions
   - How this material connects to earlier material
   - Contradictions or generalizations of earlier concepts
   - Prerequisites and dependencies

3. **Discuss with user** (if interactive) — share 3-5 key takeaways. Ask:
   - "What should I emphasize or expand on?"
   - "Were there parts that were confusing?"
   - "Any concepts you want flagged for review?"

4. **Write source summary** — `sources/<slugified-title>.md`:
   ```yaml
   ---
   title: "Lecture 7 — Hypothesis Testing"
   type: source
   course: "Statistics 201"
   lecture: "Lecture 7"
   tags: [hypothesis-testing, p-values, significance]
   created: 2026-04-14
   updated: 2026-04-14
   sources: [raw/lecture-07-hypothesis-testing.pdf]
   ---
   ```
   Body: structured summary (not a copy), key formulas, main arguments, connections to previous lectures.

5. **Create or update concept pages** — for each significant concept:
   - If `concepts/<concept>.md` exists: add new information, update synthesis, note if this source confirms or contradicts existing understanding
   - If new: create page with definition, intuition, formal statement, connections, common pitfalls
   - Add `[[wikilinks]]` to related concepts, formulas, proofs
   - Flag with `to-revisit: true` if the concept is incomplete or needs more sources

6. **Create or update formula pages** — for each significant formula:
   - If `formulas/<formula>.md` exists: check if the new source adds conditions, special cases, or corrections
   - If new: create page with statement, derivation link, when to use, worked example link
   - Ensure each formula links to its proof/derivation page and at least one worked example

7. **Create or update proof/derivation pages** — for significant proofs:
   - Step-by-step derivation with intuition for each step
   - Link to theorem statement in the relevant concept page
   - Link to any formulas produced
   - Note proof technique used (induction, contradiction, construction, etc.)

8. **Update cross-references** — ensure all new pages link to relevant existing pages and vice versa. Specifically:
   - Concepts mentioned in the source that have existing pages → add links
   - Formulas used in proofs → link to formula pages
   - Earlier concepts that this lecture generalizes → update the earlier page too
   - Cross-course connections (e.g., eigenvalues in both Linear Algebra and Statistics)

9. **Update `overview.md`** — if the new source changes the big picture:
   - Add new formula to the formula index
   - Note new themes or connections
   - Update the course-level synthesis

10. **Update `index.md`** — add entries for all new pages, update summaries for modified pages. Keep organized by category.

11. **Append to `log.md`:**
    ```markdown
    ## [2026-04-14] ingest | Lecture 7 — Hypothesis Testing
    - Source: raw/lecture-07-hypothesis-testing.pdf
    - Course: Statistics 201
    - Pages created: concepts/p-value.md, formulas/z-test.md, proofs/central-limit-theorem.md
    - Pages updated: concepts/hypothesis-testing.md, overview.md
    - Total pages touched: 8
    ```

12. **Update `mastery.md`:**
    - Add any new topics at level 1 (exposed)
    - If the user discussed a topic in depth during step 3 and demonstrated understanding, set it to 2-3
    - If the user flagged confusion about a topic, set it to 1-2 and add specific weak areas
    - Update the `Session Notes` section:
      ```markdown
      ### 2026-04-14 — ingest: Lecture 7
      - New topics: p-value (1), z-test (1), hypothesis-testing (2 — user seemed comfortable with basics)
      - User flagged: confused about one-tailed vs. two-tailed tests
      ```

---

## QUERY Workflow

When the user asks a course-related question:

1. **Read `index.md`** — scan for relevant pages by topic, tags, course, summaries.

2. **Read relevant pages** — follow wikilinks to gather connected information. Read 2-3 levels deep for synthesis questions.

3. **Synthesize answer:**
   - Cite wiki pages: `As shown in [[bayes-theorem]], ...`
   - Include step-by-step derivations for proof-related questions
   - Use comparison tables for "compare X and Y" questions
   - Note confidence — well-supported (multiple sources) vs. single-source
   - Flag contradictions if different sources disagree
   - Identify gaps — what the wiki doesn't cover yet

4. **Decide whether to file the answer:**
   - Does it synthesize across multiple pages in a new way? → File in `queries/`
   - Is it a simple lookup? → Don't file
   - Did it reveal a new connection? → File and add cross-references
   - Did it work through a proof or derivation interactively? → File in `queries/` or `proofs/`
   - Did it produce practice questions? → File in `exam-prep/`

5. **If filing:** write the page with frontmatter, update cross-references, update `index.md`.

6. **Append to `log.md`:**
   ```markdown
   ## [2026-04-14] query | How does the CLT relate to hypothesis testing?
   - Pages consulted: concepts/central-limit-theorem.md, concepts/hypothesis-testing.md, formulas/z-test.md
   - Answer filed: queries/clt-and-hypothesis-testing.md
   ```

7. **Update `mastery.md`:**
   - If the user asked about a topic, it signals engagement — consider bumping the level up
   - If the user seemed to understand the answer well, promote by 1 level
   - If the user asked follow-up questions that revealed confusion, hold or demote
   - Append to `Session Notes`:
     ```markdown
     ### 2026-04-14 — query: CLT and hypothesis testing
     - central-limit-theorem: 3 → 4 (user grasped the connection quickly)
     - hypothesis-testing: 2 → 2 (still shaky on p-value interpretation)
     ```

---

## DRILL Workflow

Periodic health check of the wiki:

1. **Read all pages** — build a map of the wiki's current state.

2. **Check for issues:**

   | Check | What to look for |
   |---|---|
   | Missing concepts | Terms mentioned frequently but lacking their own page |
   | Formula gaps | Formulas referenced but without a dedicated page |
   | Missing derivations | Formulas without a linked proof/derivation |
   | Orphan pages | Pages with no inbound wikilinks |
   | Broken links | Wikilinks pointing to non-existent pages |
   | Thin pages | Pages with very little content that could be expanded |
   | Stale claims | Older pages superseded by newer lectures |
   | Contradictions | Two pages making conflicting claims |
   | Uncovered topics | Course outline items not yet in the wiki |
   | Revisit flags | Pages with `to-revisit: true` that haven't been updated |

3. **Fix what you can:**
   - Add missing cross-references
   - Create stub pages for frequently-mentioned concepts
   - Fix broken wikilinks
   - Update stale claims from newer sources

4. **Report what needs user input:**
   - Contradictions requiring human judgment
   - Topics that need more source material
   - Areas the user should review before exams
   - Priority list of topics to strengthen

5. **Append to `log.md`:**
   ```markdown
   ## [2026-04-14] drill | Weekly health check
   - Issues found: 3 missing concepts, 2 orphan pages, 1 thin page
   - Fixed: created 2 concept stubs, added cross-references to orphans
   - Needs attention: concepts/mle.md is thin — needs more examples
   - Suggested sources: lecture 9 for MLE derivation
   ```

6. **Cross-reference with `mastery.md`:**
   - For each topic rated shaky (1-2), check if the wiki page is also thin or missing examples — these are the highest priority gaps
   - For topics rated comfortable (3+) that haven't been assessed in a while (stale), flag for a quick re-check
   - Identify "knowledge decay risk": topics that were assessed as strong a long time ago and haven't been revisited
   - Append mastery-specific findings to the drill log entry

7. **Update `mastery.md`:**
   - Treat any topic whose `last assessed` date is more than 2 weeks old as stale during the drill
   - If you created new stub pages during the drill, add those topics to mastery.md at level 0-1 if not already tracked
   - Append to `Session Notes`:
     ```markdown
     ### 2026-04-14 — drill: Weekly health check
     - Stale assessments: central-limit-theorem (last assessed 2026-03-28), bayes-theorem (last assessed 2026-03-30)
     - Topics needing exercises: mle (mastery 2, no exercises filed), confidence-intervals (mastery 3, 1 exercise)
     ```

---

## EXAM-PREP Workflow

Before an exam:

1. **Scope the exam** — ask which course, which topics, what format (multiple choice, proofs, calculations, essays).

2. **Read `mastery.md`** — identify weak areas (level 1-2), unassessed topics, and stale assessments.

3. **Read all relevant pages** — filter by `course`, `exam-relevant: true`, and the relevant topic tags.

4. **Identify high-priority topics** (ordered by importance):
   - Topics rated shaky (1-2) in `mastery.md` — these need the most work
   - Unassessed or stale topics — may have hidden gaps
   - Heavily cross-referenced concept pages (core material)
   - Formula-dense pages
   - Pages flagged `to-revisit: true`
   - Topics where exercises reveal recurring patterns
   - Concepts that connect multiple lecture topics

5. **Generate exam materials**, weighted toward weak areas:
   - More practice questions on shaky topics than on mastered ones
   - A formula sheet organized by topic
   - A revision plan that spends ~60% of time on weak areas and ~40% reinforcing strong ones
   - Quick-reference cards for key derivations

6. **File everything** in `exam-prep/` with appropriate frontmatter:
   ```yaml
   ---
   title: "Statistics 201 — Midterm Practice Questions"
   type: exam-prep
   course: "Statistics 201"
   tags: [midterm, practice-questions]
   exam-date: 2026-04-20
   created: 2026-04-14
   updated: 2026-04-14
   ---
   ```

7. **Update `index.md` and `log.md`.**

8. **Update `mastery.md`:**
   - If the user worked through practice questions, update levels based on performance
   - If the user struggled with certain topics, demote or flag for revisit
   - Append to `Session Notes`:
     ```markdown
     ### 2026-04-14 — exam-prep: Statistics 201 Midterm
     - bayes-theorem: 3 → 4 (solved 4/5 practice questions correctly)
     - hypothesis-testing: 2 → 1 (struggled with p-value interpretation)
     - Revision plan: focus on hypothesis-testing (2 hrs), then mle (1.5 hrs)
     ```

---

## FILE-EXERCISE Workflow

When working through problem sets or exercises:

1. **Record the exercise** — problem statement, source (problem set number, textbook chapter).

2. **Record the solution** — step-by-step, with links to the concepts and formulas used at each step.

3. **Identify the underlying concept** — what does this exercise test? Link to the relevant concept page.

4. **Identify patterns** — note recurring formulas, proof techniques, or common mistake patterns. Update the relevant concept/formula pages with these observations.

5. **File in `exercises/`:**
   ```yaml
   ---
   title: "Problem Set 3 — Question 5"
   type: exercise
   course: "Statistics 201"
   tags: [mle, estimation, fisher-information]
   difficulty: intermediate
   concepts: [maximum-likelihood-estimation, fisher-information]
   formulas: [mle-normal-distribution, cramers-inequality]
   created: 2026-04-14
   updated: 2026-04-14
   sources: [raw/problem-set-3.pdf]
   ---
   ```

6. **Update `index.md` and `log.md`.**

7. **Update `mastery.md`:**
   - If the user solved correctly without help, promote the relevant concept(s) by 1 level
   - If the user needed hints or made mistakes, hold or demote
   - Note specific weak areas (e.g., "sets up the likelihood correctly but struggles with the differentiation step")
   - Append to `Session Notes`:
     ```markdown
     ### 2026-04-14 — exercise: PS3 Q5
     - maximum-likelihood-estimation: 2 → 3 (solved correctly after one hint on log-likelihood setup)
     - fisher-information: 1 → 2 (could state the formula but not derive it)
     ```

```markdown
# Wiki Index

## Overview
- [Overview](overview.md) — High-level synthesis and formula index (updated 2026-04-14)

## Courses
- [Statistics 201](courses/statistics-201.md) — Introductory Statistics (14 lectures, updated 2026-04-14)

## Concepts
- [Bayes' Theorem](concepts/bayes-theorem.md) — Posterior from prior and likelihood (Lecture 5, 2026-04-10)
- [Central Limit Theorem](concepts/central-limit-theorem.md) — Convergence of sample means to normal (Lecture 6, 2026-04-12)

## Formulas
- [Bayes' Formula](formulas/bayes-formula.md) — P(A|B) = P(B|A)P(A)/P(B) (Lecture 5, 2026-04-10)

## Proofs & Derivations
- [CLT Derivation](proofs/clt-derivation.md) — Proof via moment-generating functions (Lecture 6, 2026-04-12)

## Worked Examples
- [Medical Test Example](examples/medical-test.md) — Classic Bayes' theorem application (Lecture 5, 2026-04-10)

## Exercises
- [PS3 Q5 — MLE for Normal](exercises/ps3-q5-mle-normal.md) — MLE derivation with Fisher information (PS3, 2026-04-14)

## Sources
- [Lecture 7 — Hypothesis Testing](sources/lecture-07-hypothesis-testing.md) — (2026-04-14)

## Queries
- [CLT and Hypothesis Testing](queries/clt-and-hypothesis-testing.md) — How CLT enables z-tests (2026-04-14)

## Exam Prep
- [Midterm Practice Questions](exam-prep/midterm-practice.md) — 20 questions covering lectures 1-7 (2026-04-14)
```

---

## Log.md Conventions

```markdown
# Wiki Log

## [2026-04-14] ingest | Lecture 7 — Hypothesis Testing
- Source: raw/lecture-07-hypothesis-testing.pdf
- Course: Statistics 201
- Pages created: concepts/p-value.md, formulas/z-test.md
- Pages updated: concepts/hypothesis-testing.md, overview.md
- Total pages touched: 8

## [2026-04-14] query | How does the CLT relate to hypothesis testing?
- Pages consulted: concepts/central-limit-theorem.md, concepts/hypothesis-testing.md
- Answer filed: queries/clt-and-hypothesis-testing.md

## [2026-04-14] ingest | Lecture 8 — Maximum Likelihood Estimation
- Source: raw/lecture-08-maximum-likelihood-estimation.pdf
- Course: Statistics 201
- Pages created: concepts/maximum-likelihood-estimation.md, formulas/mle-normal-distribution.md
- Pages updated: overview.md, mastery.md
- Total pages touched: 6

## [2026-04-14] drill | Weekly health check
- Issues found: 2 missing concepts, 1 orphan page
- Fixed: created concept stubs, added cross-references
```

Entries are parseable: `grep "^## \[" wiki/log.md | tail -5` shows last 5 operations.

---

---

## MASTERY-CHECK Workflow

Explicit assessment of the user's understanding across topics:

1. **Read `mastery.md`** — get current grasp levels and identify stale assessments.

2. **Choose assessment method** based on context:
   - **Self-assessment**: Ask the user to rate their comfort on recent topics. Quick but subjective.
   - **Quiz-based**: Ask 2-3 targeted questions per topic and evaluate responses. More accurate but slower.
   - **Review-based**: Walk through exercises the user has filed and evaluate performance patterns.

3. **For each topic assessed:**
   - Compare the new assessment with the current level
   - If there's a significant change (up or down), note why
   - Identify specific weak areas within the topic (not just "shaky" — what specifically is shaky?)

4. **Update `mastery.md`:**
   - Update the grasp level for each assessed topic
   - Update the `last assessed` date in `YYYY-MM-DD` form
   - Update the `evidence` field with what informed the rating
   - If the level changed, add an entry to the topic's history

5. **Generate a mastery summary for the user:**
   - Topics by level (visual overview of where they stand)
   - Biggest improvements since last check
   - Topics that are decaying (were higher before, now lower)
   - Priority list of what to work on next

6. **Append to `log.md`:**
   ```markdown
   ## [2026-04-14] mastery-check | Weekly assessment
   - Topics assessed: 8
   - Improved: bayes-theorem (2→4), central-limit-theorem (3→4)
   - Declined: probability-axioms (4→3 — forgot axioms, needed prompting)
   - Stable: hypothesis-testing (2), confidence-intervals (3)
   - Priority review: hypothesis-testing, mle
   ```

7. **Append to `mastery.md` Session Notes:**
   ```markdown
   ### 2026-04-14 — mastery-check: Weekly assessment
   - bayes-theorem: 2 → 4 (solved 3 practice problems without help)
   - central-limit-theorem: 3 → 4 (explained the proof intuitively)
   - probability-axioms: 4 → 3 (last assessed 2026-03-28; forgot the third axiom)
   - hypothesis-testing: 2 → 2 (still mixing up type I/II errors)
   ```

---

## mastery.md Format

The mastery file has three sections:

### Section 1: Topics

Each topic entry tracks:

```markdown
- **central-limit-theorem** — last assessed: 2026-04-14 — evidence: quiz-based (explained proof intuitively, connected to hypothesis testing) — weak areas: (none identified)
  - level: 4 (Strong)
  - course: Statistics 201
  - history:
    - 2026-04-14: 3 → 4 (quiz — explained proof intuitively)
    - 2026-04-10: 2 → 3 (query — answered CLT question with follow-up)
    - 2026-04-08: 1 → 2 (ingest — discussed lecture 6, seemed comfortable)
    - 2026-04-08: 0 → 1 (ingest — first exposure in lecture 6)
```

Topics are grouped by course. Within a course, sorted by level (weakest first) so the user sees gaps immediately.

### Section 2: Summary Statistics

Auto-maintained counts:

```markdown
## Summary

| Course | Total | Uncovered | Exposed | Shaky | Comfortable | Strong | Mastered |
|--------|-------|-----------|---------|-------|-------------|--------|----------|
| Statistics 201 | 18 | 3 | 4 | 3 | 4 | 3 | 1 |
```

### Section 3: Session Notes

Append-only log of mastery updates, organized by session. Each entry notes:
- Date and operation type
- Per-topic level changes with brief evidence
- Specific weak areas identified
- User flags (e.g., "wants to revisit this before midterm")

---

## Multi-course wikis

When the wiki covers multiple courses:

- Add `course: "Course Name"` to frontmatter on every page
- Create a course overview page in `courses/<course>.md` with syllabus, topics covered, and links to all relevant pages
- When ingesting, explicitly check for cross-course connections:
  - Overlapping concepts (e.g., eigenvalues in Linear Algebra and Statistics)
  - Shared prerequisites (e.g., calculus used in both Physics and Economics)
  - Reinforcing material (same concept taught from different angles)
- In `overview.md`, maintain a cross-course concept map noting these connections
- In index.md, organize by course first, then by category within each course
