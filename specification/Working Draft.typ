// --- ISO Standard Typst Template ---
// Configured for ISO/IEC Directives, Part 2

#set page(
  paper: "a4",
  margin: (x: 2.5cm, y: 2.5cm),
  numbering: "1",
)

#set text(
  font: "New Computer Modern",
  size: 11pt,
  lang: "en"
)

// Start with no numbering for front matter (Foreword/Introduction)
#set heading(numbering: none)

// --- Macros for ISO Formatting ---
#let iso-header(doc-number, part-number, title, stage) = {
  align(right)[Reference number]
  align(right)[#doc-number]
  v(1cm)
  align(left)[ISO/TC 184/SC 4]
  align(left)[Date: #datetime.today().display()]
  align(left)[Stage: #stage]
  v(2cm)
  align(center)[#text(size: 18pt, weight: "bold")[#title]]
  if part-number != none {
    align(center)[#text(size: 14pt)[Part #part-number: Core Architecture and File Formats]]
  }
  v(1fr)
  align(center)[#text(weight: "bold")[Warning]]
  align(center)[This document is not an ISO International Standard. It is distributed for review and comment. It is subject to change without notice and may not be referred to as an International Standard.]
  pagebreak()
}

#let term(term-name, definition) = {
  par(hanging-indent: 1cm)[*#term-name*: #definition]
}

// --- DOCUMENT START ---

#iso-header("ISO/WD 44001", "1", "Industrial automation systems and integration — OpenCAD Interchange Standard (OCIS)", "20.00 (Working Draft)")

// --- Table of Contents ---
#outline(indent: auto)
#pagebreak()

= Foreword
ISO (the International Organization for Standardization) is a worldwide federation of national standards bodies (ISO member bodies). The work of preparing International Standards is normally carried out through ISO technical committees.

This document was prepared by Technical Committee ISO/TC 184, _Automation systems and integration_, Subcommittee SC 4, _Industrial data_.

= Introduction
The exchange of 3D engineering data has historically been hindered by the "Silo Effect" of proprietary file formats. Existing neutral formats (e.g., ISO 10303 STEP) successfully transfer boundary representation (B-Rep) geometry but fail to preserve the "design intent" or parametric history. Furthermore, engineering disciplines such as electrical design and simulation analysis exist in disconnected, vendor-locked file ecosystems.

The *OpenCAD Interchange Standard (OCIS)* defines a set of cloud-native file formats designed to preserve parametric history and facilitate interoperability between mechanical (CAD), electrical (ECAD), and simulation (CAE) software suites. It leverages the WebDAV protocol to ensure data integrity in collaborative cloud storage environments.

// Turn ON standard ISO numbering (1, 1.1, 1.1.1) for the main body
#set heading(numbering: "1.1")

= Scope
This document specifies the logical structure, syntax, and semantic definitions for the OpenCAD Interchange Standard (OCIS).

It covers:
+ The definition of the five core file types: Part (`.ocp`), Electrical (`.oce`), Assembly (`.oca`), Simulation Setup (`.ocs`), and Simulation Result (`.ocr`).
+ The schema for the Unified Change Tree (UCT), enabling lossless transfer of parametric modeling operations.
+ The definition of generic boundary conditions and loads for CAE analysis.
+ The JSON-to-Binary buffer mapping protocol for high-performance result handling.
+ The mapping of OCIS metadata to WebDAV properties for cloud integration.

It does not cover:
- The specific mathematical algorithms used by geometric modeling kernels to solve UCT features.
- The mathematical solving methodologies of FEA/CFD engines.
- Visual rendering protocols (e.g., shaders, lighting).

= Normative References
The following documents are referred to in the text in such a way that some or all of their content constitutes requirements of this document.

- *ISO/IEC 21778:2017*, _Information technology — The JSON data interchange syntax_
- *RFC 4918*, _HTTP Extensions for Web Distributed Authoring and Versioning (WebDAV)_
- *ISO 10303-21*, _Industrial automation systems and integration — Product data representation and exchange — Part 21: Implementation methods: Clear text encoding of the exchange structure_

= Terms and Definitions

#term("Change Tree", "Ordered sequence of parametric operations (features) used to construct a 3D geometric model.")
#term("Feature", "A single parametric operation, such as an extrude, revolve, fillet, or chamfer.")
#term("Unified Change Tree (UCT)", "The normative JSON schema defined in this standard for representing a Change Tree in a software-agnostic format.")
#term("Computer-Aided Engineering (CAE)", "The broad usage of computer software to aid in engineering analysis tasks, encompassing Finite Element Analysis (FEA) and Computational Fluid Dynamics (CFD).")
#term("Buffer View", "A programmatic definition detailing how to extract an array of typed data (e.g., FLOAT32) from a raw binary payload.")
#term("WebDAV", "Set of extensions to the HTTP protocol which allows users to collaboratively edit and manage files on remote web servers.")

= General Architecture

== The Core Domain Architecture
The OCIS architecture decouples engineering data into five distinct semantic domains. This separation ensures that specialised tools can interact with the data model without needing to parse unrelated data (e.g., a PCB routing tool does not need to parse FEA mesh data).

The five file types are:
+ *OpenCAD Part (`.ocp`)*: Contains geometric definitions, material properties, and the UCT.
+ *OpenCAD Electrical (`.oce`)*: Contains schematic logic, netlists, and pin definitions.
+ *OpenCAD Assembly (`.oca`)*: Contains hierarchical references, kinematic constraints, and bill of materials (BOM) data.
+ *OpenCAD Simulation Setup (`.ocs`)*: Contains mesh parameters, boundary conditions, and physical loads linking to a target part or assembly.
+ *OpenCAD Simulation Result (`.ocr`)*: Contains the solved numerical data (fields) mapped to geometric meshes using binary buffers.

== Encoding
All OCIS files shall be encoded using UTF-8. The core data structure for all file types shall be strictly compliant with *ISO/IEC 21778 (JSON)*.

= File Specifications

== The Part File (.ocp)

=== Overview
The `.ocp` file represents a single rigid body or a multi-body part defined by a unified history of operations.

=== Root Structure
The root JSON object of an `.ocp` file shall contain the following keys:

```json
{
  "header": { "version": "1.0", "generator": "Software_Name_vX" },
  "metadata": { "uuid": "...", "mass_units": "kg", "length_units": "mm" },
  "uct": { ... }, 
  "cache": { ... } 
}
```

=== The Unified Change Tree (UCT)
The `uct` object contains an ordered array of operations. Compliant software parsers must execute these operations in order to reconstruct the geometry.

_Normative Operation Types:_
- `EXTRUDE`: Linear projection of a 2D sketch profile.
- `REVOLVE`: Rotational projection of a 2D sketch profile around an axis.
- `FILLET`: Rounding of a specific edge reference.
- `BOOLEAN`: Union, Difference, or Intersection of bodies.

_Example UCT Node:_
```json
{
  "op_id": "feat_001",
  "type": "EXTRUDE",
  "params": {
    "sketch_ref": "sk_001",
    "distance": 15.0,
    "direction": [0, 0, 1],
    "taper_angle": 0.0
  }
}
```

== The Electrical File (.oce)

=== Overview
The `.oce` file contains logical electrical data. It acts as the bridge between 2D schematics and 3D physical routing.

=== Connectivity Model
The `.oce` file shall define connectivity using a `netlist` array connecting `components`.

```json
{
  "components": [
    { "ref_des": "R1", "part_number": "RES-10K", "footprint": "0603" }
  ],
  "nets": [
    { "name": "VCC", "nodes": ["R1:1", "U1:8"] }
  ]
}
```

== The Assembly File (.oca)

=== Overview
The `.oca` file contains no geometry. It links `.ocp` and `.oce` files via relative or absolute paths (URIs).

=== Constraint Definitions
Constraints define the kinematic relationship between components. Supported constraints include `MATE`, `ALIGN`, `OFFSET`, and `FIXED`.

```json
{
  "instances": [
    { "id": "inst_01", "source_uri": "./bracket.ocp" },
    { "id": "inst_02", "source_uri": "./sensor.oce" }
  ],
  "constraints": [
    {
      "type": "MATE",
      "target_a": "inst_01:face_top",
      "target_b": "inst_02:face_btm"
    }
  ]
}
```

== The Simulation Setup File (.ocs)

=== Overview
The `.ocs` file abstracts the setup of finite element analysis (FEA) and computational fluid dynamics (CFD) environments. It contains no geometry, but references an `.oca` or `.ocp` file and applies physical loads and boundary constraints to specific topological entities (faces, edges, vertices).

=== Physics Setup Structure
The `setup` object must contain `boundary_conditions` and `loads`.

_Example FEA Setup:_
```json
{
  "target": { "source_uri": "./motor_assembly.oca" },
  "setup": {
    "boundary_conditions": [
      { "id": "bc_01", "type": "FIXED", "target_entity": "inst_01:face_bottom" }
    ],
    "loads": [
      { "id": "load_01", "type": "FORCE", "target_entity": "inst_01:face_top", "vector": [0, -100, 0] }
    ]
  }
}
```

== The Simulation Result File (.ocr)

=== Overview
Simulation results consist of excessively large matrices of floating-point data (millions of nodes). Storing this directly in JSON results in unacceptable parsing overhead. The `.ocr` format relies on a hybrid approach: a lightweight JSON document that maps semantic definitions to external, raw binary buffer files (`.bin`).

=== Buffer Mapping Protocol
Compliant parsers must use the `buffers` and `bufferViews` arrays to reconstruct mathematical data arrays.

+ *`buffers`*: Defines the URI and total byte length of an external raw binary file.
+ *`bufferViews`*: Defines a contiguous slice of a buffer, specifying the `byteOffset`, `componentType` (e.g., `FLOAT32`), and `type` (e.g., `VEC3` for 3D vectors).

=== Field Definitions
The `fields` array maps physical results (e.g., Stress, Displacement, Fluid Velocity) to specific `bufferViews`. 

_Example Field Definition:_
```json
{
  "name": "Von_Mises_Stress",
  "domain": "NODE",
  "step": 1.0,
  "data": 2 
}
```

= Cloud Integration (WebDAV Binding)

== Objective
OCIS files are designed to reside on WebDAV-compliant servers natively. This section defines the mapping between OCIS internal metadata and WebDAV dead properties.

== Property Mapping
Compliant servers and clients shall map internal JSON metadata to WebDAV XML properties in the `ocis:` namespace.

#table(
  columns: (auto, auto, auto),
  inset: 10pt,
  align: horizon,
  [*OCIS JSON Field*], [*WebDAV Property*], [*Description*],
  [metadata.uuid], [ocis:uuid], [Unique Identifier],
  [metadata.material], [ocis:material], [Material Name (if .ocp)],
  [metadata.mass], [ocis:mass], [Calculated Mass],
  [header.generator], [ocis:generator], [Software used to save],
)

== Concurrency Control
To prevent "last-write-wins" data loss:
+ *Open:* Clients MUST issue a WebDAV `LOCK` request on the target URI before beginning an edit session.
+ *Save:* Clients MUST include the `If` header containing the Lock-Token during `PUT` operations.
+ *Close:* Clients MUST issue an `UNLOCK` request upon closing the file.

// Switch numbering style to Annex standard (A, A.1, A.2) and reset counter
#set heading(numbering: "A.1")
#counter(heading).update(0)

= JSON Schemas (Normative)

_(Note: In the full standard, the complete JSON schemas for `.ocp`, `.oce`, `.oca`, `.ocs`, and `.ocr` shall be provided here.)_

== Common Header Schema Definition
```json
{
  "$schema": "[http://json-schema.org/draft-07/schema#](http://json-schema.org/draft-07/schema#)",
  "type": "object",
  "properties": {
    "version": { "type": "string", "pattern": "^\\d+\\.\\d+$" },
    "generator": { "type": "string" },
    "timestamp": { "type": "string", "format": "date-time" }
  },
  "required": ["version", "generator"]
}
```
