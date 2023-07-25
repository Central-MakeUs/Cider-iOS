//
//  HomeDetailInfoCell.swift
//  Cider
//
//  Created by 임영선 on 2023/07/24.
//

import UIKit

final class HomeDetailInfoCell: UICollectionViewCell {
    
    static let identifier = "HomeDetailInfoCell"
    
    private lazy var subTitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = CustomFont.PretendardBold(size: .base).font
        return label
    }()
    
    private lazy var mainTitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = CustomFont.PretendardMedium(size: .xl4).font
        label.numberOfLines = 0
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        addSubviews(subTitleLabel, mainTitleLabel)
        NSLayoutConstraint.activate([
            subTitleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 24),
            subTitleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            mainTitleLabel.topAnchor.constraint(equalTo: subTitleLabel.bottomAnchor, constant: 16),
            mainTitleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
        ])
    }
    
}

extension HomeDetailInfoCell {
    
    func setUp(_ type: HomeDetailType) {
        backgroundColor = type.mainColor
        mainTitleLabel.text = type.mainTitle
        mainTitleLabel.setTextWithLineHeight(lineHeight: 33.6)
        subTitleLabel.text = type.subTitle
    }
    
}
