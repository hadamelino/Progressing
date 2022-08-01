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
    let utilities = Utilities()
    let sections = BehaviorRelay(value: [ProgressTableViewSection]())
    let bag = DisposeBag()
    
    func fetch() {
        var section: [ProgressTableViewSection] = []
        let pathData = client.request(endpoint: .queryDatabase(databaseID: databaseID.pathProgress), method: .POST, expecting: ModelManager.Handler.Path.self)
        let highPriorityLO = client.request(endpoint: .queryDatabase(databaseID: databaseID.highPriorityLO), method: .POST, expecting: ModelManager.Handler.Learning.self)
        
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
        selectedLO.learningProgress.richText = utilities.getLearningProgressText(checkBoxName: progress)
        highPriorityItems[itemIndex] = .highPriorityItem(high: selectedLO)
        highPrioritySection = .highPrioritySection(items: highPriorityItems)
        updatedSection.append(pathSection)
        updatedSection.append(highPrioritySection)
        
        sections.accept(updatedSection)
    }
    
    func patchLearningProgress(with update: String, pageID: String) {
        let jsonString = createUpdateJSON(propertyToUpdate: update)
        let data = Data(jsonString.utf8)
        let _ = client.request(endpoint: .updatePageProperty(pageID: pageID), method: .PATCH, expecting: ModelManager.Handler.AnyCodable.self, body: data).subscribe { _ in }.disposed(by: bag)
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

