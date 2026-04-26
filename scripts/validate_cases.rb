#!/usr/bin/env ruby
# encoding: UTF-8
# frozen_string_literal: true

root = File.expand_path("..", __dir__)
case_dir = File.join(root, "tests/prompt-xray")
files = Dir.glob(File.join(case_dir, "*.md")).sort
expected_numbers = (1..20).to_a
allowed_modes = %w[Create Analyze Rewrite Test Compare Package None]

def section(content, heading)
  pattern = /^## #{Regexp.escape(heading)}\n(.*?)(?=^## |\z)/m
  content[pattern, 1]&.strip
end

def input_prompt_section(content)
  content[/^## Input Prompt\n\n(```text\n.*?\n```)\n\n## Expected Mode/m, 1]&.strip
end

failures = []
numbers = []

files.each do |file|
  rel = file.delete_prefix("#{root}/")
  content = File.read(file, encoding: "UTF-8")
  basename = File.basename(file)
  number = basename[/\A(\d{2})-/, 1]&.to_i
  numbers << number if number

  failures << "#{rel}: filename must start with NN-" unless number
  failures << "#{rel}: title must start with # Case #{format("%02d", number)}:" unless content.start_with?("# Case #{format("%02d", number)}:")

  input = input_prompt_section(content)
  mode = section(content, "Expected Mode")
  findings = section(content, "Expected X-Ray Findings")
  repair = section(content, "Minimal Repair")

  failures << "#{rel}: missing Input Prompt section" unless input
  failures << "#{rel}: missing Expected Mode section" unless mode
  failures << "#{rel}: missing Expected X-Ray Findings section" unless findings
  failures << "#{rel}: missing Minimal Repair section" unless repair

  if input && !input.match?(/\A```text\n.*\n```\z/m)
    failures << "#{rel}: Input Prompt must be a fenced text block"
  end

  if mode
    modes = mode.split(%r{\s*/\s*|\s*,\s*|\s+or\s+}).reject(&:empty?)
    unknown = modes - allowed_modes
    failures << "#{rel}: unknown Expected Mode value(s): #{unknown.join(", ")}" unless unknown.empty?
  end

  if findings
    bullet_count = findings.lines.count { |line| line.start_with?("- ") }
    failures << "#{rel}: Expected X-Ray Findings needs at least 2 bullet findings" if bullet_count < 2
  end

  if repair && repair.length < 40
    failures << "#{rel}: Minimal Repair is too short to be useful"
  end

  next unless number && [16, 17, 18].include?(number) && input

  prompt_body = input[/\A```text\n(.*)\n```\z/m, 1] || ""
  prompt_lines = prompt_body.lines.count
  unless (30..80).cover?(prompt_lines)
    failures << "#{rel}: long-form case input must be 30-80 lines, got #{prompt_lines}"
  end
end

if numbers.sort != expected_numbers
  failures << "case numbers must be consecutive #{expected_numbers.first}-#{expected_numbers.last}; got #{numbers.compact.sort.inspect}"
end

if files.length != expected_numbers.length
  failures << "expected #{expected_numbers.length} case files, got #{files.length}"
end

if failures.empty?
  puts "PASS prompt-xray case structure"
  puts "case_files=#{files.length} long_form_cases=3 subtle_injection_cases=2"
else
  failures.each { |failure| warn "FAIL #{failure}" }
  abort "Case validation failed: #{failures.length} issue(s)"
end
