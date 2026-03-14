from __future__ import annotations

import json
import sys
from pathlib import Path

from jsonschema import Draft7Validator, FormatChecker


ROOT = Path(__file__).resolve().parents[1]
VERSION = (ROOT / "VERSION").read_text(encoding="utf-8").strip()

SCHEMA_BY_SUFFIX = {
    ".oca": ROOT / "schemas" / "oca.schema.json",
    ".oce": ROOT / "schemas" / "oce.schema.json",
    ".ocp": ROOT / "schemas" / "ocp.schema.json",
    ".ocr": ROOT / "schemas" / "ocr.schema.json",
    ".ocs": ROOT / "schemas" / "ocs.schema.json",
}

REQUIRED_FILES = [
    ROOT / "README.md",
    ROOT / "CONTRIBUTING.md",
    ROOT / "CODE_OF_CONDUCT.md",
    ROOT / "GOVERNANCE.md",
    ROOT / "LICENSE",
    ROOT / "LICENSES.md",
    ROOT / "CHANGELOG.md",
    ROOT / "VERSION",
    ROOT / ".github" / "workflows" / "validate.yml",
    ROOT / "specification" / "Working Draft.typ",
]


def load_json(path: Path) -> object:
    with path.open("r", encoding="utf-8") as handle:
        return json.load(handle)


def collect_relative_references(payload: object) -> list[str]:
    references: list[str] = []

    def walk(node: object) -> None:
        if isinstance(node, dict):
            for key, value in node.items():
                if key in {"source_uri", "source_sim", "uri"} and isinstance(value, str):
                    if value.startswith("./") or value.startswith("../"):
                        references.append(value)
                walk(value)
        elif isinstance(node, list):
            for item in node:
                walk(item)

    walk(payload)
    return references


def validate_required_files(errors: list[str]) -> None:
    for path in REQUIRED_FILES:
        if not path.exists():
            errors.append(f"Missing required repository file: {path.relative_to(ROOT)}")


def validate_examples(errors: list[str]) -> None:
    format_checker = FormatChecker()

    for example_path in sorted((ROOT / "examples").iterdir()):
        if example_path.suffix not in SCHEMA_BY_SUFFIX:
            continue

        payload = load_json(example_path)
        schema = load_json(SCHEMA_BY_SUFFIX[example_path.suffix])
        validator = Draft7Validator(schema, format_checker=format_checker)
        issues = sorted(validator.iter_errors(payload), key=lambda issue: list(issue.absolute_path))
        for issue in issues:
            location = "/".join(str(part) for part in issue.absolute_path) or "<root>"
            errors.append(f"Schema validation failed for {example_path.relative_to(ROOT)} at {location}: {issue.message}")

        header = payload.get("header", {}) if isinstance(payload, dict) else {}
        if header.get("version") != VERSION:
            errors.append(
                f"Version mismatch in {example_path.relative_to(ROOT)}: expected {VERSION}, found {header.get('version')}"
            )

        for reference in collect_relative_references(payload):
            target = (example_path.parent / reference).resolve()
            if not target.exists():
                errors.append(
                    f"Broken relative reference in {example_path.relative_to(ROOT)}: {reference}"
                )


def validate_schemas(errors: list[str]) -> None:
    format_checker = FormatChecker()

    for schema_path in SCHEMA_BY_SUFFIX.values():
        schema = load_json(schema_path)
        Draft7Validator.check_schema(schema)
        header = schema.get("properties", {}).get("header", {})
        required = header.get("required", [])
        if sorted(required) != ["generator", "version"]:
            errors.append(
                f"Header requirements must be ['generator', 'version'] in {schema_path.relative_to(ROOT)}"
            )

        version_schema = header.get("properties", {}).get("version", {})
        if version_schema.get("pattern") != r"^\d+\.\d+$":
            errors.append(
                f"Header version pattern missing or inconsistent in {schema_path.relative_to(ROOT)}"
            )

        Draft7Validator(schema, format_checker=format_checker)


def main() -> int:
    errors: list[str] = []
    example_count = len(
        [path for path in (ROOT / "examples").iterdir() if path.suffix in SCHEMA_BY_SUFFIX]
    )

    validate_required_files(errors)
    validate_schemas(errors)
    validate_examples(errors)

    if errors:
        print("Repository validation failed:")
        for error in errors:
            print(f"- {error}")
        return 1

    print("Repository validation passed.")
    print(f"- Version: {VERSION}")
    print(f"- Schemas: {len(SCHEMA_BY_SUFFIX)}")
    print(f"- Examples: {example_count}")
    return 0


if __name__ == "__main__":
    sys.exit(main())