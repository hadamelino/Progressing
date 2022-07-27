//
//  LearningTableViewCell.swift
//  AcademyLOTracker
//
//  Created by Hada Melino Muhammad on 27/07/22.
//

import UIKit
import SnapKit

class LearningTableViewCell: UITableViewCell {
    
    lazy var title = UILabel()
    lazy var objective = UILabel()
    lazy var disclosure = UIImageView()
    lazy var container = UIView()
    
    static var identifier = "learningObjectiveCell"
    
    var learningObjective: LearningObjective? {
        didSet {
            guard let learningObjective = learningObjective else { return }
            title.text = learningObjective.code.title
            objective.text = learningObjective.objective.richText
        }
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(container)
        container.addSubview(title)
        container.addSubview(objective)
        container.addSubview(disclosure)
        
        container.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(5)
            make.top.equalToSuperview().offset(5)
            make.right.equalToSuperview().offset(-5)
            make.bottom.equalToSuperview().offset(-5)
            make.height.equalTo(53)
        }
        
        title.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(10)
            make.top.equalToSuperview().offset(10)
            make.right.equalToSuperview().offset(-10)
        }

        objective.snp.makeConstraints { make in
            make.left.equalTo(title)
            make.top.equalTo(title.snp.bottom).offset(5)
            make.right.equalTo(disclosure.snp.left).offset(-10)
            make.bottom.equalToSuperview().offset(-10)
        }
        
        disclosure.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-20)
        }
        
        configureCell()
        
    }
    
    private func configureCell() {
        disclosure.image = UIImage(systemName: "chevron.right")
        tintColor = UIColor(named: "uicolor")
        container.backgroundColor = .white
        container.layer.cornerRadius = 8
        
        container.layer.shadowOffset = CGSize(width: 1, height: 2)
        container.layer.shadowColor = UIColor(named: "shadow")?.cgColor
        container.layer.shadowRadius = 4
        container.layer.shadowOpacity = 1
        
        title.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        objective.font = UIFont.systemFont(ofSize: 14)
        objective.textColor = UIColor(named: "subtitle")
        
        self.contentView.backgroundColor = UIColor(named: "bgColor")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
