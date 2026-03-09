# OpenCAD Interchange Standard (OCIS)

### The Mission

The engineering world is fragmented. Proprietary file formats (.ipt, .sldprt, .f3d) lock design and simulation data into isolated silos.

OpenCAD (OCIS) is a proposal for an open, cloud-native ISO standard. It aims to unify mechanical CAD, electrical design (ECAD), and simulation (CAE) workflows into a single, lossless ecosystem.

### Architecture

Instead of massive, monolithic binary files, OCIS uses a modular approach separating data into five distinct, semantic domains:

| Extension | Name | Description |
| -------- | ------- | ------- |
| .ocp | OpenCAD Part | Defines geometry and the Unified Change Tree (parametric history/recipe). |
| .oce | OpenCAD Electrical | Defines 2D schematics, PCB layouts, netlists, and harness routing. |
| .oca | OpenCAD Assembly | Logic-only file defining constraints, positioning, and BOMs. |
| .ocs | OpenCAD Sim Setup | Defines FEA/CFD physics (meshes, boundary conditions, loads).
| .ocr | OpenCAD Result | Lightweight JSON mapping to raw binary buffers for heavy simulation output (stress, displacement) without proprietary lock-in. |

### Roadmap to ISO

We are currently in the Working Draft phase targeting ISO TC 184 (Industrial data).

- [ ] Phase 1: Specification (Current) - Defining the JSON schemas for the 5 core formats.
- [ ] Phase 2: Proof of Concept - Developing reference parsers in Python/C++.
- [ ] Phase 3: Committee Draft - Submission to ISO for review.
- [ ] Phase 4: Standardization - Official publication.

### Contributing

This is an open initiative! We are looking for input from:

- CAD Developers (Geometry schemas)
- Electrical Engineers (ECAD/Netlist routing)
- Simulation Engineers (FEA/CFD boundary conditions)

Please read our CONTRIBUTING.md for details on how to propose changes, report issues, and format JSON schemas.

### License

- The Specification Text (.typ files) is licensed under Creative Commons Attribution-ShareAlike 4.0 International (CC BY-SA 4.0).
- Reference code, schemas, and examples are licensed under the MIT License.
