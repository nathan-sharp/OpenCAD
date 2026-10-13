# Release Preparation Tasks

This list tracks the small, manageable tasks required to fully prepare the OpenCAD Interchange Standard (OCIS) for its 1.0 release.

- [x] Task 1: Add `pydantic` and `datamodel-code-generator` to `requirements.txt` so that the Python reference parsers and interoperability tests can run successfully in a fresh environment.
- [x] Task 2: Update `.gitignore` to exclude the `parsers/cpp/build/` directory and any compiled binaries to prevent build artifacts from being committed to version control.
- [x] Task 3: Update the roadmap in `README.md` to mark the "Multi-implementation proof of interoperability" and "Formal standards sponsorship and committee submission" tasks as completed.
- [x] Task 4: Bump the version number in the `VERSION` file from `0.1` to `1.0` to finalize the release.
- [x] Task 5: Update the version number referenced in the `README.md` documentation to match the `1.0` release version.
- [x] Task 6: Run all repository validations and tests (`scripts/validate_repo.py`, `scripts/test_interop.py`, and C++ tests) to ensure all checks pass prior to release.
- [x] Task 7: Remove `release_tasks.md` if `TODO.md` is now the single source of truth for remaining release tasks.
