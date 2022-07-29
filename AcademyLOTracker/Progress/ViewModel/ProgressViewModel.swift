//
//  ProgressViewModel.swift
//  AcademyLOTracker
//
//  Created by Hada Melino Muhammad on 22/07/22.
//

import Foundation
import RxSwift
import RxCocoa
import RxDataSources

class ProgressViewModel {
        
    let client = API.Client()
    let databaseID = Constant.DatabaseID()
//    var sections = PublishSubject<[ProgressTableViewSection]>()
    let sections = BehaviorRelay(value: [ProgressTableViewSection]())
    
    let bag = DisposeBag()
    
    func fetch() {
        var section: [ProgressTableViewSection] = []
        let pathData = client.request(endpoint: .queryDatabase(databaseID: databaseID.pathProgress), method: .post, expecting: ModelManager.Handler.Path.self)
        let highPriorityLO = client.request(endpoint: .queryDatabase(databaseID: databaseID.highPriorityLO), method: .post, expecting: ModelManager.Handler.Learning.self)
        
        Observable.zip(pathData, highPriorityLO) { (path, learning) in
            return (path.results, learning.results)
        }.subscribe { (path, learning) in
            let pathSection = path.map { path -> ProgressTableViewItem in
                let pathItem = ProgressTableViewItem.iosPathProgressItem(path: path)
                return pathItem
            }
            
            let learnSection = learning.map { learn -> ProgressTableViewItem in
                let learnItem = ProgressTableViewItem.highPriorityItem(high: learn)
                return learnItem
            }
            
            section.append(.iosPathSection(items: pathSection))
            section.append(.highPrioritySection(items: learnSection))
            self.sections.accept(section)
        }.disposed(by: bag)

    }
    
    
    func deleteHighPriorityLO() {
        
    }
    
    func appendHighPriorityLO(loToAppend: LearningObjective) {
        var updatedSection = [ProgressTableViewSection]()
        guard let pathSection = sections.value.first else { return }
        guard var highPrioritySection = sections.value.last else { return }
        var highPriorityItems = highPrioritySection.items
        highPriorityItems.insert(.highPriorityItem(high: loToAppend), at: 0)
        highPrioritySection = .highPrioritySection(items: highPriorityItems)
        
        updatedSection.append(pathSection)
        updatedSection.append(highPrioritySection)
        sections.accept(updatedSection)
    }
    
    func updateLearningProgress(loToUpdate: LearningObjective, progress: String){
        var updatedSection = [ProgressTableViewSection]()
        guard let pathSection = sections.value.first else { return }
        guard var highPrioritySection = sections.value.last else { return }
        var highPriorityItems = highPrioritySection.items
        guard let itemIndex = highPriorityItems.firstIndex(of: .highPriorityItem(high: loToUpdate)) else { return }
        var selectedLO = loToUpdate
        selectedLO.learningProgress.richText = progress
        print(itemIndex, selectedLO.learningProgress.richText)
        highPriorityItems.insert(.highPriorityItem(high: selectedLO), at: itemIndex)
        highPriorityItems.remove(at: itemIndex + 1)
        highPrioritySection = .highPrioritySection(items: highPriorityItems)
        
        updatedSection.append(pathSection)
        updatedSection.append(highPrioritySection)
        sections.accept(updatedSection)
    }
    
    func patchLearningProgress(with update: String, pageID: String) {

        let headers = [
          "Accept": "application/json",
          "Notion-Version": "2022-06-28",
          "Content-Type": "application/json",
          "Authorization": "secret_EOlEjtZ4Mkj330icjACrLhGfZcNx0kUQcmQxf8Rc3rI"
        ]
        
        let json = createUpdateJSON(propertyToUpdate: update)

        let request = NSMutableURLRequest(url: NSURL(string: "https://api.notion.com/v1/pages/\(pageID)")! as URL,
                                                cachePolicy: .useProtocolCachePolicy,
                                            timeoutInterval: 10.0)
        request.httpMethod = "PATCH"
        request.allHTTPHeaderFields = headers
        request.httpBody = Data(json.utf8)

        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
          if (error != nil) {
            print(error as Any)
          } else {
            let httpResponse = response as? HTTPURLResponse
              print(httpResponse?.statusCode)
          }
        })

        dataTask.resume()
    }
    
    func createUpdateJSON(propertyToUpdate: String) -> String {
        let learningProgress = Utilities().getLearningProgressText(checkBoxName: propertyToUpdate)
        let json =
        """
        {
            "properties": {
                "Learning Progress": {
                        "rich_text": [
                              {
                                "type": "text",
                                "text": {
                                  "content": "\(learningProgress)"
                                }
                        }]
                    }
            }
        
        }
        """
        
        return json
    }
    
}

