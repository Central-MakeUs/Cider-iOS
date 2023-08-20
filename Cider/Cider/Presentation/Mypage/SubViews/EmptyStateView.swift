//
//  EmptyStateView.swift
//  Cider
//
//  Created by 임영선 on 2023/08/20.
//

import UIKit

final class EmptyStateView: UIView {
    
    let mainTitle: String
    let subTitle: String
    
    private lazy var mainTitleLabel: UILabel = {
        let label = UILabel()
        label.font = CustomFont.PretendardBold(size: .xl2).font
        label.textColor = .custom.text
        label.text = mainTitle
        label.textAlignment = .center
        return label
    }()
    
    private lazy var subTitleLabel: UILabel = {
        let label = UILabel()
        label.font = CustomFont.PretendardRegular(size: .base).font
        label.textColor = .custom.emptySub
        label.text = subTitle
        label.setTextWithLineHeight(lineHeight: 18.2)
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "challenge")
        imageView.heightAnchor.constraint(equalToConstant: 80).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 80).isActive = true
        return imageView
    }()
    
    init(mainTitle: String, subTitle: String) {
        self.mainTitle =  mainTitle
        self.subTitle = subTitle
        super.init(frame: .zero)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        addSubviews(iconImageView, mainTitleLabel, subTitleLabel)
        NSLayoutConstraint.activate([
            iconImageView.topAnchor.constraint(equalTo: topAnchor),
            iconImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            mainTitleLabel.topAnchor.constraint(equalTo: iconImageView.bottomAnchor, constant: 16),
            mainTitleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            subTitleLabel.topAnchor.constraint(equalTo: mainTitleLabel.bottomAnchor, constant: 2),
            subTitleLabel.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
    }
    
}
