//
//  PathProgress.swift
//  AcademyLOTracker
//
//  Created by Hada Melino Muhammad on 23/07/22.
//

import Foundation
    
struct PathProgress: Codable {
    let name: Property.Types.Title
    let finishedlo: Property.Types.RichText
    let totallo: Property.Types.RichText

    init(from decoder: Decoder) throws {
        let pageProperties = try decoder.container(keyedBy: PageProperties.PathProperties.self)
        name = try pageProperties.decode(Property.Types.Title.self, forKey: .name)
        finishedlo = try pageProperties.decode(Property.Types.RichText.self, forKey: .finishedLO)
        totallo = try pageProperties.decode(Property.Types.RichText.self, forKey: .totalLO)
    }
}



