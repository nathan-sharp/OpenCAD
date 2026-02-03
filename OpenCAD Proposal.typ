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

// --- Title Page ---
#align(center + horizon)[
  #text(size: 24pt, weight: "bold")[OpenCAD Interchange Standard (OCIS)]
  
  #v(1em)
  
  #text(size: 16pt)[Proposal for a Universal ISO Standard for 3D Engineering Interoperability]
  
  #v(2em)
  
  *Draft Proposal | Version 0.1*
  
  #v(2em)
  
  #datetime.today().display()
]

#pagebreak()

// --- Content ---

= Executive Summary
The engineering industry currently suffers from a "Silo Effect" caused by proprietary file formats (e.g., `.ipt`, `.sldprt`, `.f3d`). This fragmentation results in data loss during conversion, broken parametric history, and significant productivity costs.

This document proposes the **OpenCAD Interchange Standard (OCIS)**, a cloud-native, open standard designed to unify mechanical parts, electrical designs, and assemblies into a coherent, lossless ecosystem compatible with modern web protocols (WebDAV).

= The Problem: The Cost of Incompatibility

== The Silo Effect
When a part is created in one software suite, it cannot be edited in another without exporting to "dumb" geometry formats (STEP/IGES). This process strips away the "Feature Tree" (the recipe of how the part was made), rendering the model difficult to modify.

== Productivity Impact
Market analysis suggests that engineering teams spend approximately **20-30%** of their time dealing with file interoperability issues, creating "zombie data" that must be re-modeled from scratch when switching vendors.

= The Solution: Tri-File Architecture

The OCIS standard proposes separating engineering data into three semantic file types, rather than a single monolithic binary.

== 1. Part Definition (`.ocp`)
* **Purpose:** Defines the geometry and physical properties of a single component.
* **Core Innovation:** Contains a normalized JSON-based **Unified Change Tree**. This preserves the history (e.g., Extrude -> Fillet -> Chamfer) allowing non-destructive editing in any compliant software.

== 2. Electrical Design (`.oce`)
* **Purpose:** Defines electrical schematics, PCB layouts, and harness routing.
* **Core Innovation:** Decouples electrical logic from physical geometry, allowing ECAD tools to interface directly with MCAD assemblies without heavy conversion plugins.

== 3. Global Assembly (`.oca`)
* **Purpose:** A lightweight logic file that links `.ocp` and `.oce` files.
* **Core Innovation:** Contains no geometry itself. It defines kinematic constraints, relative positioning, and Bill of Materials (BOM) logic.

= Technical Pillars

== Unified Change Tree (UCT)
To solve the "dumb geometry" issue, OCIS mandates a standard schema for geometric operations.

*Example JSON Structure:*
```json
{
  "operation_id": "op_extrude_01",
  "type": "EXTRUDE",
  "parameters": {
    "sketch_ref": "sk_base",
    "depth": 10.0,
    "direction": "normal",
    "boolean": "new_body"
  }
}
```

== WebDAV & Cloud Compatibility
Traditional CAD files rely on local file system locking (NTFS/SMB), which fails in cloud environments. OCIS is designed for **WebDAV**:

1.  **Native Locking:** Utilizes WebDAV `LOCK` and `UNLOCK` methods to prevent overwrite conflicts in multi-user environments.
2.  **Metadata Exposure:** Exposes properties (Mass, Material, Vendor) via WebDAV properties, allowing file indexing and searching without opening the CAD kernel.

= ISO Standardization Roadmap

This proposal aims for submission to **ISO TC 184/SC 4** (Industrial data).

1.  **Working Draft (WD):** Definition of JSON schemas and core file structure.
2.  **Committee Draft (CD):** Review by industry stakeholders and initial reference implementations.
3.  **Draft International Standard (DIS):** Public enquiry and voting.
4.  **Publication:** Official ISO standard release.

= Conclusion
The OpenCAD Interchange Standard represents a necessary evolution in engineering data. By embracing cloud-native protocols and ensuring lossless interoperability, we can unlock billions in global productivity.