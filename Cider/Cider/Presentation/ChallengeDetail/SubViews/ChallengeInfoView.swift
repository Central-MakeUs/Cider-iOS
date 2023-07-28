//
//  ChallengeInfoView.swift
//  Cider
//
//  Created by 임영선 on 2023/07/28.
//

import UIKit

final class ChallengeInfoView: UIView {
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = CustomFont.PretendardRegular(size: .lg).font
        label.textColor = .custom.text
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var contentLabel: UILabel = {
        let label = UILabel()
        label.font = CustomFont.PretendardBold(size: .base).font
        label.textColor = .custom.gray7
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.heightAnchor.constraint(equalToConstant: 16).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 16).isActive = true
        return imageView
    }()
    
    init(iconName: String, title: String) {
        super.init(frame: .zero)
        iconImageView.image = UIImage(named: iconName)
        titleLabel.text = title
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        addSubviews(titleLabel, contentLabel, iconImageView)
        NSLayoutConstraint.activate([
            self.heightAnchor.constraint(equalToConstant: 20),
            iconImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            iconImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 4),
            contentLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            contentLabel.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
    
}


extension ChallengeInfoView {
    
    func setUp(content: String) {
        contentLabel.text = content
    }
    
}
