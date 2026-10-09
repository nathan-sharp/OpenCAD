import json
import subprocess
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]

try:
    from parsers.python import parse
except ImportError:
    sys.path.append(str(ROOT))
    from parsers.python import parse


def main() -> int:
    cpp_binary = ROOT / "parsers" / "cpp" / "build" / "parse_example"
    if not cpp_binary.exists():
        print(f"Error: C++ parser binary not found at {cpp_binary}")
        print("Please build it first.")
        return 1

    examples_dir = ROOT / "examples"
    errors = 0

    for example_path in sorted(examples_dir.iterdir()):
        if example_path.suffix not in {".oca", ".oce", ".ocp", ".ocr", ".ocs"}:
            continue

        print(f"Testing interoperability for {example_path.name}...")

        # 1. Parse using Python reference parser
        try:
            doc = parse.parse_file(example_path)
        except Exception as e:
            print(f"  [ERROR] Python parsing failed: {e}")
            errors += 1
            continue

        # 2. Re-export to temporary JSON file
        # Using model_dump_json for pydantic v2
        temp_path = example_path.with_name(example_path.name + ".temp")
        try:
            with open(temp_path, "w", encoding="utf-8") as f:
                # model_dump_json returns a string
                json_data = doc.model_dump_json()
                f.write(json_data)
        except Exception as e:
            print(f"  [ERROR] Python re-exporting failed: {e}")
            errors += 1
            if temp_path.exists():
                temp_path.unlink()
            continue

        # 3. Parse re-exported JSON using C++ reference parser
        try:
            result = subprocess.run(
                [str(cpp_binary), str(temp_path)],
                capture_output=True,
                text=True,
                check=True
            )
            print(f"  [OK] C++ parser successfully parsed re-exported file.")
        except subprocess.CalledProcessError as e:
            print(f"  [ERROR] C++ parser failed on re-exported file. Exit code: {e.returncode}")
            print(f"  STDOUT: {e.stdout}")
            print(f"  STDERR: {e.stderr}")
            errors += 1
        finally:
            if temp_path.exists():
                temp_path.unlink()

    if errors:
        print(f"Interoperability testing failed with {errors} errors.")
        return 1

    print("Interoperability testing passed.")
    return 0

if __name__ == "__main__":
    sys.exit(main())
