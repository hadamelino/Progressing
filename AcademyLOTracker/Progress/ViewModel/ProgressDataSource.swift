//
//  ProgressDataSource.swift
//  AcademyLOTracker
//
//  Created by Hada Melino Muhammad on 26/07/22.
//

import Foundation
import RxDataSources

struct ProgressDataSource {
    typealias DataSource = RxTableViewSectionedReloadDataSource
    
    static func dataSource() -> DataSource<ProgressTableViewSection> {
        return .init { dataSource, tableView, indexPath, items -> UITableViewCell in
            switch dataSource[indexPath] {
            case .iosPathProgressItem(path: let pathProgress):
                let cell = iOSProgressTableViewCell()
                cell.pathProgress = pathProgress
                return cell
            case .highPriorityItem(high: let learningObjective):
                print(learningObjective)
                let cell = HighPriorityTableViewCell()
                cell.highPriority = learningObjective
                return cell
            }
        } titleForHeaderInSection: { dataSource, index in
            return dataSource.sectionModels[index].header
        }

    }
}

enum ProgressTableViewItem {
    case iosPathProgressItem(path: PathProgress)
    case highPriorityItem(high: LearningObjective)
}

enum ProgressTableViewSection {
    case iosPathSection(items: [ProgressTableViewItem])
    case highPrioritySection(items: [ProgressTableViewItem])
}

extension ProgressTableViewSection: SectionModelType {
    
    typealias Item = ProgressTableViewItem
    
    var header: String {
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
        case .iosPathSection(let items):
            self = .iosPathSection(items: items)
        case .highPrioritySection(let items):
            self = .highPrioritySection(items: items)
        }
    }
    
}
