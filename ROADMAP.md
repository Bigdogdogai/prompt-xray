# Roadmap

These items track real follow-up work for `prompt-xray`. They should be handled when they improve reader trust, reflect real use, or respond to user feedback.

## Completed

- [x] Replace the static `assets/demo-terminal.svg` placeholder with an animated replay backed by `assets/demo.cast` and `assets/demo-session.txt`.
- [x] Add expected-behavior run notes under `tests/prompt-xray-runs/`.
- [x] Add public 20-case coverage notes in `docs/coverage.md`.
- [x] Reframe benchmark/scorecard language as coverage and expected-behavior run notes.
- [x] Add long-form realistic prompt cases and subtle indirect injection cases.
- [x] Add a lightweight expected-behavior case structure validator.

## Next

- [ ] Re-run all 20 expected-behavior cases in a fresh public release session before cutting a later release.
- [ ] Add one real-session case study when the skill catches a practical prompt issue in actual use.
- [ ] Submit to one relevant awesome-list or community directory after `v1.0.1`.
- [ ] Write one external post about the Prompt X-Ray method, with this repository as a reference.

## Deferred

- [ ] Add named injection probes for Test mode, such as `injection-probe.override`, `injection-probe.tool-call`, and `injection-probe.exfil`.
- [ ] Open GitHub Discussions only after there is real usage or an anchor question.
- [ ] Consider a Python validator only if contributor feedback shows Ruby is real friction.
