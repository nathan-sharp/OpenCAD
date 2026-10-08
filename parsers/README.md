# Reference Parsers

This directory will contain reference parsers for OpenCAD Interchange Standard (OCIS) files in Python and C++.

Currently, it contains:
- `python/`: Pydantic models generated from the JSON schemas using `datamodel-code-generator`

## Python

To use the Python parsers:

```python
from parsers.python.parse import parse_file

# Parse a file
part = parse_file("examples/bracket_demo.ocp")
print(part.metadata.name)
```

## C++

The C++ parser is a header-only library built on `nlohmann/json`.

To use the C++ parser:

```cpp
#include "parsers/cpp/parser.hpp"
#include <iostream>

int main() {
    auto doc = ocis::parse_file("examples/bracket_demo.ocp");
    if (doc) {
        std::cout << "Parsed version: " << doc->header.version << std::endl;
        if (doc->metadata.name) {
            std::cout << "Name: " << *doc->metadata.name << std::endl;
        }
    }
    return 0;
}
```

### Building the C++ Example

```bash
cd parsers/cpp
mkdir build && cd build
cmake ..
make
./parse_example ../../../examples/bracket_demo.ocp
```
