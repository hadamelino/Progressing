//
//  LearningObjectives.swift
//  AcademyLOTracker
//
//  Created by Hada Melino Muhammad on 23/07/22.
//

import Foundation


struct LearningObjective: Codable, Equatable {
    var id: String
    var code: Property.Types.Title
    var objective: Property.Types.RichText
    var goal: Property.Types.Select
    var electiveKeywords: Property.Types.RichText
    var learningProgress: Property.Types.RichText
    
    init(from decoder: Decoder) throws {
        let keyedObject = try decoder.container(keyedBy: Keys.ResultsKeys.self)
        let pageProperties = try keyedObject.nestedContainer(keyedBy: PageProperties.LearningProperties.self, forKey: .properties)
        id = try keyedObject.decode(String.self, forKey: .id)
        code = try pageProperties.decode(Property.Types.Title.self, forKey: .code)
        objective = try pageProperties.decode(Property.Types.RichText.self, forKey: .objective)
        goal = try pageProperties.decode(Property.Types.Select.self, forKey: .goalShortName)
        learningProgress = try pageProperties.decode(Property.Types.RichText.self, forKey: .learningProgress)
        electiveKeywords = try pageProperties.decode(Property.Types.RichText.self, forKey: .electiveKeywords)
    }
}

