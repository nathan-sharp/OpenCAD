# OpenCAD Interchange Standard (OCIS)

OpenCAD is an open interchange standard for cloud-native engineering data. The project is currently maintained as a public working draft and is not an ISO International Standard.

## Status

- Repository draft version: `0.1`
- Current normative draft: `specification/Working Draft.typ`
- Historical background document: `specification/Proposal.typ`
- Maturity: Working Draft suitable for public review and prototype validation

If you cite the project publicly, refer to it as the *OpenCAD Interchange Standard (OCIS) Working Draft*.

## Mission

Proprietary engineering formats fragment mechanical CAD, electrical design, and simulation data into incompatible silos. OCIS defines a modular, text-based interchange model intended to preserve design intent, enable validation, and support cloud workflows without vendor lock-in.

## Architecture

OCIS separates engineering data into five semantic domains instead of one monolithic binary file:

| Extension | Name | Description |
| --------- | ---- | ----------- |
| `.ocp` | OpenCAD Part | Geometry, metadata, and unified parametric history. |
| `.oce` | OpenCAD Electrical | Schematics, netlists, components, and electrical connectivity. |
| `.oca` | OpenCAD Assembly | Instance references, transforms, constraints, and BOM logic. |
| `.ocs` | OpenCAD Simulation Setup | Solver setup, meshes, loads, and boundary conditions. |
| `.ocr` | OpenCAD Result | Result metadata mapped to external binary buffers. |

## Repository Layout

- `schemas/`: Draft JSON Schemas for the five OCIS formats
- `examples/`: Reference example files intended to validate against the schemas
- `specification/`: Typst source for the proposal and working draft documents

## Validation

The repository includes a validation script for public review and release gating.

1. Install Python dependencies:
	`pip install -r requirements.txt`
2. Run repository validation:
	`python scripts/validate_repo.py`

Validation checks JSON syntax, schema compliance, and cross-file references used by the example set.

## Building The Draft

The specification sources are written in Typst.

1. Install Typst from https://typst.app/
2. Compile the working draft:
	`typst compile "specification/Working Draft.typ" dist/ocis-working-draft.pdf`

## Roadmap

- [x] Working Draft text and schema set published for review
- [x] Reference examples included for each file type
- [x] Repository validation added for schemas and examples
- [ ] Reference parsers in Python/C++
- [ ] Multi-implementation proof of interoperability
- [ ] Formal standards sponsorship and committee submission

## Contributing

Contributions are welcome from CAD, ECAD, CAE, interoperability, and technical writing contributors. See [CONTRIBUTING.md](CONTRIBUTING.md), [CODE_OF_CONDUCT.md](CODE_OF_CONDUCT.md), and [GOVERNANCE.md](GOVERNANCE.md) before opening a substantial proposal.

## Licensing

- Specification source files in `specification/` are licensed under CC BY-SA 4.0.
- Schemas, examples, scripts, and repository support files are licensed under MIT.
- Contribution terms follow the license of the files being modified unless explicitly stated otherwise.

See [LICENSE](LICENSE) and [LICENSES.md](LICENSES.md) for the repository licensing policy.
