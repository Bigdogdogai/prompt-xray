.PHONY: validate

validate:
	ruby scripts/validate_skill.rb
	ruby scripts/validate_cases.rb
