//
//  Utilities.swift
//  AcademyLOTracker
//
//  Created by Hada Melino Muhammad on 28/07/22.
//

import Foundation

struct Utilities {
    func getLearningProgressEmoji(progress: String) -> String {
        let emojiConstant = Constant.LearningProgressEmoji()
        
        switch progress {
        case "Not Started":
            return emojiConstant.notStarted
        case "Beginning":
            return emojiConstant.beginning
        case "Progressing":
            return emojiConstant.progressing
        case "Proficient":
            return emojiConstant.proficient
        case "Examplary":
            return emojiConstant.examplary
        default:
            return emojiConstant.notStarted
        }
    }
    
    func getApiKey() -> String {
        guard let value = Bundle.main.object(forInfoDictionaryKey: "API_KEY") as? String else {return ""}
        return value
    }
}
