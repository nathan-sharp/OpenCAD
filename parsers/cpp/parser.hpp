#pragma once

#include "json.hpp"
#include <string>
#include <vector>
#include <map>
#include <optional>
#include <fstream>
#include <iostream>

using json = nlohmann::json;

namespace ocis {

struct Header {
    std::string version;
    std::string generator;
    std::optional<std::string> timestamp;

    friend void from_json(const json& j, Header& h) {
        j.at("version").get_to(h.version);
        j.at("generator").get_to(h.generator);
        if (j.contains("timestamp") && !j["timestamp"].is_null()) {
            h.timestamp = j.at("timestamp").get<std::string>();
        }
    }
};

struct Metadata {
    std::string uuid;
    std::optional<std::string> name;

    friend void from_json(const json& j, Metadata& m) {
        j.at("uuid").get_to(m.uuid);
        if (j.contains("name") && !j["name"].is_null()) {
            m.name = j.at("name").get<std::string>();
        }
    }
};

// Very basic struct to show we can read any OCIS document
struct Document {
    Header header;
    Metadata metadata;
    json payload; // Contains remainder of the file like components, instances, uct, buffers etc

    friend void from_json(const json& j, Document& p) {
        j.at("header").get_to(p.header);
        j.at("metadata").get_to(p.metadata);
        p.payload = j;
    }
};

inline std::optional<Document> parse_file(const std::string& path) {
    std::ifstream file(path);
    if (!file.is_open()) {
        std::cerr << "Failed to open file: " << path << std::endl;
        return std::nullopt;
    }

    try {
        json j;
        file >> j;
        return j.get<Document>();
    } catch (const json::exception& e) {
        std::cerr << "JSON parsing error: " << e.what() << std::endl;
        return std::nullopt;
    }
}

} // namespace ocis
