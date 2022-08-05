//
//  PropertyType.swift
//  AcademyLOTracker
//
//  Created by Hada Melino Muhammad on 23/07/22.
//

import Foundation

enum Property {
    
    enum Types {
        struct Title: Codable, Equatable {
            var title: String?
            let id: String
            
            init(from decoder: Decoder) throws {
                let container = try decoder.container(keyedBy: Keys.TitleKeys.self)
                self.id = try container.decode(String.self, forKey: .id)
                
                var titleUnkeyed = try? container.nestedUnkeyedContainer(forKey: .title)
                let titleContainer = try? titleUnkeyed?.nestedContainer(keyedBy: Keys.ContentKeys.self)
                self.title = try? titleContainer?.decode(String.self, forKey: .plainText)
            }
        }

        struct RichText: Codable, Equatable {
            var richText: String?
            let id: String
            
            init(from decoder: Decoder) throws {
                let container = try decoder.container(keyedBy: Keys.RichTextKeys.self)
                self.id = try container.decode(String.self, forKey: .id)
                
                var richTextUnkeyed = try? container.nestedUnkeyedContainer(forKey: .rich_text)
                let richTextContainer = try? richTextUnkeyed?.nestedContainer(keyedBy: Keys.ContentKeys.self)
                self.richText = try? richTextContainer?.decode(String.self, forKey: .plainText)
            }
        }

        struct Select: Codable, Equatable {
            let select: String?
            let id: String
            
            enum SelectKeys: String, CodingKey {
                case name
            }
            
            init(from decoder: Decoder) throws {
                let container = try decoder.container(keyedBy: Keys.SelectKeys.self)
                self.id = try container.decode(String.self, forKey: .id)
                let selectProperties = try? container.nestedContainer(keyedBy: SelectKeys.self, forKey: .select)
                self.select = try? selectProperties?.decode(String.self, forKey: .name)
                
            }
        }
    }
    
    enum Keys {
        enum RichTextKeys: String, CodingKey {
            case id, rich_text
        }
        
        enum TitleKeys: String, CodingKey {
            case id, title
        }
        
        enum SelectKeys: String, CodingKey {
            case id, select
        }
        
        enum ContentKeys: String, CodingKey {
            case plainText = "plain_text"
        }
    }
    
    
}

