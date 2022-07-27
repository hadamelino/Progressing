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

class ProgressViewController: UIViewController {
    
    lazy var tableView = UITableView()
    
    let databaseID = Constant.DatabaseID()
    let viewModel = ProgressViewModel()
    let bag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        bind()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //viewModel.fetch()
    }
    
    let client = API.Client()
    var pathProgressPublishSubject = PublishSubject<[PathProgress]>()
    var pathProgress = [PathProgress]()
    var highPriority = [LearningObjective]()
    var sections = [ProgressTableViewSection]()
    
    private func bind() {

        viewModel.sections.bind(to: tableView.rx.items(dataSource: ProgressDataSource.dataSource())).disposed(by: bag)
        viewModel.fetch()
        
        tableView.rx.modelSelected(ProgressTableViewItem.self).subscribe { item in
            switch item.element {
            case .iosPathProgressItem(path: let path):
                let nextVC = ListOfLOViewController()
                nextVC.pathName = path.name.title ?? "Role"
                self.navigationController?.pushViewController(nextVC, animated: true)
            case .highPriorityItem(high: let high):
                print("high")
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
    }
}

extension ProgressViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let myLabel = UILabel()
        myLabel.frame = CGRect(x: 10, y: 3, width: 320, height: 20)
        myLabel.font = UIFont.boldSystemFont(ofSize: 18)
        let headerView = UIView()
        headerView.addSubview(myLabel)

        if section == 0 {
            myLabel.text = "Academy Progress"
        }
        else {
            myLabel.text = "High Priority LO"
        }
        return headerView
    }
}

