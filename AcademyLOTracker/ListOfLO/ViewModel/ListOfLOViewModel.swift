//
//  ListOfLOViewModel.swift
//  AcademyLOTracker
//
//  Created by Hada Melino Muhammad on 27/07/22.
//

import Foundation
import RxSwift

class ListOfLOViewModel {
    
    let client = API.Client()
    let databaseID = Constant.DatabaseID()
    
    func fetchLO(for databaseID: String) -> Observable<[LearningObjective]> {
        return client.request(endpoint: .queryDatabase(databaseID: databaseID), method: .post, expecting: ModelManager.Handler.Learning.self).map { learning in
            return learning.results
        }
    }
    
    func getDatabaseID(from role: String) -> String {
        switch role {
        case "App Business & Marketing":
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
