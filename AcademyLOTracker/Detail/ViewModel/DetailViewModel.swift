//
//  DetailViewModel.swift
//  AcademyLOTracker
//
//  Created by Hada Melino Muhammad on 27/07/22.
//

import Foundation
import RxSwift

class DetailViewModel {
    
    let highPriorityLODatabase = Constant.DatabaseID().highPriorityLO
    let client = API.Client()
    let bag = DisposeBag()
    
    func postLearningObjective(lo: LearningObjective) {
        let jsonData = createPropertyJSON(object: lo)
        let body = Data(jsonData.utf8)
        let _ = client.request(endpoint: .createPage, method: .POST, expecting: ModelManager.Handler.AnyCodable.self, body: body).subscribe { _ in }.disposed(by: bag)
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
