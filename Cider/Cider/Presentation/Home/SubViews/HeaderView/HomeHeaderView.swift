//
//  HomeHeaderView.swift
//  Cider
//
//  Created by 임영선 on 2023/07/21.
//

import UIKit

class HomeHeaderView: UICollectionReusableView {
    
    static let identifier = "HomeHeaderView"
        
    private lazy var leftTitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .custom.text
        label.font = CustomFont.PretendardBold(size: .xl2).font
        return label
    }()
    
    private lazy var rightTitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .custom.gray5
        label.font = CustomFont.PretendardBold(size: .lg).font
        return label
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(axis: .horizontal, alignment: .fill, distribution: .fill, spacing: 4)
        stackView.addArrangedSubviews(rightTitleLabel)
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        addSubviews(leftTitleLabel, stackView)
        NSLayoutConstraint.activate([
            leftTitleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 12),
            leftTitleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24),
            leftTitleLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24),
            stackView.topAnchor.constraint(equalTo: topAnchor, constant: 12),
            stackView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
}

extension HomeHeaderView {
    
    func setUp(leftTitle: String, rightTitle: String) {
        leftTitleLabel.text = leftTitle
        rightTitleLabel.text = rightTitle
    }
    
    func addActionRightTitle(_ target: Any?, action: Selector) {
        stackView.addGestureRecognizer(UITapGestureRecognizer(target: target, action: action))
    }
    
}
