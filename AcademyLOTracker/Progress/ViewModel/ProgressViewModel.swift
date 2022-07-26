//
//  ProgressViewModel.swift
//  AcademyLOTracker
//
//  Created by Hada Melino Muhammad on 22/07/22.
//

import Foundation
import RxSwift
import RxDataSources

class ProgressViewModel {
        
    let client = API.Client()
    let databaseID = Constant.DatabaseID()
    var pathProgressPublishSubject = PublishSubject<[PathProgress]>()
    var pathProgress = [PathProgress]()
    var highPriority = [LearningObjective]()
    var sections = PublishSubject<[ProgressTableViewSection]>()
                    
    func fetchPathProgress() {
        client.request(endpoint: .queryDatabase(databaseID: databaseID.pathProgress), method: .post, expecting: ModelManager.Handler.Path.self) { result in
            
            switch result {
            case .success(let path):
                print("success")
                self.pathProgress = path.results
                self.pathProgressPublishSubject.onNext(path.results)
                self.pathProgressPublishSubject.onCompleted()
                
                var tableViewItem = [ProgressTableViewItem]()
                for result in path.results {
                    tableViewItem.append(ProgressTableViewItem.iosPathProgressItem(path: result))
                }
                self.sections.onNext([.iosPathSection(items: tableViewItem)])
                self.sections.onCompleted()
                
            case .failure(let error):
                print("Error fetching path progress \(error)")
                print(error.localizedDescription)
            }

        }
    }
    
    func fetchHighPriorityLO() {
        client.request(endpoint: .queryDatabase(databaseID: databaseID.professionalSkills), method: .post, expecting: ModelManager.Handler.Learning.self) { result in
            switch result {
            case .success(let learning):
                print("success")
                self.highPriority = learning.results
                var tableViewItem = [ProgressTableViewItem]()
                for result in learning.results {
                    tableViewItem.append(ProgressTableViewItem.highPriorityItem(high: result))
                }
            case .failure(let error):
                print("Error fetching High Priority LO \(error)")
                print(error.localizedDescription)
            }
        }
    }
    
    
    func fetchLearningObjectives() {
        
    }
    
    func createDataSource() {
        
    }
    
    
    func updateLearningProgress() {
        
    }
    
}

