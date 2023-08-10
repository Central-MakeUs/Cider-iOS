//
//  HomeDetailInfoCell.swift
//  Cider
//
//  Created by 임영선 on 2023/07/24.
//

import UIKit

final class HomeDetailInfoCell: UICollectionViewCell {
    
    static let identifier = "HomeDetailInfoCell"
    
    private lazy var mainTitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = CustomFont.PretendardMedium(size: .xl4).font
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var iconImageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        addSubviews(mainTitleLabel, iconImageView)
        NSLayoutConstraint.activate([
            mainTitleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24),
            iconImageView.heightAnchor.constraint(equalToConstant: 140),
            iconImageView.widthAnchor.constraint(equalToConstant: 140),
            iconImageView.centerYAnchor.constraint(equalTo: mainTitleLabel.centerYAnchor),
            iconImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -7)
        ])
    }
    
}

extension HomeDetailInfoCell {
    
    func setUp(_ type: HomeDetailType) {
        backgroundColor = type.mainColor
        mainTitleLabel.text = type.mainTitle
        mainTitleLabel.setTextWithLineHeight(lineHeight: 33.6)
        mainTitleLabel.topAnchor.constraint(equalTo: topAnchor, constant: type == .popularChallenge ? 24 : 40).isActive = true
        iconImageView.image = UIImage(named: type.iconName)
    }
    
}
