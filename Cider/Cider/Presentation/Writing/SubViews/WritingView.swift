//
//  WritingView.swift
//  Cider
//
//  Created by 임영선 on 2023/07/17.
//

import UIKit

final class WritingView: UIView {
    
    let type: WritingType
    
    init(type: WritingType) {
        self.type = type
        super.init(frame: .zero)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: type.iconImageName)
        imageView.heightAnchor.constraint(equalToConstant: 24).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 24).isActive = true
        return imageView
    }()
    
    private lazy var mainTitleLabel: UILabel = {
        let label = UILabel()
        label.text = type.mainTitle
        label.font = CustomFont.PretendardBold(size: .lg).font
        label.textColor = .custom.text
        return label
    }()
    
    private lazy var subTitleLabel: UILabel = {
        let label = UILabel()
        label.text = type.subTitle
        label.font = CustomFont.PretendardRegular(size: .base).font
        label.textColor = .custom.icon
        return label
    }()
    
    private func configure() {
        addSubviews(iconImageView, mainTitleLabel, subTitleLabel)
        NSLayoutConstraint.activate([
            iconImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            iconImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            mainTitleLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            mainTitleLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 4),
            subTitleLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            subTitleLabel.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
    
}
