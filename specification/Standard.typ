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

The following schemas define the current normative OCIS working draft data model for version `0.1`.

== Part Schema (`.ocp`)
```json
{
  "$schema": "http://json-schema.org/draft-07/schema#",
  "title": "OpenCAD Part Definition (.ocp)",
  "description": "Schema for the OpenCAD Part file containing geometry history and metadata.",
  "type": "object",
  "required": ["header", "metadata", "uct"],
  "properties": {
    "header": {
      "type": "object",
      "required": ["version", "generator"],
      "properties": {
        "version": { "type": "string", "pattern": "^\\d+\\.\\d+$", "description": "OCIS Version" },
        "generator": { "type": "string", "description": "Name of the software that created this file" },
        "timestamp": { "type": "string", "format": "date-time" }
      }
    },
    "metadata": {
      "type": "object",
      "required": ["uuid", "units"],
      "properties": {
        "uuid": { "type": "string", "format": "uuid" },
        "name": { "type": "string" },
        "material": { "type": "string" },
        "units": {
          "type": "string",
          "enum": ["mm", "cm", "m", "in", "ft"]
        }
      }
    },
    "uct": {
      "title": "Unified Change Tree",
      "type": "array",
      "description": "Ordered list of parametric operations.",
      "items": {
        "type": "object",
        "required": ["op_id", "type", "params"],
        "properties": {
          "op_id": { "type": "string" },
          "type": {
            "type": "string",
            "enum": ["EXTRUDE", "REVOLVE", "FILLET", "CHAMFER", "BOOLEAN", "SKETCH"]
          },
          "params": { "type": "object" }
        }
      }
    }
  }
}
```

== Electrical Schema (`.oce`)
```json
{
  "$schema": "http://json-schema.org/draft-07/schema#",
  "title": "OpenCAD Electrical Definition (.oce)",
  "description": "Schema for the OpenCAD Electrical file containing netlists and component logic.",
  "type": "object",
  "required": ["header", "metadata", "components", "nets"],
  "properties": {
    "header": {
      "type": "object",
      "required": ["version", "generator"],
      "properties": {
        "version": { "type": "string", "pattern": "^\\d+\\.\\d+$", "description": "OCIS Version" },
        "generator": { "type": "string", "description": "Name of the software that created this file" },
        "timestamp": { "type": "string", "format": "date-time" }
      }
    },
    "metadata": {
      "type": "object",
      "required": ["uuid"],
      "properties": {
        "uuid": { "type": "string", "format": "uuid" },
        "board_name": { "type": "string" }
      }
    },
    "components": {
      "type": "array",
      "items": {
        "type": "object",
        "required": ["ref_des", "part_number"],
        "properties": {
          "ref_des": { "type": "string", "description": "Reference Designator e.g., R1, U2" },
          "part_number": { "type": "string" },
          "footprint": { "type": "string" }
        }
      }
    },
    "nets": {
      "type": "array",
      "items": {
        "type": "object",
        "required": ["name", "nodes"],
        "properties": {
          "name": { "type": "string", "description": "e.g., GND, 5V, MISO" },
          "nodes": {
            "type": "array",
            "items": { "type": "string", "description": "Format: REF:PIN (e.g., R1:1)" }
          }
        }
      }
    }
  }
}
```

== Assembly Schema (`.oca`)
```json
{
  "$schema": "http://json-schema.org/draft-07/schema#",
  "title": "OpenCAD Assembly Definition (.oca)",
  "description": "Schema for the OpenCAD Assembly file containing instances and constraints.",
  "type": "object",
  "required": ["header", "metadata", "instances", "constraints"],
  "properties": {
    "header": {
      "type": "object",
      "required": ["version", "generator"],
      "properties": {
        "version": { "type": "string", "pattern": "^\\d+\\.\\d+$", "description": "OCIS Version" },
        "generator": { "type": "string", "description": "Name of the software that created this file" },
        "timestamp": { "type": "string", "format": "date-time" }
      }
    },
    "metadata": {
      "type": "object",
      "required": ["uuid"],
      "properties": {
        "uuid": { "type": "string", "format": "uuid" },
        "assembly_name": { "type": "string" }
      }
    },
    "instances": {
      "type": "array",
      "items": {
        "type": "object",
        "required": ["id", "source_uri"],
        "properties": {
          "id": { "type": "string", "description": "Unique ID for this instance" },
          "source_uri": { "type": "string", "description": "Relative or absolute path to the .ocp or .oce file" },
          "transform": {
            "type": "array",
            "items": { "type": "number" },
            "minItems": 16,
            "maxItems": 16,
            "description": "16-element 4x4 Transformation Matrix"
          }
        }
      }
    },
    "constraints": {
      "type": "array",
      "items": {
        "type": "object",
        "required": ["type", "target_a", "target_b"],
        "properties": {
          "type": { "type": "string", "enum": ["MATE", "ALIGN", "OFFSET", "FIXED"] },
          "target_a": { "type": "string" },
          "target_b": { "type": "string" }
        }
      }
    }
  }
}
```

== Simulation Setup Schema (`.ocs`)
```json
{
  "$schema": "http://json-schema.org/draft-07/schema#",
  "title": "OpenCAD Simulation Definition (.ocs)",
  "description": "Schema for the OpenCAD Simulation file containing FEA/CFD setup, loads, and boundary conditions.",
  "type": "object",
  "required": ["header", "metadata", "target", "setup"],
  "properties": {
    "header": {
      "type": "object",
      "required": ["version", "generator"],
      "properties": {
        "version": { "type": "string", "pattern": "^\\d+\\.\\d+$", "description": "OCIS Version" },
        "generator": { "type": "string", "description": "Name of the software that created this file" },
        "timestamp": { "type": "string", "format": "date-time" }
      }
    },
    "metadata": {
      "type": "object",
      "required": ["uuid", "sim_type"],
      "properties": {
        "uuid": { "type": "string", "format": "uuid" },
        "name": { "type": "string" },
        "sim_type": {
          "type": "string",
          "enum": ["FEA_STATIC", "FEA_DYNAMIC", "CFD_STEADY", "CFD_TRANSIENT", "THERMAL"]
        }
      }
    },
    "target": {
      "type": "object",
      "description": "The geometric model to be simulated.",
      "required": ["source_uri"],
      "properties": {
        "source_uri": { "type": "string", "description": "URI to the .oca or .ocp file" },
        "configuration": { "type": "string", "description": "Optional assembly state/configuration name" }
      }
    },
    "setup": {
      "type": "object",
      "properties": {
        "mesh": {
          "type": "object",
          "properties": {
            "global_size": { "type": "number" },
            "element_type": { "type": "string", "enum": ["TETRA", "HEXA", "POLY"] }
          }
        },
        "boundary_conditions": {
          "type": "array",
          "items": {
            "type": "object",
            "required": ["id", "type", "target_entity"],
            "properties": {
              "id": { "type": "string" },
              "type": { "type": "string", "enum": ["FIXED", "PINNED", "SYMMETRY", "WALL_NO_SLIP", "VELOCITY_INLET", "PRESSURE_OUTLET"] },
              "target_entity": { "type": "string", "description": "Instance/Face ID from the target file" },
              "params": { "type": "object" }
            }
          }
        },
        "loads": {
          "type": "array",
          "items": {
            "type": "object",
            "required": ["id", "type", "target_entity"],
            "properties": {
              "id": { "type": "string" },
              "type": { "type": "string", "enum": ["FORCE", "PRESSURE", "GRAVITY", "TEMPERATURE", "HEAT_FLUX"] },
              "target_entity": { "type": "string" },
              "vector": { "type": "array", "items": { "type": "number" } },
              "magnitude": { "type": "number" }
            }
          }
        }
      }
    },
    "results": {
      "type": "object",
      "description": "Pointers to heavy result data files generated by solvers.",
      "properties": {
        "status": { "type": "string", "enum": ["UNSOLVED", "SOLVED", "FAILED"] },
        "data_uri": { "type": "string", "description": "Path to .vtk, .h5, or other result format" }
      }
    }
  }
}
```

== Simulation Result Schema (`.ocr`)
```json
{
  "$schema": "http://json-schema.org/draft-07/schema#",
  "title": "OpenCAD Result Definition (.ocr)",
  "description": "Schema for OpenCAD Simulation Results, mapping nodes and elements to scalar/vector fields using binary buffers.",
  "type": "object",
  "required": ["header", "metadata", "buffers", "bufferViews", "mesh", "fields"],
  "properties": {
    "header": {
      "type": "object",
      "required": ["version", "generator"],
      "properties": {
        "version": { "type": "string", "pattern": "^\\d+\\.\\d+$", "description": "OCIS Version" },
        "generator": { "type": "string", "description": "Solver that generated the result" },
        "timestamp": { "type": "string", "format": "date-time" }
      }
    },
    "metadata": {
      "type": "object",
      "required": ["uuid", "source_sim"],
      "properties": {
        "uuid": { "type": "string", "format": "uuid" },
        "source_sim": { "type": "string", "description": "URI to the .ocs file that generated this" }
      }
    },
    "buffers": {
      "type": "array",
      "description": "Array of raw binary files containing the heavy float/int arrays.",
      "items": {
        "type": "object",
        "required": ["uri", "byteLength"],
        "properties": {
          "uri": { "type": "string", "description": "Path to the .bin file (or base64 encoded string)" },
          "byteLength": { "type": "integer" }
        }
      }
    },
    "bufferViews": {
      "type": "array",
      "description": "Defines how to read the buffers (e.g., read 1000 floats starting at byte 0).",
      "items": {
        "type": "object",
        "required": ["buffer", "byteOffset", "byteLength", "componentType", "type"],
        "properties": {
          "buffer": { "type": "integer", "description": "Index of the buffer" },
          "byteOffset": { "type": "integer" },
          "byteLength": { "type": "integer" },
          "componentType": { "type": "string", "enum": ["FLOAT32", "FLOAT64", "UINT32"] },
          "type": { "type": "string", "enum": ["SCALAR", "VEC3", "VEC4", "MAT3", "MAT4"] },
          "name": { "type": "string" }
        }
      }
    },
    "mesh": {
      "type": "object",
      "required": ["nodes", "elements"],
      "properties": {
        "nodes": { "type": "integer", "description": "Index of the bufferView containing XYZ coordinates" },
        "elements": { "type": "integer", "description": "Index of the bufferView containing node connectivity" },
        "element_type": { "type": "string", "enum": ["TETRA4", "HEXA8", "TRI3", "QUAD4"] }
      }
    },
    "fields": {
      "type": "array",
      "description": "The actual simulation results (e.g., Stress, Displacement).",
      "items": {
        "type": "object",
        "required": ["name", "domain", "data"],
        "properties": {
          "name": { "type": "string", "description": "e.g., 'Von_Mises_Stress', 'Displacement'" },
          "domain": { "type": "string", "enum": ["NODE", "ELEMENT"] },
          "step": { "type": "number", "description": "Time step or frequency for this specific field data" },
          "data": { "type": "integer", "description": "Index of the bufferView containing the result values" }
        }
      }
    }
  }
}
```
