# Release Checklist

Use this before publishing or tagging a release.

## Required

- `ruby scripts/validate_skill.rb` passes.
- `make validate` passes.
- The GitHub Actions validation workflow matches the local validator command.
- `git status --short` is clean except for intentional release changes.
- `SKILL.md` frontmatter has `name` and a narrow `description`.
- `SKILL.md` remains within the target line budget.
- `README.md` explains install, trigger scope, validation, safety, and competitive positioning.
- Localized README files link back to each other and do not contradict the English README.
- Japanese and Korean README files should not leave major English section headings untranslated.
- Prompt X-Ray positioning and the Prompt X-Ray Report shape are reflected in README, SKILL.md, examples, and expected-behavior cases.
- `tests/README.md` lists all 15 Prompt X-Ray cases.
- `VERSION` matches the intended Git tag.
- `CHANGELOG.md` has an entry for the release.
- `LICENSE` holder matches the GitHub account or organization publishing the repo.
- `.gitignore` contains only entries relevant to this repository.
- `SECURITY.md` tells users not to paste sensitive reports into public issues.
- GitHub private vulnerability reporting is enabled, or `SECURITY.md` is updated with a maintainer security email.
- `CODE_OF_CONDUCT.md` exists.

## Recommended

- Keep the animated demo near the top of `README.md` and backed by `assets/demo.cast` plus `assets/demo-session.txt`.
- For a future launch refresh, re-record the demo from `docs/demo-script.md` in a fresh public agent session.
- Deferred demo or growth items are tracked in `ROADMAP.md`.
- Run the manual scenarios in `examples/test-matrix.md` in a fresh agent session.
- Ask an external reviewer to check the README for overstated claims, brand risk, and unclear value.
- Confirm there are no private paths, tokens, credentials, customer data, or local-only assumptions.

## Do Not Do Automatically

- Do not create a GitHub repository, push, tag, or publish without explicit user confirmation.
- Do not add telemetry, hosted services, or external dependencies without a concrete need.
