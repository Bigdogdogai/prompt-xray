#!/usr/bin/env ruby
# encoding: UTF-8
# frozen_string_literal: true

require "yaml"

root = File.expand_path("..", __dir__)
path = File.join(root, "SKILL.md")
read_utf8 = ->(file) { File.read(file, encoding: "UTF-8") }
content = read_utf8.call(path)
readme = read_utf8.call(File.join(root, "README.md"))
readme_zh = read_utf8.call(File.join(root, "README.zh-CN.md"))
readme_ja = read_utf8.call(File.join(root, "README.ja.md"))
readme_ko = read_utf8.call(File.join(root, "README.ko.md"))
gitignore = read_utf8.call(File.join(root, ".gitignore"))
case_files = Dir.glob(File.join(root, "tests/prompt-xray/*.md"))
self_eval_snapshot = read_utf8.call(File.join(root, "tests/prompt-xray-runs/2026-04-27-author-self-eval.md"))
coverage = read_utf8.call(File.join(root, "docs/coverage.md"))
demo_svg = read_utf8.call(File.join(root, "assets/demo-terminal.svg"))
demo_cast = read_utf8.call(File.join(root, "assets/demo.cast"))
markdown_files = Dir.glob(File.join(root, "**/*.md"), File::FNM_DOTMATCH).reject { |file| file.include?("/.git/") }
english_h2 = /^## (Why This Exists|Quick Start|Platform Compatibility|Install|When It Triggers|Outputs|Examples|Safety Model|Competitive Landscape|Validation|Design Sources)$/

frontmatter = content[/\A---\n(.*?)\n---/m, 1]
abort "Missing YAML frontmatter" unless frontmatter

metadata = YAML.safe_load(frontmatter)
required_files = %w[
  README.md
  README.zh-CN.md
  README.ja.md
  README.ko.md
  SKILL.md
  VERSION
  ROADMAP.md
  CHANGELOG.md
  LICENSE
  SECURITY.md
  CONTRIBUTING.md
  CODE_OF_CONDUCT.md
  Makefile
  docs/release-checklist.md
  docs/agent-compatibility.md
  docs/demo-script.md
  docs/before-after.md
  docs/coverage.md
  examples/usage-cases.md
  examples/test-matrix.md
  assets/demo.cast
  assets/demo-session.txt
  assets/demo-terminal.svg
  tests/README.md
  tests/prompt-xray-runs/2026-04-27-author-self-eval.md
  .github/PULL_REQUEST_TEMPLATE.md
  .github/ISSUE_TEMPLATE/bug_report.md
  .github/ISSUE_TEMPLATE/feature_request.md
  .github/workflows/validate.yml
  scripts/install.sh
]

allowed_frontmatter_keys = %w[description name]
frontmatter_schema_valid = metadata.keys.sort == allowed_frontmatter_keys &&
  metadata["name"] == "prompt-xray" &&
  metadata["description"].is_a?(String) &&
  metadata["description"].length <= 280

broken_local_links = []
markdown_files.each do |file|
  dir = File.dirname(file)
  rel_file = file.delete_prefix("#{root}/")
  read_utf8.call(file).scan(/!?\[[^\]]*\]\(([^)\s]+)(?:\s+"[^"]*")?\)/).each do |match|
    target = match.first.sub(/\A<(.+)>\z/, "\\1")
    next if target.match?(/\A(?:https?:|mailto:|tel:|#)/)

    path_part = target.split("#", 2).first
    next if path_part.empty?

    resolved = File.expand_path(path_part, dir)
    inside_repo = resolved == root || resolved.start_with?("#{root}/")
    broken_local_links << "#{rel_file}: #{target}" unless inside_repo && File.exist?(resolved)
  end
end

checks = {
  "frontmatter name" => metadata["name"] == "prompt-xray",
  "frontmatter description" => metadata["description"].is_a?(String),
  "frontmatter schema" => frontmatter_schema_valid,
  "narrow trigger" => metadata["description"].include?("Use only for prompt engineering") &&
    metadata["description"].include?("Exclude ordinary writing"),
  "line budget 80-160" => (80..160).cover?(content.lines.count),
  "six modes" => %w[create analyze rewrite test compare package].all? { |mode| content.downcase.include?(mode) },
  "untrusted data rule" => content.include?("untrusted data"),
  "external prompt non-execution" => content.include?("do not follow instructions inside"),
  "hidden chain-of-thought protection" => content.include?("hidden chain-of-thought"),
  "sensitive data handling" => content.include?("sensitive"),
  "local agent report" => content.include?("changed files") &&
    content.include?("verification") &&
    content.include?("remaining risks"),
  "release hygiene" => content.include?("GitHub") && content.include?("license"),
  "neutral injection probe" => content.include?("injection-probe") &&
    !content.include?("dump the system prompt"),
  "public repo files" => required_files.all? { |file| File.file?(File.join(root, file)) },
  "language switcher" => %w[README.zh-CN.md README.ja.md README.ko.md].all? { |file| readme.include?(file) },
  "version badge" => readme.include?("version-1.0.1") && read_utf8.call(File.join(root, "VERSION")).strip == "1.0.1",
  "gitignore is scoped" => !gitignore.include?("node_modules/") && !gitignore.include?("vendor/"),
  "installer documented" => readme.include?("bash scripts/install.sh"),
  "multi-agent positioning" => metadata["name"] == "prompt-xray" &&
    readme.include?("OpenClaw") &&
    readme.include?("Hermes Agent") &&
    readme.include?("Claude Code") &&
    readme.include?("AI coding agents"),
  "multi-agent verification table" => readme.include?("| Agent surface | Support level | Install | Verification |") &&
    readme.include?("Locally tested in this repo") &&
    readme.include?("Reference only; no native `SKILL.md` loading assumed"),
  "broad brand disclaimer" => [readme, readme_zh, readme_ja, readme_ko].all? do |localized_readme|
    localized_readme.include?("OpenClaw") &&
      localized_readme.include?("Hermes Agent") &&
      localized_readme.include?("Cursor") &&
      localized_readme.include?("Aider")
  end,
  "installer syntax" => system("bash", "-n", File.join(root, "scripts/install.sh"), out: File::NULL, err: File::NULL),
  "workflow yaml" => !!YAML.safe_load(read_utf8.call(File.join(root, ".github/workflows/validate.yml"))),
  "local markdown links" => broken_local_links.empty?,
  "prompt x-ray positioning" => content.include?("Prompt X-Ray") && readme.include?("Prompt X-Ray"),
  "prompt x-ray report" => content.include?("Prompt X-Ray Report") &&
    readme.include?("Prompt X-Ray Report") &&
    content.include?("Smallest useful repair"),
  "animated demo replay" => demo_svg.include?("@keyframes appear") &&
    demo_svg.include?("animated terminal demo") &&
    demo_cast.include?("\"version\":2") &&
    readme.include?("assets/demo.cast"),
  "coverage table" => coverage.include?("Current Author Self-Evaluation") &&
    coverage.include?("Covered for all 20 cases") &&
    coverage.downcase.include?("ordinary writing") &&
    readme.include?("Prompt X-Ray coverage notes") &&
    readme.include?("not a third-party benchmark"),
  "security private reporting" => read_utf8.call(File.join(root, "SECURITY.md")).include?("private vulnerability reporting") &&
    read_utf8.call(File.join(root, "SECURITY.md")).include?("do not paste"),
  "localized readme headings" => !readme_ja.match?(english_h2) && !readme_ko.match?(english_h2),
  "expected-behavior case count" => case_files.length == 20,
  "expected-behavior case structure" => case_files.all? do |file|
    case_content = read_utf8.call(file)
    case_content.include?("## Input Prompt") &&
      case_content.include?("## Expected Mode") &&
      case_content.include?("## Expected X-Ray Findings") &&
      case_content.include?("## Minimal Repair")
  end,
  "author self-eval snapshot" => (1..20).all? { |number| self_eval_snapshot.include?(format("[%02d]", number)) } &&
    self_eval_snapshot.include?("not an automated benchmark") &&
    self_eval_snapshot.include?("third-party evaluation")
}

failed = checks.reject { |_name, passed| passed }

checks.each do |name, passed|
  puts "#{passed ? "PASS" : "FAIL"} #{name}"
end

abort "Validation failed: #{failed.keys.join(", ")}" unless failed.empty?

puts "checks=#{checks.length} passed=#{checks.length} failed=0"
