# Release Preparation Tasks

The following is a breakdown of small, simple tasks required to get the OpenCAD Interchange Standard (OCIS) ready for its first official release.

- [x] **Fix Python Dependencies**: Add `pydantic` to `requirements.txt` so the Python reference parser and `test_interop.py` script run correctly out of the box.
- [x] **Ignore Build Artifacts**: Update `.gitignore` to include `parsers/cpp/build/` so C++ build files are not accidentally committed and don't clutter the git workspace.
- [ ] **Enhance Interoperability Proof**: The current `test_interop.py` tests that C++ can parse a Python-exported file, but the C++ parser does not export data back for verification. We need to implement a full round-trip data verification to prove true interoperability.
- [ ] **Finalize and Submit Standards Proposal**: A draft proposal exists (`specification/committee_submission_draft.md`), but it must be reviewed, approved, and officially submitted to the target standards committees.
- [ ] **Update Project Roadmap**: After true interoperability and standards submission are achieved, update the `README.md` Roadmap section to mark those milestones as complete.
- [ ] **Version Bump**: Update the `VERSION` file from `0.1` to the release version (e.g., `1.0.0`).
- [ ] **Build Release Artifacts**: Compile the Typst specification draft (`specification/Working Draft.typ`) into a PDF for the final release.
