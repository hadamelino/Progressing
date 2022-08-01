//
//  ListOfLOViewController.swift
//  AcademyLOTracker
//
//  Created by Hada Melino Muhammad on 27/07/22.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa


class ListOfLOViewController: UIViewController {
    
    lazy var tableView = UITableView()
    lazy var searchBar = UISearchBar()
    
    var viewModel = ListOfLOViewModel()
    var bag = DisposeBag()
    
    var pathName: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let databaseID = viewModel.getDatabaseID(from: pathName)
        viewModel.fetchLO(for: databaseID)
        setupUI()
        setupTextField()
        bind()
    }
    
    private func bind() {
                
        tableView.rx.modelSelected(LearningObjective.self).subscribe { learning in
            let nextVC = DetailViewController()
            nextVC.learningObjective = learning.element
            self.navigationController?.pushViewController(nextVC, animated: true)
        }.disposed(by: bag)
        
        let searchResults = searchBar.rx.text.orEmpty
            .throttle(.milliseconds(300), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .flatMapLatest { term -> Observable<[LearningObjective]> in
                if term.isEmpty {
                    return self.viewModel.fetchedLO
                } else {
                    return self.viewModel.searchLearningObjective(term: term)
                }
            }.bind(to: tableView.rx.items(cellIdentifier: LearningTableViewCell.identifier, cellType: LearningTableViewCell.self)) {
                index, model, cell in
                cell.learningObjective = model
            }.disposed(by: bag)
    }
     
    private func setupUI() {
        view.addSubview(tableView)
        view.addSubview(searchBar)
        view.backgroundColor = UIColor(named: "bgColor")
        searchBar.backgroundImage = UIImage()
        tableView.backgroundColor = UIColor(named: "bgColor")
        navigationController?.navigationBar.tintColor = UIColor(named: "uicolor")
        self.title = pathName
        
        searchBar.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.left.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.right.equalTo(view.safeAreaLayoutGuide).offset(-20)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom).offset(10)
            make.left.equalTo(searchBar)
            make.right.equalTo(searchBar)
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        tableView.separatorStyle = .none
        tableView.register(LearningTableViewCell.self, forCellReuseIdentifier: LearningTableViewCell.identifier)
        searchBar.placeholder = "Code, Objective, Keywords…"
    }
    
    private func setupTextField() {
        let toolbar = UIToolbar()
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneButtonTapped))
        toolbar.setItems([doneButton], animated: true)
        toolbar.sizeToFit()
        searchBar.inputAccessoryView = toolbar
    }
    
    @objc func doneButtonTapped(){
        searchBar.resignFirstResponder()
    }
}

