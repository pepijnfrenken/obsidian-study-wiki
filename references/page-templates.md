# Page Templates — Study Wiki

## Concept Page

```markdown
---
title: Central Limit Theorem
type: concept
course: "Statistics 201"
lecture: "Lecture 6"
tags: [probability, distributions, sampling, normal-distribution]
difficulty: intermediate
exam-relevant: true
to-revisit: false
created: 2026-04-12
updated: 2026-04-14
sources: [raw/lecture-06-sampling-distributions.pdf]
---

# Central Limit Theorem

The Central Limit Theorem (CLT) states that the sampling distribution of the sample mean approaches a normal distribution as the sample size grows, regardless of the underlying population distribution. This is the foundation for much of inferential statistics.

## Intuition

Even if the population is wildly non-normal (skewed, bimodal, uniform), if you take many samples and compute their means, those means will cluster in a bell curve. The larger each sample, the tighter the bell.

## Formal Statement

Let $X_1, X_2, \ldots, X_n$ be i.i.d. random variables with mean $\mu$ and variance $\sigma^2$. Then as $n \to \infty$:

$$\bar{X}_n = \frac{1}{n}\sum_{i=1}^n X_i \xrightarrow{d} N\left(\mu, \frac{\sigma^2}{n}\right)$$

Equivalently: $\frac{\bar{X}_n - \mu}{\sigma/\sqrt{n}} \xrightarrow{d} N(0, 1)$

## Conditions
- Samples must be independent
- Samples must be identically distributed
- Sample size $n$ should be "large enough" (rule of thumb: $n \geq 30$)
- Finite mean and variance required

## Key Connections
- Enables [[z-test]] and [[t-test]] for hypothesis testing
- Related to [[law-of-large-numbers]] (weaker result about convergence in probability)
- Proof uses [[moment-generating-functions]] → see [[clt-derivation]]
- Application: [[confidence-intervals]] rely on CLT

## Common Pitfalls
- CLT applies to the **sample mean**, not to individual observations
- "Large enough" $n$ depends on how non-normal the population is
- For small $n$ from a normal population, use the exact [[t-distribution]] instead

## Worked Examples
- [[clt-simulation-example]]: Simulating CLT with uniform data
- [[medical-test-example]]: Using CLT to construct a confidence interval
```

---

## Formula Page

```markdown
---
title: Bayes' Formula
type: formula
course: "Statistics 201"
lecture: "Lecture 5"
tags: [probability, bayes, conditional-probability, posterior]
difficulty: beginner
exam-relevant: true
to-revisit: false
created: 2026-04-10
updated: 2026-04-10
sources: [raw/lecture-05-bayes.pdf]
---

# Bayes' Formula

$$P(A \mid B) = \frac{P(B \mid A) \, P(A)}{P(B)}$$

Relates the posterior probability $P(A \mid B)$ to the prior $P(A)$ and the likelihood $P(B \mid A)$.

## When to Use
- When you know the prior and likelihood and want the posterior
- Updating beliefs in light of new evidence
- Medical testing, spam filtering, diagnostic reasoning

## Derivation
See [[bayes-theorem-derivation]] — follows directly from the definition of [[conditional-probability]].

## Variables
| Symbol | Meaning |
|--------|---------|
| $P(A \mid B)$ | Posterior — probability of A given B was observed |
| $P(B \mid A)$ | Likelihood — probability of observing B if A is true |
| $P(A)$ | Prior — probability of A before observing B |
| $P(B)$ | Marginal — total probability of B (often via [[law-of-total-probability]]) |

## Worked Examples
- [[medical-test-example]]: Computing P(disease | positive test)
- [[spam-filter-example]]: Updating spam probability with word occurrences

## Related Formulas
- [[law-of-total-probability]] — for computing the denominator $P(B)$
- [[bayes-formula-extended]] — for multiple hypotheses
```

---

## Proof/Derivation Page

```markdown
---
title: CLT Derivation
type: proof
course: "Statistics 201"
lecture: "Lecture 6"
tags: [clt, proof, moment-generating-functions, convergence]
difficulty: advanced
exam-relevant: true
to-revisit: false
created: 2026-04-12
updated: 2026-04-14
sources: [raw/lecture-06-sampling-distributions.pdf]
---

# Proof of the Central Limit Theorem (via MGFs)

Proves the [[central-limit-theorem]] using the moment-generating function approach.

## Theorem Statement
See [[central-limit-theorem]] for the formal statement.

## Prerequisites
- [[moment-generating-functions]]: definition and properties
- [[taylor-expansion]]: for expanding the MGF
- [[convergence-in-distribution]]: what $\xrightarrow{d}$ means

## Proof

**Step 1: Standardize.** Let $Z_n = \frac{\bar{X}_n - \mu}{\sigma/\sqrt{n}}$. We want to show $Z_n \xrightarrow{d} N(0,1)$.

**Step 2: Work with MGFs.** It suffices to show the MGF of $Z_n$ converges to the MGF of $N(0,1)$, which is $e^{t^2/2}$.

> This uses the [[continuity-theorem]] — convergence of MGFs implies convergence in distribution.

**Step 3: Expand the MGF of a single term.** Let $Y_i = (X_i - \mu)/\sigma$. Then:
$$M_{Y_i}(t) = 1 + \frac{t^2}{2} + o(t^2)$$
since $E[Y_i] = 0$ and $E[Y_i^2] = 1$.

> Key insight: we only need the first two moments because higher-order terms vanish as $n \to \infty$.

**Step 4: Compose.** $Z_n = \frac{1}{\sqrt{n}} \sum Y_i$, so:
$$M_{Z_n}(t) = \left[M_{Y_i}\left(\frac{t}{\sqrt{n}}\right)\right]^n = \left[1 + \frac{t^2}{2n} + o(1/n)\right]^n$$

**Step 5: Take the limit.** As $n \to \infty$:
$$\lim_{n \to \infty} \left[1 + \frac{t^2}{2n}\right]^n = e^{t^2/2}$$

This is the MGF of $N(0,1)$. $\blacksquare$

## Proof Technique Used
- MGF method — standard approach for proving distributional convergence
- Related: [[characteristic-function-approach]] (more general, doesn't require MGF to exist)

## Related Proofs
- [[law-of-large-numbers-proof]] — weaker result, easier proof
- [[chebyshev-inequality-proof]] — alternative approach for the weak LLN
```

---

## Worked Example Page

```markdown
---
title: Medical Test Example
type: example
course: "Statistics 201"
lecture: "Lecture 5"
tags: [bayes-theorem, conditional-probability, medical-testing]
difficulty: beginner
exam-relevant: true
to-revisit: false
created: 2026-04-10
updated: 2026-04-10
sources: [raw/lecture-05-bayes.pdf]
concepts: [bayes-theorem, conditional-probability]
formulas: [bayes-formula, law-of-total-probability]
---

# Medical Test Example — Bayes' Theorem

Classic application of [[bayes-formula]] to medical testing.

## Problem
A disease affects 1% of the population. A test has 99% sensitivity (P(+ | disease) = 0.99) and 95% specificity (P(- | no disease) = 0.95). If you test positive, what is the probability you have the disease?

## Solution

**Step 1: Identify the given information.**
- Prior: P(disease) = 0.01
- Likelihood: P(+ | disease) = 0.99
- P(- | no disease) = 0.95, so P(+ | no disease) = 0.05

**Step 2: Compute the marginal P(+).**
Using the [[law-of-total-probability]]:
$$P(+) = P(+ | D)P(D) + P(+ | D^c)P(D^c) = 0.99 \times 0.01 + 0.05 \times 0.99 = 0.0594$$

**Step 3: Apply [[bayes-formula]].**
$$P(D | +) = \frac{P(+ | D)P(D)}{P(+)} = \frac{0.99 \times 0.01}{0.0594} = \frac{0.0099}{0.0594} \approx 0.167$$

## Answer
Only ~16.7% — despite the test being quite accurate! This is the **base rate fallacy** in action.

## Key Takeaway
When the prior probability is low, even a highly specific test produces mostly false positives. The intuition: 5% of 99 healthy people (≈5 false positives) vastly outnumbers 99% of 1 sick person (≈1 true positive).

## Variations
- What if the disease prevalence were 10%? → P(D|+) jumps to ~69%
- What if you get a second positive test? → Apply Bayes again with P(D|+) as the new prior
```

---

## Exercise Page

```markdown
---
title: "PS3 Q5 — MLE for Normal Distribution"
type: exercise
course: "Statistics 201"
tags: [mle, normal-distribution, estimation, fisher-information]
difficulty: intermediate
exam-relevant: true
to-revisit: false
concepts: [maximum-likelihood-estimation, fisher-information]
formulas: [mle-normal-distribution, cramers-inequality]
created: 2026-04-14
updated: 2026-04-14
source: raw/problem-set-3.pdf
---

# Problem Set 3, Question 5 — MLE for Normal Distribution

## Problem Statement
Let $X_1, \ldots, X_n \sim N(\mu, \sigma^2)$. Find the MLE for both $\mu$ and $\sigma^2$.

## Solution

### Part 1: MLE for $\mu$

The likelihood function:
$$L(\mu, \sigma^2) = \prod_{i=1}^n \frac{1}{\sqrt{2\pi\sigma^2}} \exp\left(-\frac{(x_i - \mu)^2}{2\sigma^2}\right)$$

Log-likelihood:
$$\ell(\mu, \sigma^2) = -\frac{n}{2}\ln(2\pi\sigma^2) - \frac{1}{2\sigma^2}\sum(x_i - \mu)^2$$

Taking derivative with respect to $\mu$ and setting to zero:
$$\frac{\partial \ell}{\partial \mu} = \frac{1}{\sigma^2}\sum(x_i - \mu) = 0 \implies \hat{\mu} = \bar{X}$$

> The MLE for $\mu$ is the sample mean. See [[maximum-likelihood-estimation]] for the general procedure.

### Part 2: MLE for $\sigma^2$

Taking derivative with respect to $\sigma^2$ and setting to zero:
$$\hat{\sigma}^2 = \frac{1}{n}\sum(X_i - \bar{X})^2$$

> Note: this is the biased version. For unbiased, divide by $n-1$ instead. See [[bias-variance-tradeoff]].

## Concepts Tested
- [[maximum-likelihood-estimation]] — the core procedure
- [[log-likelihood]] — why we work with the log
- [[fisher-information]] — for computing the variance of the MLE

## Patterns
This exercise follows the standard MLE pattern: write likelihood → take log → differentiate → solve. This pattern appears in [[ps2-q3-mle-exponential]] and [[ps4-q1-mle-uniform]].
```

---

## Source Summary Page

```markdown
---
title: "Lecture 7 — Hypothesis Testing"
type: source
course: "Statistics 201"
lecture: "Lecture 7"
tags: [hypothesis-testing, p-values, significance, type-i-error]
created: 2026-04-14
updated: 2026-04-14
original: raw/lecture-07-hypothesis-testing.pdf
---

# Lecture 7 — Hypothesis Testing

## Summary
Introduced the hypothesis testing framework: null/alternative hypotheses, test statistics, p-values, and decision rules. Connected to [[central-limit-theorem]] for z-tests.

## Key Concepts Introduced
- Null and alternative hypotheses ($H_0$, $H_1$)
- Type I and Type II errors
- Significance level $\alpha$
- P-value interpretation
- One-tailed vs. two-tailed tests

## Key Formulas
- [[z-test-statistic]]: $z = \frac{\bar{x} - \mu_0}{\sigma/\sqrt{n}}$
- [[power-function]]: Power = $1 - \beta$

## Connections to Previous Lectures
- Builds on [[central-limit-theorem]] (Lecture 6) for the sampling distribution
- Uses [[normal-distribution]] (Lecture 3) for critical values
- Extends [[confidence-intervals]] (Lecture 6) — dual relationship

## Open Questions
- When to use z-test vs. t-test? (covered in Lecture 8)
- How to handle multiple comparisons? (to be covered)
```

---

## Query Result Page

```markdown
---
title: CLT and Hypothesis Testing Connection
type: query
course: "Statistics 201"
tags: [clt, hypothesis-testing, z-test, sampling-distribution]
created: 2026-04-14
updated: 2026-04-14
---

# How does the CLT relate to hypothesis testing?

## Question
How does the Central Limit Theorem enable hypothesis testing?

## Answer

The [[central-limit-theorem]] is what makes the [[z-test]] work. Here's the chain:

1. **CLT tells us** that $\bar{X}_n$ is approximately $N(\mu, \sigma^2/n)$ for large $n$.
2. **Under $H_0$**, we know $\mu = \mu_0$, so we know the distribution of $\bar{X}_n$ under the null.
3. **Standardize**: $z = \frac{\bar{X}_n - \mu_0}{\sigma/\sqrt{n}} \sim N(0,1)$ under $H_0$.
4. **Compare**: If the observed $z$ is extreme (far in the tails), reject $H_0$.

Without CLT, we wouldn't know the sampling distribution of $\bar{X}_n$, and we couldn't compute p-values or critical regions.

**Key insight**: CLT bridges the gap between "I have a sample" and "I can make probabilistic statements about the population mean."

## Pages Consulted
- [[central-limit-theorem]]
- [[hypothesis-testing]]
- [[z-test]]
- [[p-value]]
```

---

## Exam Prep Page

```markdown
---
title: "Statistics 201 — Midterm Practice Questions"
type: exam-prep
course: "Statistics 201"
tags: [midterm, practice-questions, revision]
exam-date: 2026-04-20
created: 2026-04-14
updated: 2026-04-14
---

# Statistics 201 — Midterm Practice Questions

## Coverage
Lectures 1–7: Descriptive statistics, Probability, Random variables, Common distributions, Bayes' theorem, Sampling distributions, Hypothesis testing.

## Priority Topics (by weight and difficulty)
1. **Hypothesis testing** (Lectures 6–7) — most cross-referenced, formula-dense
2. **Bayes' theorem** (Lecture 5) — commonly tested, many students struggle
3. **CLT and sampling distributions** (Lecture 6) — foundational for inference
4. **Common distributions** (Lecture 4) — know properties and when to use each

## Practice Questions

### Q1 (Bayes' theorem — beginner)
A factory has three machines producing widgets. Machine A produces 50%, B produces 30%, C produces 20%. Defect rates: A=2%, B=3%, C=5%. If a random widget is defective, what is the probability it came from machine C?
> Tests: [[bayes-formula]], [[law-of-total-probability]]

### Q2 (CLT — intermediate)
A population has mean 100 and standard deviation 15. What is the probability that the mean of a sample of 36 exceeds 105?
> Tests: [[central-limit-theorem]], [[standardization]], [[z-test]]

### Q3 (Hypothesis testing — intermediate)
A company claims their batteries last 500 hours. A consumer group tests 40 batteries and finds $\bar{x} = 485$, $s = 60$. Test the claim at $\alpha = 0.05$.
> Tests: [[hypothesis-testing]], [[z-test]], [[p-value]]

### Q4 (Proof — advanced)
State and prove the Central Limit Theorem using moment-generating functions.
> Tests: [[clt-derivation]], [[moment-generating-functions]]

## Formula Sheet
See [[midterm-formula-sheet]] for a condensed reference.
```

---

## Mastery Profile Page

```markdown
# Mastery Profile

> Tracks understanding across all topics. The LLM updates this after learning sessions.
> You can also edit this directly — your manual ratings take precedence.
> Grasp levels: 0=Uncovered, 1=Exposed, 2=Shaky, 3=Comfortable, 4=Strong, 5=Mastered

## Summary

| Course | Total | 0 | 1 | 2 | 3 | 4 | 5 |
|--------|-------|---|---|---|---|---|---|
| Statistics 201 | 12 | 2 | 3 | 2 | 3 | 1 | 1 |

## Statistics 201

### Uncovered (0)

### Exposed (1)
- **mle** — last assessed: 2026-04-14 — evidence: ingested from lecture 8 — weak areas: don't understand the intuition behind maximizing likelihood
- **fisher-information** — last assessed: 2026-04-14 — evidence: ingested from lecture 8 — weak areas: can state the formula but not derive it

### Shaky (2)
- **hypothesis-testing** — last assessed: 2026-04-14 — evidence: query session — weak areas: mixing up type I/II errors, p-value interpretation
- **p-value** — last assessed: 2026-04-14 — evidence: query session — weak areas: common misconceptions about what p-value means

### Comfortable (3)
- **bayes-theorem** — last assessed: 2026-04-14 — evidence: quiz-based, solved 4/5 practice problems — weak areas: struggle with multi-hypothesis extensions
- **confidence-intervals** — last assessed: 2026-04-12 — evidence: exercise PS3 Q3 correct — weak areas: interpreting vs. constructing
- **probability-distributions** — last assessed: 2026-04-10 — evidence: self-assessment — weak areas: (none flagged)

### Strong (4)
- **central-limit-theorem** — last assessed: 2026-04-14 — evidence: quiz-based, explained proof intuitively — weak areas: (none)

### Mastered (5)
- **descriptive-statistics** — last assessed: 2026-04-08 — evidence: all exercises correct, taught back to LLM — weak areas: (none)

### Topic Histories

#### central-limit-theorem
- 2026-04-14: 3 → 4 (quiz — explained proof intuitively, connected to hypothesis testing)
- 2026-04-10: 2 → 3 (query — answered CLT question with good follow-up understanding)
- 2026-04-08: 1 → 2 (ingest — discussed lecture 6, seemed comfortable with basics)
- 2026-04-08: 0 → 1 (ingest — first exposure in lecture 6)

#### hypothesis-testing
- 2026-04-14: 2 → 2 (query — still mixing up type I/II errors despite review)
- 2026-04-14: 1 → 2 (ingest — could define terms but not apply)
- 2026-04-14: 0 → 1 (ingest — first exposure in lecture 7)

#### bayes-theorem
- 2026-04-14: 2 → 3 (quiz — solved 4/5 practice problems, one mistake on marginal calculation)
- 2026-04-10: 1 → 2 (query — asked about it, could state the formula)
- 2026-04-10: 0 → 1 (ingest — first exposure in lecture 5)

## Session Notes

### 2026-04-14 — mastery-check: Weekly assessment
- bayes-theorem: 2 → 3 (solved 4/5 practice problems correctly)
- central-limit-theorem: 3 → 4 (explained the proof intuitively)
- hypothesis-testing: 2 → 2 (still mixing up type I/II errors)
- mle: 0 → 1 (first exposure in lecture 8)
- fisher-information: 0 → 1 (first exposure in lecture 8)

### 2026-04-14 — ingest: Lecture 8 — Maximum Likelihood Estimation
- mle: new topic, level 1 (exposed)
- fisher-information: new topic, level 1 (exposed)
- User flagged: "MLE clicks better when I see the geometric interpretation"

### 2026-04-14 — query: CLT and hypothesis testing
- central-limit-theorem: 3 → 4 (user grasped the connection quickly)
- hypothesis-testing: 2 → 2 (still shaky on p-value interpretation)

### 2026-04-12 — exercise: PS3 Q3
- confidence-intervals: 2 → 3 (solved correctly without help)
- bayes-theorem: 1 → 2 (needed hint on marginal probability setup)

### 2026-04-08 — ingest: Lecture 6 — Sampling Distributions
- central-limit-theorem: new topic, level 1 → 2 (user engaged well with discussion)
- confidence-intervals: new topic, level 1
```
