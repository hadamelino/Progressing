//
//  ListOfLOViewModel.swift
//  AcademyLOTracker
//
//  Created by Hada Melino Muhammad on 27/07/22.
//

import Foundation
import RxSwift
import RxRelay

class ListOfLOViewModel {
    
    let client = API.Client()
    let databaseID = Constant.DatabaseID()
    var fetchedLO = Observable<[LearningObjective]>.just([])
    let bag = DisposeBag()
    
    func fetchLO(for databaseID: String) {
        fetchedLO = client.request(endpoint: .queryDatabase(databaseID: databaseID), method: .POST, expecting: ModelManager.Handler.Learning.self).map { handler in
            return handler.results
        }
    }
    
    func searchLearningObjective(term: String) -> Observable<[LearningObjective]> {
        let filtered = fetchedLO.map {loArray in
            return loArray.filter { lo in
                (lo.code.title!.range(of: term, options: .caseInsensitive) != nil) || (lo.electiveKeywords.richText!.range(of: term, options: .caseInsensitive) != nil) || (lo.goal.select!.range(of: term, options: .caseInsensitive) != nil) || (lo.objective.richText!.range(of: term, options: .caseInsensitive) != nil)
            }
        }
        
        return filtered
    }
    
    func getDatabaseID(from role: String) -> String {
        switch role {
        case "App Business and Marketing":
            return databaseID.appAndBusiness
        case "Design":
            return databaseID.design
        case "Process":
            return databaseID.process
        case "Professional Skills":
            return databaseID.professionalSkills
        case "Tech":
            return databaseID.tech
        default:
            return ""
        }
    
    }
    
}
