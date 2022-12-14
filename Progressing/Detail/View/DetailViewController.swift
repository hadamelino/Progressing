//
//  DetailViewController.swift
//  AcademyLOTracker
//
//  Created by Hada Melino Muhammad on 27/07/22.
//

import UIKit
import SnapKit

protocol DetailDelegate {
    func appendLOToSection(lo: LearningObjective)
}

class DetailViewController: UIViewController {
    
    lazy var shortGoalName = UILabel()
    lazy var objective = UILabel()
    lazy var keywordsLabel = UILabel()
    lazy var keywordsValue = UILabel()
    lazy var keywordsContainer = UIView()
    lazy var copySymbol = UIButton()
    lazy var copyLabelContainer = UIView()
    lazy var addButton = UIButton()
    
    var learningObjective: LearningObjective?
    let viewModel = DetailViewModel()
    var delegate: DetailDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupUI()
        setPropertyValue()
    }
    
    private func setupUI() {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.tintColor = UIColor(named: "uicolor")
        self.title = learningObjective?.code.title
        self.view.backgroundColor = UIColor(named: "bgColor")
        
        view.addSubview(shortGoalName)
        view.addSubview(objective)
        view.addSubview(keywordsLabel)
        
        view.addSubview(keywordsContainer)
        keywordsContainer.addSubview(keywordsValue)

        view.addSubview(copyLabelContainer)
        copyLabelContainer.addSubview(copySymbol)
        
        view.addSubview(addButton)

        shortGoalName.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.left.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.right.equalTo(view.safeAreaLayoutGuide).offset(-10)
        }
        shortGoalName.textColor = UIColor(named: "subtitle")
        shortGoalName.font = UIFont.italicSystemFont(ofSize: 16)
        
        objective.snp.makeConstraints { make in
            make.top.equalTo(shortGoalName.snp.bottom).offset(10)
            make.left.equalTo(shortGoalName)
            make.right.equalTo(shortGoalName)
        }
        objective.numberOfLines = 0
        
        if learningObjective?.electiveKeywords.richText != nil {
            keywordsLabel.snp.makeConstraints { make in
                make.top.equalTo(objective.snp.bottom).offset(30)
                make.left.equalTo(shortGoalName)
                make.right.equalTo(shortGoalName)
            }
            
            keywordsContainer.snp.makeConstraints { make in
                make.top.equalTo(keywordsLabel.snp.bottom).offset(10)
                make.left.equalTo(shortGoalName)
                make.width.equalToSuperview().multipliedBy(0.75)
            }
            makeShadow(view: keywordsContainer)

            keywordsValue.snp.makeConstraints { make in
                make.top.equalToSuperview().offset(20)
                make.left.equalToSuperview().offset(20)
                make.bottom.equalToSuperview().offset(-20)
                make.right.equalToSuperview().offset(-20)
            }
            keywordsValue.numberOfLines = 0
            keywordsValue.font = UIFont.italicSystemFont(ofSize: 14)
            
            copyLabelContainer.snp.makeConstraints { make in
                make.top.equalTo(keywordsContainer)
                make.left.equalTo(keywordsContainer.snp.right).offset(10)
                make.right.equalTo(view.safeAreaLayoutGuide).offset(-20)
                make.height.equalTo(keywordsContainer)
            }
            makeShadow(view: copyLabelContainer)

            copySymbol.snp.makeConstraints { make in
                make.top.equalToSuperview().offset(10)
                make.left.equalToSuperview().offset(10)
                make.bottom.equalToSuperview().offset(-10)
                make.right.equalToSuperview().offset(-10)
            }
                
        }
        
        addButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-20)
            make.left.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.right.equalTo(view.safeAreaLayoutGuide).offset(-20)
            make.height.equalTo(46)
        }
        
        addButton.layer.cornerRadius = 8
        
    }
    
    private func setPropertyValue() {
        guard let learningObjective = learningObjective else { return }

        shortGoalName.text = learningObjective.goal.select
        objective.text = learningObjective.objective.richText
        keywordsLabel.text = "Keywords"
        keywordsValue.text = learningObjective.electiveKeywords.richText
        copySymbol.setImage(UIImage(systemName: "doc.on.doc"), for: .normal)
        copySymbol.backgroundColor = .white
        copySymbol.contentMode = .scaleAspectFit
        copySymbol.tintColor = UIColor(named: "uicolor")
        copySymbol.addTarget(self, action: #selector(copyButtonPressed), for: .touchUpInside)
        addButton.setTitle("Add to High Priority LO", for: .normal)
        addButton.backgroundColor = UIColor(named: "uicolor")
        addButton.addTarget(self, action: #selector(addButtonPressed), for: .touchUpInside)
    }
    
    @objc func addButtonPressed() {
        guard let learningObjective = learningObjective else { return }
        viewModel.postLearningObjective(lo: learningObjective)
        let progressVC = navigationController?.viewControllers.first as! ProgressViewController
        progressVC.viewModel.appendHighPriorityLO(loToAppend: learningObjective)
    }
    
    @objc func copyButtonPressed() {
        UIPasteboard.general.string = learningObjective?.electiveKeywords.richText
        showOverlay()
    }
    
    private func showOverlay() {
        let overlay = UIView()
        let label = UILabel()
        
        overlay.addSubview(label)
        view.addSubview(overlay)
        
        overlay.backgroundColor = .systemGray6
        overlay.layer.cornerRadius = 8
        
        label.text = "Copied to Clipboard"
        label.font = UIFont.systemFont(ofSize: 14)
        
        label.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.left.equalToSuperview().offset(10)
            make.right.equalToSuperview().offset(-10)
            make.bottom.equalToSuperview().offset(-10)
        }
        
        overlay.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(keywordsValue.snp.bottom).offset(40)
        }
        
        UIView.animate(withDuration: 0.5, delay: 2, options: .curveEaseIn) {
            overlay.alpha = 0
            label.alpha = 0
        } completion: { complete in
            overlay.removeFromSuperview()
        }

        
    }
    
    private func makeShadow(view: UIView) {
        view.layer.cornerRadius = 8
        view.backgroundColor = .white
        view.layer.shadowOffset = CGSize(width: 1, height: 2)
        view.layer.shadowColor = UIColor(named: "shadow")?.cgColor
        view.layer.shadowRadius = 4
        view.layer.shadowOpacity = 1
    }

}
