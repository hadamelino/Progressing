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
    let client = API.Client()
    var pathProgressPublishSubject = PublishSubject<[PathProgress]>()
    var pathProgress = [PathProgress]()
    var highPriority = [LearningObjective]()
    var sections = [ProgressTableViewSection]()
    
    private func bind() {
        
        viewModel.fetchPathProgress()
        viewModel.sections.bind(to: tableView.rx.items(dataSource: ProgressDataSource.dataSource())).disposed(by: bag)

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
            make.left.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.right.equalTo(view.safeAreaLayoutGuide).offset(-20)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-20)
        }
        tableView.register(iOSProgressTableViewCell.self, forCellReuseIdentifier: iOSProgressTableViewCell.identifier)
    }
}

extension ProgressViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            print("here")
            let myLabel = UILabel()
            myLabel.frame = CGRect(x: 5, y: 3, width: 320, height: 20)
            myLabel.font = UIFont.boldSystemFont(ofSize: 18)
            myLabel.text = "Academy Progress"
            let headerView = UIView()
            headerView.addSubview(myLabel)

            return headerView
        }
        else {
            return UIView()
        }
            
    }
}

