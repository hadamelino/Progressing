//
//  LearningObjectives.swift
//  AcademyLOTracker
//
//  Created by Hada Melino Muhammad on 23/07/22.
//

import Foundation


struct LearningObjective: Codable {
    var code: Property.Types.Title
    var objective: Property.Types.RichText
    var goal: Property.Types.Select
    var electiveKeywords: Property.Types.RichText
    var learningProgress: String
    
    init(from decoder: Decoder) throws {
        let pageProperties = try decoder.container(keyedBy: PageProperties.LearningProperties.self)
        code = try pageProperties.decode(Property.Types.Title.self, forKey: .code)
        objective = try pageProperties.decode(Property.Types.RichText.self, forKey: .objective)
        goal = try pageProperties.decode(Property.Types.Select.self, forKey: .goalShortName)
        learningProgress = "Not Started"
        electiveKeywords = try pageProperties.decode(Property.Types.RichText.self, forKey: .electiveKeywords)
    }
}

