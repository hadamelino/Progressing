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
    var sections = BehaviorRelay(value: [ProgressTableViewSection]())
    let bag = DisposeBag()
    
    func fetch() {
        var section: [ProgressTableViewSection] = []
        let pathData = client.request(endpoint: .queryDatabase(databaseID: databaseID.pathProgress), method: .post, expecting: ModelManager.Handler.Path.self)
        let learningData = client.request(endpoint: .queryDatabase(databaseID: databaseID.professionalSkills), method: .post, expecting: ModelManager.Handler.Learning.self)

        Observable.zip(pathData, learningData) { (path, learning) in
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
    
    func fetchHighPriorityLO() {
 
    }
    
    
    func fetchLearningObjectives() {
        
    }
    
    func createDataSource() {
        
    }
    
    
    func updateLearningProgress() {
        
    }
    
}

