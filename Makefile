.PHONY: validate

validate:
	python3 scripts/validate_skill.py
	python3 scripts/validate_cases.py
