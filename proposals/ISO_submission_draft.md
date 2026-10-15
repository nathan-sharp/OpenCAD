# OpenCAD Interchange Standard (OCIS)
## ISO Committee Submission Draft

**To:** ISO/TC 184 (Automation systems and integration), SC 4 (Industrial data)

### 1. Introduction
The OpenCAD Interchange Standard (OCIS) is an open, cloud-native standard for mechanical CAD, electrical design, and simulation data interoperability. It is designed to bridge the gap between proprietary silos, providing a unified, text-based JSON architecture that separates concerns into five semantic domains.

### 2. Scope
This proposal submits the OCIS Working Draft specification, JSON schemas, reference examples, and the reference implementations in Python and C++ for consideration as a new work item proposal (NWIP).

### 3. Justification
Current engineering formats restrict collaboration through vendor lock-in and binary opaqueness. By bringing engineering data interchange to the cloud-native era through well-defined JSON schemas and modular validation, OCIS enables continuous integration, multi-domain traceability, and semantic design intent preservation.

### 4. Technical Architecture
The standard proposes five format extensions:
- `.ocp`: OpenCAD Part
- `.oce`: OpenCAD Electrical
- `.oca`: OpenCAD Assembly
- `.ocs`: OpenCAD Simulation Setup
- `.ocr`: OpenCAD Result

### 5. Conclusion
We invite the committee to review the provided technical artifacts and adopt OCIS for international standardization.
