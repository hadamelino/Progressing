//
//  ProgressTableViewSection.swift
//  AcademyLOTracker
//
//  Created by Hada Melino Muhammad on 28/07/22.
//

import Foundation
import RxSwift
import RxDataSources
import RxCocoa

enum ProgressTableViewItem {
    case iosPathProgressItem(path: PathProgress)
    case highPriorityItem(high: LearningObjective)
}

enum ProgressTableViewSection {
    case iosPathSection(items: [ProgressTableViewItem])
    case highPrioritySection(items: [ProgressTableViewItem])
}

extension ProgressTableViewSection: AnimatableSectionModelType {

    typealias Identity = String
    typealias Item = ProgressTableViewItem
    
    var identity: String {
        switch self {
        case .iosPathSection:
            return "Academy Progress"
        case .highPrioritySection:
            return "High Priority LO"
        }
    }
    
    var items: [Item] {
        switch self {
        case .iosPathSection(items: let items):
            return items
        case .highPrioritySection(items: let items):
            return items
        }
    }
    
    init(original: ProgressTableViewSection, items: [Item]) {
        switch original {
        case .iosPathSection:
            self = .iosPathSection(items: items)
        case .highPrioritySection:
            self = .highPrioritySection(items: items)
        }
    }
    
}

extension ProgressTableViewItem: IdentifiableType, Equatable {
 
    typealias Identity = String
    
    var identity: String {
        switch self {
        case .highPriorityItem(high: let high):
            return high.id
        case .iosPathProgressItem(path: let path):
            return path.name.title ?? ""
        }
    }

}
