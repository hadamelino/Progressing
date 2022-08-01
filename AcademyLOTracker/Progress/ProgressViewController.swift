//
//  ViewController.swift
//  AcademyLOTracker
//
//  Created by Hada Melino Muhammad on 22/07/22.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import RxDataSources

protocol ProgressViewDelegate {
    func updateCellLabel(with learningProgress: String)
}

class ProgressViewController: UIViewController {
    
    lazy var tableView = UITableView(frame: .zero, style: .grouped)
    
    let databaseID = Constant.DatabaseID()
    let viewModel = ProgressViewModel()
    let bag = DisposeBag()
    var delegate: ProgressViewDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bind()
        viewModel.fetch()
    }

    private func bind() {
        
        viewModel.sections.asObservable().bind(to: tableView.rx.items(dataSource: ProgressDataSource.dataSource(vc: self))).disposed(by: bag)
        tableView.rx.modelSelected(ProgressTableViewItem.self).subscribe { item in
            switch item.element {
            case .iosPathProgressItem(path: let path):
                let nextVC = ListOfLOViewController()
                nextVC.pathName = path.name.title ?? "Role"
                self.navigationController?.pushViewController(nextVC, animated: true)
            case .highPriorityItem(high: _):
                return
            case .none:
                return
            }
        }.disposed(by: bag)
    }
    
    private func setupUI() {
        view.backgroundColor = UIColor(named: "bgColor")
        setupNavigationBar()
        setupTableView()
    }

    private func setupNavigationBar() {
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.title = "Progress"
    }
    
    private func setupTableView() {
        self.view.addSubview(tableView)
        tableView.separatorStyle = .none
        tableView.backgroundColor = UIColor(named: "bgColor")
        tableView.rx.setDelegate(self).disposed(by: bag)
    
        tableView.snp.makeConstraints { (make) in
            make.left.equalTo(view.safeAreaLayoutGuide)
            make.right.equalTo(view.safeAreaLayoutGuide)
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        tableView.register(iOSProgressTableViewCell.self, forCellReuseIdentifier: iOSProgressTableViewCell.identifier)
        tableView.register(HighPriorityTableViewCell.self, forCellReuseIdentifier: HighPriorityTableViewCell.identifier)
    }
}

extension ProgressViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let myLabel = UILabel()
        myLabel.font = UIFont.boldSystemFont(ofSize: 18)
        let headerView = UIView()

        if section == 0 {
            myLabel.frame = CGRect(x: 15, y: 20, width: 320, height: 20)
            myLabel.text = "Academy Progress"
        }
        else {
            myLabel.frame = CGRect(x: 15, y: 0, width: 320, height: 20)
            myLabel.text = "High Priority LO"
        }
        headerView.addSubview(myLabel)

        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 50
        } else {
            return 30
        }
    }
}

extension ProgressViewController: HighPriorityLODelegate {
    
    func didTapLearning(with highPriority: LearningObjective) {
        let optionMenu = UIAlertController(title: highPriority.code.title ?? "", message: highPriority.goal.select, preferredStyle: .actionSheet)
        optionMenu.view.tintColor = UIColor(named: "uicolor")
        let exposedAction = UIAlertAction(title: "Exposed", style: .default) { alert in
            self.viewModel.patchLearningProgress(with: alert.title ?? "", pageID: highPriority.id)
            self.viewModel.updateLearningProgress(loToUpdate: highPriority, progress: alert.title!)
        }
        let withHelpAction = UIAlertAction(title: "Can Implement with Help", style: .default) { alert in
            self.viewModel.patchLearningProgress(with: alert.title ?? "", pageID: highPriority.id)
            self.viewModel.updateLearningProgress(loToUpdate: highPriority, progress: alert.title!)
        }
        let withoutHelpAction = UIAlertAction(title: "Can Implement without Help", style: .default) { alert in
            self.viewModel.patchLearningProgress(with: alert.title ?? "", pageID: highPriority.id)
            self.viewModel.updateLearningProgress(loToUpdate: highPriority, progress: alert.title!)
        }
        let teachLessonAction = UIAlertAction(title: "Teach Lessons to Peers", style: .default) { alert in
            self.viewModel.patchLearningProgress(with: alert.title ?? "", pageID: highPriority.id)
            self.viewModel.updateLearningProgress(loToUpdate: highPriority, progress: alert.title!)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        optionMenu.addAction(exposedAction)
        optionMenu.addAction(withHelpAction)
        optionMenu.addAction(withoutHelpAction)
        optionMenu.addAction(teachLessonAction)
        optionMenu.addAction(cancelAction)
        
        self.present(optionMenu, animated: true)
    }
    
}



