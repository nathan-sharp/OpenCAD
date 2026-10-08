import json
from pathlib import Path

# Adjust imports to work whether executed directly or imported
try:
    from . import oca, oce, ocp, ocr, ocs
except ImportError:
    import oca, oce, ocp, ocr, ocs

def parse_file(path: str | Path):
    path = Path(path)
    with path.open("r", encoding="utf-8") as f:
        data = json.load(f)

    if path.suffix == ".oca":
        return oca.OpencadAssemblyDefinitionOca.model_validate(data)
    elif path.suffix == ".oce":
        return oce.OpencadElectricalDefinitionOce.model_validate(data)
    elif path.suffix == ".ocp":
        return ocp.OpencadPartDefinitionOcp.model_validate(data)
    elif path.suffix == ".ocr":
        return ocr.OpencadResultDefinitionOcr.model_validate(data)
    elif path.suffix == ".ocs":
        return ocs.OpencadSimulationDefinitionOcs.model_validate(data)
    else:
        raise ValueError(f"Unknown extension {path.suffix}")

if __name__ == "__main__":
    import sys
    if len(sys.argv) > 1:
        doc = parse_file(sys.argv[1])
        print(f"Successfully parsed: {sys.argv[1]}")
    else:
        print("Usage: python parse.py <path_to_ocis_file>")
