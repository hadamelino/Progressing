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
    var pathName: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    
    private func setupUI() {
        view.addSubview(tableView)
        view.addSubview(searchBar)
        view.backgroundColor = UIColor(named: "bgColor")
        searchBar.backgroundImage = UIImage()
        tableView.backgroundColor = UIColor(named: "bgColor")
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
        
        searchBar.placeholder = "Code, Objective, Keywords…"
    }


}
