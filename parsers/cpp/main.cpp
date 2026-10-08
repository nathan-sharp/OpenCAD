#include "parser.hpp"
#include <iostream>

int main(int argc, char** argv) {
    if (argc < 2) {
        std::cerr << "Usage: " << argv[0] << " <path_to_ocis_file>" << std::endl;
        return 1;
    }

    auto doc = ocis::parse_file(argv[1]);
    if (doc) {
        std::cout << "Successfully parsed: " << argv[1] << std::endl;
        std::cout << "Version: " << doc->header.version << std::endl;
        std::cout << "Generator: " << doc->header.generator << std::endl;
        if (doc->metadata.name) {
            std::cout << "Name: " << *doc->metadata.name << std::endl;
        }
        std::cout << "UUID: " << doc->metadata.uuid << std::endl;
        return 0;
    } else {
        std::cerr << "Failed to parse: " << argv[1] << std::endl;
        return 1;
    }
}
