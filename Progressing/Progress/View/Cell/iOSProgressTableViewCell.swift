//
//  iOSProgressTableViewCell.swift
//  AcademyLOTracker
//
//  Created by Hada Melino Muhammad on 23/07/22.
//

import UIKit
import SnapKit

class iOSProgressTableViewCell: UITableViewCell {
    
    static var identifier = "iosProgressCell"

    lazy var title = UILabel()
    lazy var subTitle = UILabel()
    lazy var container = UIView()
    lazy var disclosure = UIImageView()
    
    var pathProgress: PathProgress? {
        didSet {
            guard let pathProgress = pathProgress else { return }
            title.text = pathProgress.name.title ?? ""
            subTitle.text = "\(pathProgress.finishedlo.richText ?? "") out of \(pathProgress.totallo.richText ?? "") learning objectives"
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(container)
        container.addSubview(title)
        container.addSubview(subTitle)
        container.addSubview(disclosure)
        
        container.snp.makeConstraints { make in
            make.left.equalTo(contentView).offset(20)
            make.top.equalTo(contentView).offset(5)
            make.right.equalTo(contentView).offset(-20)
            make.bottom.equalTo(contentView).offset(-5)
        }
        
        title.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(10)
            make.top.equalToSuperview().offset(10)
            make.right.equalToSuperview().offset(-10)
        }
        
        subTitle.snp.makeConstraints { make in
            make.left.equalTo(title)
            make.right.equalTo(title)
            make.top.equalTo(title.snp.bottom).offset(5)
            make.bottom.equalToSuperview().offset(-10)
        }
        
        disclosure.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-20)
        }

        configureCell()
    }
    
    func configureCell() {
        disclosure.image = UIImage(systemName: "chevron.right")
        tintColor = UIColor(named: "uicolor")
        container.backgroundColor = .white
        container.layer.cornerRadius = 10
      
        container.layer.shadowOffset = CGSize(width: 1, height: 2)
        container.layer.shadowColor = UIColor(named: "shadow")?.cgColor
        container.layer.shadowRadius = 4
        container.layer.shadowOpacity = 1

        subTitle.font = UIFont.italicSystemFont(ofSize: 14)
        subTitle.textColor = UIColor(named: "subtitle")
        
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
