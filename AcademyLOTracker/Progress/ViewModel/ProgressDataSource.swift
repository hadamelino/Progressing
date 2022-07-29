//
//  ProgressDataSource.swift
//  AcademyLOTracker
//
//  Created by Hada Melino Muhammad on 26/07/22.
//

import Foundation
import RxDataSources
import RxSwift
import RxCocoa
import UIKit

struct ProgressDataSource {
    typealias DataSource = RxTableViewSectionedAnimatedDataSource
    
    static func dataSource(vc: ProgressViewController) -> DataSource<ProgressTableViewSection> {
        return RxTableViewSectionedAnimatedDataSource(animationConfiguration: AnimationConfiguration(insertAnimation: .fade,
                                                                                                     reloadAnimation: .fade,
                                                                                                     deleteAnimation: .left))
        { dataSource, table, index, item -> UITableViewCell in
            switch dataSource[index] {
            case .iosPathProgressItem(path: let path):
                let cell = table.dequeueReusableCell(withIdentifier: iOSProgressTableViewCell.identifier, for: index) as! iOSProgressTableViewCell
                cell.pathProgress = path
                return cell
            case .highPriorityItem(high: let learning):
                let cell = table.dequeueReusableCell(withIdentifier: HighPriorityTableViewCell.identifier, for: index) as! HighPriorityTableViewCell
                cell.highPriority = learning
                cell.delegate = vc
                return cell
            }
        } titleForHeaderInSection: { dataSource, index in
            return dataSource.sectionModels[index].identity
        }  canEditRowAtIndexPath: { _, _ in
            return true
            }
        }
    }



enum TableViewEditingCommand {
    case DeleteItem(IndexPath)
}

struct SectionedTableViewState {
    var sections: [ProgressTableViewSection]
    
    init(sections: [ProgressTableViewSection]) {
        self.sections = sections
    }

    func execute(command: TableViewEditingCommand) -> SectionedTableViewState {
        switch command {
        case .DeleteItem(let indexPath):
            var sections = self.sections
            var items = sections[indexPath.section].items
            items.remove(at: indexPath.row)
            sections[indexPath.section] = ProgressTableViewSection(original: sections[indexPath.section], items: items)
            return SectionedTableViewState(sections: sections)
        }
    }
}




