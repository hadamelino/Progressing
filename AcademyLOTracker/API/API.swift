//
//  APIHandler.swift
//  AcademyLOTracker
//
//  Created by Hada Melino Muhammad on 22/07/22.
//

import Foundation

enum API {
    
    enum Types {
        
        enum Endpoint {
            case queryDatabase(databaseID: String)
            case updatePageProperty(pageID: String)
            case createPage
            
            var url: URL {
                var components = URLComponents()
                components.host = "api.notion.com"
                components.scheme = "https"
                switch self {
                case .queryDatabase(let databaseID):
                    components.path = "/v1/databases/\(databaseID)/query"
                case .updatePageProperty(let pageID):
                    components.path = "/v1/pages/\(pageID)"
                case .createPage:
                    components.path = "/v1/pages"
                }
                return components.url!
            }
            
        }
        
        enum PageType {
            case pathProgress
            case learningObjective
        }
        
        enum Method: String {
            case POST
            case PATCH
        }
        
        enum CustomError: Error {
            case invalidUrl
            case invalidData
        }
        
    }
    
}
