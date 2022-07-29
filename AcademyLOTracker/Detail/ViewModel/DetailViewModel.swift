//
//  DetailViewModel.swift
//  AcademyLOTracker
//
//  Created by Hada Melino Muhammad on 27/07/22.
//

import Foundation
import SwiftyJSON

class DetailViewModel {
    
    let highPriorityLODatabase = Constant.DatabaseID().highPriorityLO
    
    func postLearningObjective(lo: LearningObjective) {
        let headers = [
            "Accept": "application/json",
            "Notion-Version": "2022-02-22",
            "Content-Type": "application/json",
            "Authorization": "secret_EOlEjtZ4Mkj330icjACrLhGfZcNx0kUQcmQxf8Rc3rI"
        ]

        let parameters = createPropertyJSON(object: lo)
        
        let request = NSMutableURLRequest(url: NSURL(string: "https://api.notion.com/v1/pages/")! as URL,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 10.0)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = headers
        request.httpBody = Data(parameters.utf8)
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            if (error != nil) {
                print(error as Any)
            } else {
                let httpResponse = response as? HTTPURLResponse
                print(httpResponse?.statusCode as Any)
            }
        })
        dataTask.resume()
    }
    
    private func createPropertyJSON(object: LearningObjective) -> String {
        
        let properties = """
        {
            "parent": {
                "type": "database_id",
                "database_id": "\(highPriorityLODatabase)"
            },
            "properties": {
              "Code": {
                "title": [
                  {
                    "type": "text",
                    "text": {
                      "content": "\(object.code.title ?? "")"
                    }
                  }
                ]
              },
            "Objective": {
                "rich_text": [
                  {
                    "type": "text",
                    "text": {
                      "content": "\(object.objective.richText ?? "")"
                    }
                  }]
                },
            "Goal Short Name": {
                "select": {
                  "name": "\(object.goal.select ?? "")"
                }
              },
            "Elective Keywords": {
                "rich_text": [
                  {
                    "type": "text",
                    "text": {
                      "content": "\(object.electiveKeywords.richText ?? "")"
                    }
                  }]
                },
            "Learning Progress": {
                "rich_text": [
                  {
                    "type": "text",
                    "text": {
                      "content": "Not Started"
                    }
                  }]
                },
            "Exposed": {
                "checkbox": false
              },
            "Can Implement with Help": {
                "checkbox": false
              },
            "Can Implement without Help": {
                "checkbox": false
              },
            "Teach Lessons to Peers": {
                "checkbox": false
              }
            }
        }
"""
        return properties
    }
    
    
}
