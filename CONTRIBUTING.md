# Contributing To OpenCAD

Thank you for contributing to the OpenCAD Interchange Standard (OCIS). This repository is an open working draft for an engineering data interchange standard. Contributions are welcome from CAD, ECAD, CAE, interoperability, and technical writing contributors.

## Before You Contribute

- Read [README.md](README.md) for the current draft status.
- Read [CODE_OF_CONDUCT.md](CODE_OF_CONDUCT.md) before participating.
- Read [GOVERNANCE.md](GOVERNANCE.md) for how proposals are reviewed and adopted.

If you are contributing on behalf of an employer, confirm that you are authorized to contribute under the repository licensing terms.

## Licensing And IP

By contributing to this repository, you agree that your contribution is licensed under the same license as the files you modify:

- `specification/` files: CC BY-SA 4.0
- `schemas/`, `examples/`, scripts, workflows, and repository support files: MIT

If you add a new top-level content area with a different license, document it in [LICENSES.md](LICENSES.md) within the same pull request.

Do not submit material that you do not have the right to contribute.

## Change Types

### Editorial Changes

Minor wording, formatting, or typo fixes can be submitted directly as pull requests.

### Schema Or Semantic Changes

For changes that alter the meaning of the standard, open an issue titled `RFC: <topic>` before writing the final patch. Examples include:

- new operation types
- renamed fields
- schema constraint changes
- interoperability behavior changes

### Example Set Changes

Examples in `examples/` are part of the public review surface. If you change a schema, update the corresponding example files so the set remains self-consistent and valid.

## Validation Requirements

Before opening a pull request, run:

`pip install -r requirements.txt`

`python scripts/validate_repo.py`

Pull requests that change schemas or examples should not be merged unless validation passes.

## Pull Request Expectations

- Keep changes focused and explain the problem being solved.
- Describe whether the change is editorial, additive, or breaking.
- Update [CHANGELOG.md](CHANGELOG.md) for any substantive repository-facing change.
- Preserve example resolvability. Relative references in examples must point to files that exist in the repo.

## Reporting Issues

Use GitHub Issues to report ambiguities, schema bugs, or interoperability problems. Prefix issue titles when helpful, for example:

- `[Part]`
- `[Electrical]`
- `[Assembly]`
- `[Simulation]`
- `[Governance]`

## Development Process

1. Fork the repository.
2. Create a topic branch.
3. Make focused changes.
4. Run validation.
5. Open a pull request with context and rationale.