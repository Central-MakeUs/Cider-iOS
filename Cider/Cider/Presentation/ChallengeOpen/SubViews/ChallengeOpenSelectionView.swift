//
//  challengeSelectionView.swift
//  Cider
//
//  Created by 임영선 on 2023/07/12.
//

import UIKit


final class ChallengeOpenSelectionView: UIView {
    
    private let mainTitle: String
    private let subTitle: String
    private let unit: String
    
    private lazy var mainTitleLabel = StarTitleLabel(title: mainTitle)
    
    private lazy var subTitleLabel: UILabel = {
        let label = UILabel()
        label.text = subTitle
        label.font = CustomFont.PretendardBold(size: .base).font
        label.textColor = .custom.icon
        return label
    }()
    
    private lazy var unitLabel: UILabel = {
        let label = UILabel()
        label.text = unit
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
        imageView.image = UIImage(systemName: "heart")
        imageView.heightAnchor.constraint(equalToConstant: 24).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 24).isActive = true
        return imageView
    }()
    
    init(mainTitle: String, subTitle: String, unit: String) {
        self.mainTitle = mainTitle
        self.subTitle = subTitle
        self.unit = unit
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
