//
//  HighPriorityTableViewCell.swift
//  AcademyLOTracker
//
//  Created by Hada Melino Muhammad on 26/07/22.
//

import UIKit
import RxSwift

protocol HighPriorityLODelegate: AnyObject {
    func didTapLearning(with highPriority: LearningObjective)
}

class HighPriorityTableViewCell: UITableViewCell {
    
    lazy var title = UILabel()
    lazy var progress = UIButton()
    lazy var container = UIView()
    
    let utilities = Utilities()
    static var identifier = "highPriorityLOCell"
    weak var delegate: HighPriorityLODelegate?
    var bag = DisposeBag()
    
    var highPriority: LearningObjective? {
        didSet {
            guard let highPriority = highPriority else { return }
            
            Observable.just(highPriority)
                .map { lo in
                    let learningProgress = lo.learningProgress.richText ?? ""
                    print(learningProgress)
                    return self.utilities.getLearningProgressEmoji(progress: learningProgress) + " " + learningProgress
                }.bind(to: progress.rx.title())
                .disposed(by: bag)
            
//            let learningProgress = highPriority.learningProgress.richText ?? ""
            title.text = highPriority.code.title
//            progress.setTitle(utilities.getLearningProgressEmoji(progress: learningProgress) + " " + learningProgress, for: .normal)

//            print(highPriority.code.title, learningProgress)
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
        
        progress.setTitleColor(UIColor(named: "uicolor"), for: .normal)
        progress.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        progress.addTarget(self, action: #selector(learningTapped), for: .touchUpInside)
        
        self.contentView.backgroundColor = UIColor(named: "bgColor")
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @objc func learningTapped() {
        guard let highPriority = highPriority else { return }
        delegate?.didTapLearning(with: highPriority)
    }

}

