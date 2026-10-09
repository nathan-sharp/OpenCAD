# OpenCAD Interchange Standard (OCIS) Committee Submission Proposal

## Mission

Proprietary engineering formats fragment mechanical CAD, electrical design, and simulation data into incompatible silos. The OpenCAD Interchange Standard (OCIS) defines a modular, text-based interchange model intended to preserve design intent, enable validation, and support cloud workflows without vendor lock-in.

## Architecture

OCIS separates engineering data into five semantic domains instead of one monolithic binary file:

| Extension | Name | Description |
| --------- | ---- | ----------- |
| `.ocp` | OpenCAD Part | Geometry, metadata, and unified parametric history. |
| `.oce` | OpenCAD Electrical | Schematics, netlists, components, and electrical connectivity. |
| `.oca` | OpenCAD Assembly | Instance references, transforms, constraints, and BOM logic. |
| `.ocs` | OpenCAD Simulation Setup | Solver setup, meshes, loads, and boundary conditions. |
| `.ocr` | OpenCAD Result | Result metadata mapped to external binary buffers. |

## Maturity and Validations

The OpenCAD project has matured into a stable Working Draft suitable for public review. Our implementations include:

1. Draft JSON Schemas for the five OCIS formats
2. Reference parsers mapped natively to Python environments (utilizing Pydantic models)
3. Reference parsers engineered natively in C++ for performance in critical applications
4. Formal validations and a multi-implementation proof of interoperability

## Request for Sponsorship

We formally submit this proposal for standardization. Adopting the OpenCAD Interchange Standard as an open specification will enhance collaboration, democratize tooling, and drive next-generation advancements in cloud-native mechanical, electrical, and simulation engineering.