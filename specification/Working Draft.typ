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

#set heading(numbering: "1.1")

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

This document was prepared by Technical Committee ISO/TC 184, *Automation systems and integration*, Subcommittee SC 4, *Industrial data*.

= Introduction
The exchange of 3D engineering data has historically been hindered by the "Silo Effect" of proprietary file formats. Existing neutral formats (e.g., ISO 10303 STEP) successfully transfer boundary representation (B-Rep) geometry but fail to preserve the "design intent" or parametric history (the "Change Tree").

The **OpenCAD Interchange Standard (OCIS)** defines a set of cloud-native file formats designed to preserve this parametric history and facilitate interoperability between disparate Computer-Aided Design (CAD) and Electronic Computer-Aided Design (ECAD) software suites. It leverages the WebDAV protocol to ensure data integrity in cloud storage environments.

= 1 Scope
This document specifies the logical structure, syntax, and semantic definitions for the OpenCAD Interchange Standard (OCIS).

It covers:
+ The definition of the three core file types: Part (`.ocp`), Electrical (`.oce`), and Assembly (`.oca`).
+ The schema for the Unified Change Tree (UCT), enabling lossless transfer of parametric modeling operations.
+ The mapping of OCIS metadata to WebDAV properties for cloud integration.
+ The definition of logical constraints and relationships between file types.

It does not cover:
+ The specific algorithms used by geometric modeling kernels to solve the features defined in the UCT.
+ Visual rendering protocols (e.g., shaders, lighting).

= 2 Normative References
The following documents are referred to in the text in such a way that some or all of their content constitutes requirements of this document.

* **ISO/IEC 21778:2017**, *Information technology — The JSON data interchange syntax*
* **RFC 4918**, *HTTP Extensions for Web Distributed Authoring and Versioning (WebDAV)*
* **ISO 10303-21** *, *Industrial automation systems and integration — Product data representation and exchange — Part 21: Implementation methods: Clear text encoding of the exchange structure*

= 3 Terms and Definitions

#term("Change Tree", "Ordered sequence of parametric operations (features) used to construct a 3D geometric model.")
#term("Feature", "A single parametric operation, such as an extrude, revolve, fillet, or chamfer.")
#term("Unified Change Tree (UCT)", "The normative JSON schema defined in this standard for representing a Change Tree in a software-agnostic format.")
#term("WebDAV", "Set of extensions to the HTTP protocol which allows users to collaboratively edit and manage files on remote web servers.")

= 4 General Architecture

== 4.1 The Tri-File Structure
The OCIS architecture decouples engineering data into three distinct semantic domains. This separation ensures that specialised tools (e.g., PCB design software) can interact with the data model without needing to parse unrelated data (e.g., mechanical geometry).

The three file types are:
+ **OpenCAD Part (`.ocp`)**: Contains geometric definitions, material properties, and the UCT.
+ **OpenCAD Electrical (`.oce`)**: Contains schematic logic, netlists, and pin definitions.
+ **OpenCAD Assembly (`.oca`)**: Contains hierarchical references, constraints, and bill of materials (BOM) data.

== 4.2 Encoding
All OCIS files shall be encoded using UTF-8. The core data structure for all file types shall be strictly compliant with **ISO/IEC 21778 (JSON)**.

= 5 File Specifications

== 5.1 The Part File (.ocp)

5.1.1 Overview
The `.ocp` file represents a single rigid body or a multi-body part defined by a unified history of operations.

5.1.2 Root Structure
The root JSON object of an `.ocp` file shall contain the following keys:

```json
{
  "header": { "version": "1.0", "generator": "Software_Name_vX" },
  "metadata": { "uuid": "...", "mass_units": "kg", "length_units": "mm" },
  "uct": { ... }, // Unified Change Tree
  "cache": { ... } // Optional B-Rep Cache (Base64 encoded STEP)
}
```

5.1.3 The Unified Change Tree (UCT)
The `uct` object contains an ordered array of operations. Compliant software parsers must execute these operations in order to reconstruct the geometry.

**Normative Operation Types:**
* `EXTRUDE`: Linear projection of a 2D sketch profile.
* `REVOLVE`: Rotational projection of a 2D sketch profile around an axis.
* `FILLET`: Rounding of a specific edge reference.
* `BOOLEAN`: Union, Difference, or Intersection of bodies.

*Example UCT Node:*
```json
{
  "op_id": "feat_001",
  "type": "EXTRUDE",
  "input": {
    "sketch_ref": "sk_001",
    "distance": 15.0,
    "direction": [0, 0, 1],
    "taper_angle": 0.0
  }
}
```

== 5.2 The Electrical File (.oce)

5.2.1 Overview
The `.oce` file contains logical electrical data. It acts as the bridge between 2D schematics and 3D routing.

5.2.2 Connectivity Model
The `.oce` file shall define connectivity using a `netlist` array.

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

== 5.3 The Assembly File (.oca)

5.3.1 Overview
The `.oca` file contains no geometry. It links `.ocp` and `.oce` files via relative or absolute paths (URI).

5.3.2 Constraint Definitions
Constraints define the kinematic relationship between components.

*Supported Constraints:*
* `MATE`: Coincident planes or faces.
* `ALIGN`: Coaxial axes. 
* `OFFSET`: Distance between entities. *

```json
{
  "instances": [
    { "id": "inst_01", "source": "./bracket.ocp" },
    { "id": "inst_02", "source": "./sensor.oce" }
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

= 6 Cloud Integration (WebDAV Binding)

== 6.1 Objective
OCIS files are designed to reside on WebDAV-compliant servers. This section defines the mapping between OCIS internal metadata and WebDAV dead properties.

== 6.2 Property Mapping
Compliant servers and clients shall map internal JSON metadata to WebDAV XML properties in the `ocis:` namespace.

#table(
  columns: (auto, auto, auto),
  inset: 10pt,
  align: horizon,
  [*OCIS JSON Field*], [*WebDAV Property*], [*Description*],
  [metadata.uuid], [ocis:uuid], [Unique Identifier],
  [metadata.material], [ocis:material], [Material Name],
  [metadata.mass], [ocis:mass], [Calculated Mass],
  [header.generator], [ocis:generator], [Software used to save],
)

== 6.3 Concurrency Control
To prevent "last-write-wins" data loss:
1.  **Open:** Clients MUST issue a WebDAV `LOCK` request on the target URI before beginning an edit session.
2.  **Save:** Clients MUST include the `If` header containing the Lock-Token during `PUT` operations.
3.  **Close:** Clients MUST issue an `UNLOCK` request upon closing the file.

= Annex A (Normative): JSON Schemas

*(Note: In the full standard, the complete JSON schemas would appear here. For this draft, a placeholder is provided.)*

== A.1 Common Header Schema
```json
{
  "$schema": "[http://json-schema.org/draft-07/schema](http://json-schema.org/draft-07/schema)",
  "type": "object",
  "properties": {
    "version": { "type": "string", "pattern": "^\\d+\\.\\d+$" },
    "generator": { "type": "string" }
  },
  "required": ["version", "generator"]
}
```
