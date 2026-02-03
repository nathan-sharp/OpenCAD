# OpenCAD
An open, cloud-native ISO standard proposal for unifying 3D mechanical and electrical engineering workflows via a lossless, WebDAV-compatible interchange format.

## OpenCAD Interchange Standard (OCIS)

The Mission

The engineering world is fragmented. Proprietary file formats (.ipt, .sldprt, .f3d) lock data into silos, making collaboration between different CAD suites nearly impossible without losing the "intelligence" (parametric history) of the model.

OpenCAD (OCIS) is a proposal for a new, open standard to solve this. It aims to unify mechanical parts, electrical designs, and assemblies into a coherent, lossless ecosystem that is native to the cloud.

Architecture

OCIS moves away from monolithic binary files, utilizing a modular Tri-File Architecture:

| Extension | Name | Description |
| .ocp | OpenCAD Part | Defines geometry, material, and the Unified Change Tree (parametric history). |
| .oce | OpenCAD Electrical | Defines schematics, PCB layouts, netlists, and harness routing data. |
| .oca | OpenCAD Assembly | Logic-only file defining constraints, positioning, and referencing .ocp and .oce files. |

Key Innovations

1. The Unified Change Tree

Unlike STEP or IGES files which store "dumb" geometry (just the final shape), .ocp files store the Recipe.

It uses a standardized JSON schema to record operations (Extrude, Revolve, Fillet).

Result: A file created in Software A can be opened and edited in Software B with the history intact.

2. Cloud-Native (WebDAV)

Legacy CAD formats rely on local file locking (LAN/SMB). OCIS is built for the modern web:

Native Locking: Uses WebDAV LOCK/UNLOCK methods to handle multi-user collaboration over HTTP.

Metadata: Exposes Mass, Material, and Part Number as WebDAV properties, allowing files to be indexed by cloud storage providers without opening them.

🗺 Roadmap to ISO

We are currently in the Working Draft phase.

$$$$

 Phase 1: Specification (Current) - Defining the JSON Schema for the Change Tree.

$$$$

 Phase 2: PoC - Developing a reference parser/writer in C++ and Python.

$$$$

 Phase 3: Committee Draft - Submission to ISO TC 184 (Automation systems and integration).

$$$$

 Phase 4: Standardization - Official publication.

🤝 Contributing

This is an open initiative. We need:

CAD Developers: To help define the geometric operation schemas.

Electrical Engineers: To validate the .oce data structures.

Technical Writers: To help draft the ISO specification text.

Please read CONTRIBUTING.md for details on our code of conduct and submission process.
