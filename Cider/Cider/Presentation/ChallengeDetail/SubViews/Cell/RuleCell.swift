//
//  RuleCell.swift
//  Cider
//
//  Created by 임영선 on 2023/07/28.
//

import UIKit

final class RuleCell: UICollectionViewCell {
    
    static let identifier = "RuleCell"
    
    let failRuleView = RuleView(.fail)
    let missionRuleView = RuleView(.mission)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        self.backgroundColor = .white
        addSubviews(failRuleView, missionRuleView)
        let width = (UIScreen.main.bounds.width-58)/2
        let height = width*0.78
        NSLayoutConstraint.activate([
            failRuleView.leadingAnchor.constraint(equalTo: leadingAnchor),
            failRuleView.topAnchor.constraint(equalTo: topAnchor),
            failRuleView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -24),
            failRuleView.widthAnchor.constraint(equalToConstant: width),
            failRuleView.heightAnchor.constraint(equalToConstant: height),
            missionRuleView.trailingAnchor.constraint(equalTo: trailingAnchor),
            missionRuleView.topAnchor.constraint(equalTo: topAnchor),
            missionRuleView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -24),
            missionRuleView.widthAnchor.constraint(equalToConstant: width),
            missionRuleView.heightAnchor.constraint(equalToConstant: height),
        ])
    }
    
}

extension RuleCell {
    
    func setUp(failText: String) {
        failRuleView.setUp(title: failText)
    }
    
}
