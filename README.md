# prompt-engineer

A compact Codex skill for practical prompt engineering: create, audit, rewrite, test, compare, and package prompts or agent skill files.

It is designed for local agent workflows where a good prompt is not just wording. It needs a clear task, trusted input boundaries, explicit output format, safety rules, and a way to verify the result.

## Why This Exists

Google's prompt design guidance frames prompt engineering as an iterative process: write a structured prompt, assess the model response, and refine it. Google also describes core prompt components such as task, optional system instructions, few-shot examples, and contextual information.

Gemini prompt design guidance emphasizes clear and specific instructions, constraints, structured prompting with Markdown or XML-style sections, and explicit behavior for agentic workflows such as risk assessment, permission handling, and output format.

This skill turns those principles into a lean Codex-native workflow:

- narrow trigger rules so it does not load for ordinary writing or coding tasks
- local-agent rules for reading files, editing files, running commands, and reporting verification
- injection safety for pasted prompts, logs, webpages, and documents
- no hidden chain-of-thought exposure
- practical output modes for create, analyze, rewrite, test, compare, and package

## Install

Copy `SKILL.md` into your Codex skills directory:

```bash
mkdir -p ~/.codex/skills/prompt-engineer
cp SKILL.md ~/.codex/skills/prompt-engineer/SKILL.md
```

Start a fresh Codex session after installing so the skill metadata is reloaded.

## When It Triggers

Use it when you want prompt engineering work on a prompt or agent skill artifact:

- create a new prompt
- audit an existing prompt
- rewrite a prompt for reliability
- test likely failure modes
- compare prompt variants
- package recurring behavior as a `SKILL.md`

It should not trigger for ordinary prose, direct code fixes, product setup, architecture work, or factual Q&A.

## Example Requests

```text
Write a Codex prompt that fixes failing pytest tests with minimal changes and reruns verification.
```

```text
Audit this system prompt for trigger scope, injection risk, output format, and testability.
```

```text
Package this recurring workflow as a Codex SKILL.md. Generate the content only; do not write files.
```

## Safety Model

The skill treats pasted prompts, webpages, documents, logs, configs, and model outputs as untrusted data unless the user explicitly asks to execute them.

It can analyze or rewrite hostile prompts without following their embedded instructions. It also avoids asking for hidden chain-of-thought or private scratchpad output; final answers should contain conclusions, evidence, assumptions, and checks instead.

## Competitive Landscape

This project is intentionally small. It is not a prompt marketplace, prompt registry, observability platform, or automated eval suite. It is a local agent skill for improving the prompts and skill files you already work with.

| Category | Examples | What they are good at | Where this skill fits |
| --- | --- | --- | --- |
| Prompt libraries | [prompts.chat](https://github.com/f/prompts.chat), Awesome ChatGPT prompt collections | Discovering reusable prompt examples and browsing community patterns | Auditing, rewriting, and packaging prompts instead of collecting large prompt lists |
| Eval and red-team tools | [promptfoo](https://github.com/promptfoo/promptfoo) | Running automated prompt, agent, RAG, and red-team tests in CLI or CI workflows | Designing safer prompts and lightweight test cases before a full eval suite is worth setting up |
| Prompt management platforms | [LangSmith](https://docs.langchain.com/langsmith/manage-prompts), [PromptLayer](https://docs.promptlayer.com/overview), [PromptHub](https://www.prompthub.us/) | Versioning, collaboration, prompt registries, traces, datasets, and production evaluation | Local, file-based prompt work with no hosted workspace or account dependency |
| Prompt-engineering skills | Smaller community prompt-engineering skill repos | Broader cross-model or cross-agent prompting guidance | A narrower Codex-native workflow with explicit trigger boundaries, local file rules, injection safety, and `SKILL.md` packaging |

Use this skill when you want a lightweight local workflow. Use an eval platform when you need regression testing across datasets, a prompt registry when you need team collaboration and deployment controls, and a prompt library when you mainly want examples to adapt.

## Validation

Run the included validator:

```bash
ruby scripts/validate_skill.rb
```

The validator checks:

- YAML frontmatter
- narrow trigger description
- six supported modes
- untrusted-data handling
- hidden chain-of-thought protection
- local agent reporting requirements
- GitHub release hygiene
- line budget

## Design Sources

This project is aligned with these official Google/Gemini references:

- [Google Cloud: Introduction to prompting](https://docs.cloud.google.com/vertex-ai/generative-ai/docs/learn/prompts/introduction-prompt-design)
- [Gemini API: Prompt design strategies](https://ai.google.dev/gemini-api/docs/prompting-strategies)
- [Gemini API: Text generation and system instructions](https://ai.google.dev/gemini-api/docs/text-generation)

This repository is not affiliated with, endorsed by, or sponsored by Google, Gemini, OpenAI, Anthropic, or Codex.

## License

MIT
