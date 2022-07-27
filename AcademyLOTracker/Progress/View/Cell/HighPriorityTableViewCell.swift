//
//  HighPriorityTableViewCell.swift
//  AcademyLOTracker
//
//  Created by Hada Melino Muhammad on 26/07/22.
//

import UIKit

class HighPriorityTableViewCell: UITableViewCell {
    
    lazy var title = UILabel()
    lazy var progress = UILabel()
    lazy var container = UIView()
    
    
    var highPriority: LearningObjective? {
        didSet {
            guard let highPriority = highPriority else { return }
            let learningProgress = highPriority.learningProgress
            title.text = highPriority.code.title
            progress.text = getLearningProgressEmoji(progress: learningProgress) + " " + learningProgress
        }
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(container)
        container.addSubview(title)
        container.addSubview(progress)
        
        container.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(20)
            make.top.equalToSuperview().offset(5)
            make.right.equalToSuperview().offset(-20)
            make.bottom.equalToSuperview().offset(-5)
            make.height.equalTo(44)
        }
        
        title.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(10)
            make.top.equalToSuperview().offset(5)
            make.bottom.equalToSuperview().offset(-5)
        }
        
        progress.snp.makeConstraints { make in
            make.top.equalTo(title.snp.top)
            make.bottom.equalTo(title.snp.bottom)
            make.right.equalToSuperview().offset(-10)
        }
        
        configureCell()
    }
    
    func configureCell() {
        container.backgroundColor = .white
        container.layer.cornerRadius = 10
      
        container.layer.shadowOffset = CGSize(width: 1, height: 2)
        container.layer.shadowColor = UIColor(named: "shadow")?.cgColor
        container.layer.shadowRadius = 4
        container.layer.shadowOpacity = 1
                
        title.font = UIFont.systemFont(ofSize: 16)
        
        progress.font = UIFont.systemFont(ofSize: 14)
        progress.textColor = UIColor(named: "uicolor")
        
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

private func getLearningProgressEmoji(progress: String) -> String {
    let emojiConstant = Constant.LearningProgressEmoji()
    
    switch progress {
    case "Not Started":
        return emojiConstant.notStarted
    case "Beginning":
        return emojiConstant.beginning
    case "Progressing":
        return emojiConstant.progressing
    case "Proficient":
        return emojiConstant.proficient
    case "Examplary":
        return emojiConstant.examplary
    default:
        return emojiConstant.notStarted
    }
}
