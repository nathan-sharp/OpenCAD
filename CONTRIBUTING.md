Contributing to the OpenCAD Interchange Standard (OCIS)

Thank you for your interest in contributing to the OpenCAD Standard. This project operates as an open specification development group. We welcome input from CAD developers, electrical engineers, and technical writers.

Intellectual Property & Licensing

By contributing to this repository, you agree that your contributions will be licensed under the Creative Commons CC0 1.0 Universal license.

Note: If you are contributing on behalf of an employer (e.g., an Autodesk, PTC, or Dassault Systemes employee), please ensure you have the authorization to contribute to open standards.

How to Contribute

1. Proposing Changes to the Specification

The specification text is written in Typst.

Typos/Grammar: Submit a Pull Request (PR) directly fixing the .typ file.

Substantial Changes: Please open an Issue first titled RFC: [Topic] (Request for Comment). Discuss the change before writing the spec text.

2. Technical Definitions (JSON Schemas)

We strictly version our JSON schemas.

Schemas are located in the /schemas directory.

If you change a schema, you must update the corresponding example file in /examples to prove the change is valid.

3. Reporting Issues

Use the Issue Tracker to report ambiguities in the standard or bugs in the reference implementation.

Tag your issue with [Part], [Electrical], or [Assembly] to help us triage.

Development Process

Fork the repo.

Create a branch: git checkout -b feature/my-new-feature

Commit your changes: git commit -am 'Add some feature'

Push to the branch: git push origin feature/my-new-feature

Submit a pull request.

Code of Conduct

Please note that this project is released with a Contributor Code of Conduct. By participating in this project you agree to abide by its terms. We prioritize professional, constructive technical discourse.