//
//  PageProperties.swift
//  AcademyLOTracker
//
//  Created by Hada Melino Muhammad on 23/07/22.
//

import Foundation

enum PageProperties {
    
    enum PathProperties: String, CodingKey {
        case totalLO = "Total_LO"
        case finishedLO = "Finished_LO"
        case name = "Name"
    }
    
    enum LearningProperties: String, CodingKey {
        case code = "Code"
        case objective = "Objective"
        case goalShortName = "Goal Short Name"
        case electiveKeywords = "Elective Keywords"
        case learningProgress = "Learning Progress"
    }

} 
