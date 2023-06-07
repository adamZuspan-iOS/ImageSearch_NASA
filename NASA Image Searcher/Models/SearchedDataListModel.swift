//
//  SearchedDataListModel.swift
//  NASA Image Searcher
//
//  Created by Adam Zuspan on 6/5/23.
//

import Foundation

struct SearchedDataListModel: Codable {
    var collection: Collection
    
    enum CodingKeys: CodingKey {
        case collection
    }
}
struct Collection: Codable {
    var items: [Items]
    
    enum CodingKeys: CodingKey {
        case items
    }
}
struct Items: Codable, Identifiable {
    var id = UUID()
    var data: [RelevantData]
    var links: [Links]
    
    enum CodingKeys: CodingKey {
        case data, links
    }
}
struct RelevantData: Codable, Identifiable {
    var id = UUID()
    var title: String
    var dateCreated_ISO8601: String
    var description: String?
    var description_508: String?
    
    enum CodingKeys: String, CodingKey {
        case title, description, description_508
        case dateCreated_ISO8601 = "date_created"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        title = try container.decode(String.self, forKey: .title)
        dateCreated_ISO8601 = try container.decode(String.self, forKey: .dateCreated_ISO8601)
        
        if container.contains(.description) {
            description = try container.decode(String.self, forKey: .description)
        } else if container.contains(.description_508) {
            description = try container.decode(String.self, forKey: .description_508)
        } else {
            description = nil
        }
        
        description_508 = try container.decodeIfPresent(String.self, forKey: .description_508) ?? nil
    }
}
struct Links: Codable, Identifiable {
    var id = UUID()
    var imageURL: String
    enum CodingKeys: String, CodingKey {
        case imageURL = "href"
    }
}

extension RelevantData {
    var dateCreatedFormatted: String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d, yyyy, h:mm a"
        return dateFormatter.string(for: dateCreated_ISO8601)
    }
}
