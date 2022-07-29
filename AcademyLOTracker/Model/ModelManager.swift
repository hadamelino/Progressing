//
//  Path.swift
//  AcademyLOTracker
//
//  Created by Hada Melino Muhammad on 22/07/22.
//

import Foundation

struct ModelManager: Codable {
    
    enum Handler {
        
        struct Path: Codable {
            var results: [PathProgress]
            
            init(from decoder: Decoder) throws {
                var pathArray = [PathProgress]()
                let container = try decoder.container(keyedBy: Keys.CodingKeys.self)
                var resultsRaw = try container.nestedUnkeyedContainer(forKey: .results)
            
                while !resultsRaw.isAtEnd {
                    let propertiyObject = try resultsRaw.nestedContainer(keyedBy: Keys.ResultsKeys.self)
                    pathArray.append(try propertiyObject.decode(PathProgress.self, forKey: .properties))
                }
                self.results = pathArray
                
            }
        }
        
        struct Learning: Codable {
            
            var results: [LearningObjective]
    
            init(from decoder: Decoder) throws {
                var LOArray = [LearningObjective]()
                let container = try decoder.container(keyedBy: Keys.CodingKeys.self)
                var resultsRaw = try container.nestedUnkeyedContainer(forKey: .results)
                
                while !resultsRaw.isAtEnd {
                    LOArray.append(try resultsRaw.decode(LearningObjective.self))
//                    let propertiyObject = try resultsRaw.nestedContainer(keyedBy: Keys.ResultsKeys.self)
//                    let id = try propertiyObject.decode(String.self, forKey: .id)
//                    LOArray.append(try propertiyObject.decode(LearningObjective.self, forKey: .properties))
                }
                self.results = LOArray
            }
            
        }
    }
}

enum Keys {
    enum CodingKeys: String, CodingKey {
        case object, results
    }
    
    enum ResultsKeys: String, CodingKey {
        case properties
        case id
    }
}












