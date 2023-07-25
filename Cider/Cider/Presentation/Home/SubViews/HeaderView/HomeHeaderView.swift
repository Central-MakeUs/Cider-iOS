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
    
    private lazy var rightChevronImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "line_arrow-right_24")
        return imageView
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(axis: .horizontal, alignment: .fill, distribution: .fill, spacing: 4)
        return stackView
    }()
    
    private func configure() {
        addSubviews(leftTitleLabel, stackView)
        NSLayoutConstraint.activate([
            leftTitleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 12),
            leftTitleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24),
            leftTitleLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            stackView.heightAnchor.constraint(equalToConstant: 16),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24),
            stackView.centerYAnchor.constraint(equalTo: centerYAnchor),
            rightChevronImageView.widthAnchor.constraint(equalToConstant: 16),
        ])
    }
    
}

extension HomeHeaderView {
    
    func setUp(leftTitle: String, rightTitle: String, isClicked: Bool) {
        leftTitleLabel.text = leftTitle
        rightTitleLabel.text = rightTitle
        isClicked ? stackView.addArrangedSubviews(rightTitleLabel, rightChevronImageView)
        : stackView.addArrangedSubviews(rightTitleLabel)
        rightChevronImageView.isHidden = !isClicked
        stackView.isUserInteractionEnabled = isClicked
        configure()
    }
    
    func addActionRightTitle(_ target: Any?, action: Selector) {
        stackView.addGestureRecognizer(UITapGestureRecognizer(target: target, action: action))
    }
    
}
