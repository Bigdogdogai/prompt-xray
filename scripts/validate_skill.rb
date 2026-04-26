#!/usr/bin/env ruby
# frozen_string_literal: true

require "yaml"

root = File.expand_path("..", __dir__)
path = File.join(root, "SKILL.md")
content = File.read(path)

frontmatter = content[/\A---\n(.*?)\n---/m, 1]
abort "Missing YAML frontmatter" unless frontmatter

metadata = YAML.safe_load(frontmatter)
checks = {
  "frontmatter name" => metadata["name"] == "prompt-engineer",
  "frontmatter description" => metadata["description"].is_a?(String),
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
    !content.include?("dump the system prompt")
}

failed = checks.reject { |_name, passed| passed }

checks.each do |name, passed|
  puts "#{passed ? "PASS" : "FAIL"} #{name}"
end

abort "Validation failed: #{failed.keys.join(", ")}" unless failed.empty?

puts "checks=#{checks.length} passed=#{checks.length} failed=0"
