//
//  challengeSelectionView.swift
//  Cider
//
//  Created by 임영선 on 2023/07/12.
//

import UIKit


final class ChallengeOpenSelectionView: UIView {
    
    private let type: ChallengeOpenSelectionType
    
    private lazy var mainTitleLabel = StarTitleLabel(title: type.mainTitle)
    
    private lazy var subTitleLabel: UILabel = {
        let label = UILabel()
        label.text = type.subTitle
        label.font = CustomFont.PretendardBold(size: .base).font
        label.textColor = .custom.icon
        return label
    }()
    
    private lazy var unitLabel: UILabel = {
        let label = UILabel()
        label.text = type.unit
        label.font = CustomFont.PretendardRegular(size: .base).font
        label.textColor = .custom.text
        return label
    }()
    
    private lazy var borderView: UIView = {
        let view = UIView()
        view.layer.borderColor = UIColor.custom.gray2?.cgColor
        view.layer.borderWidth = 1
        return view
    }()
    
    private lazy var iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: type.iconName)
        imageView.heightAnchor.constraint(equalToConstant: 24).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 24).isActive = true
        return imageView
    }()
    
    init(type: ChallengeOpenSelectionType) {
        self.type = type
        super.init(frame: .zero)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        addSubviews(mainTitleLabel, subTitleLabel, borderView)
        borderView.addSubviews(unitLabel, iconImageView)
        NSLayoutConstraint.activate([
            self.heightAnchor.constraint(equalToConstant: 77),
            mainTitleLabel.topAnchor.constraint(equalTo: topAnchor),
            mainTitleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            subTitleLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            subTitleLabel.topAnchor.constraint(equalTo: topAnchor),
            borderView.topAnchor.constraint(equalTo: mainTitleLabel.bottomAnchor, constant: 8),
            borderView.leadingAnchor.constraint(equalTo: leadingAnchor),
            borderView.trailingAnchor.constraint(equalTo: trailingAnchor),
            borderView.heightAnchor.constraint(equalToConstant: 44),
            unitLabel.centerYAnchor.constraint(equalTo: borderView.centerYAnchor),
            unitLabel.leadingAnchor.constraint(equalTo: borderView.leadingAnchor, constant: 12),
            iconImageView.centerYAnchor.constraint(equalTo: borderView.centerYAnchor),
            iconImageView.trailingAnchor.constraint(equalTo: borderView.trailingAnchor, constant: -12)
        ])
    }
    
}
