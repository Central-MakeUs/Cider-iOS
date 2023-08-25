//
//  MyChallengeEmptyCell.swift
//  Cider
//
//  Created by 임영선 on 2023/08/25.
//

import UIKit

final class MyChallengeEmptyCell: UICollectionViewCell {
    
    static let identifier = "MyChallengeEmptyCell"
    
    private lazy var mainTitleLabel: UILabel = {
        let label = UILabel()
        label.font = CustomFont.PretendardRegular(size: .base).font
        label.textColor = .custom.emptySub
        label.textAlignment = .center
        return label
    }()
    
    private lazy var iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "challenge")
        imageView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 40).isActive = true
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
        self.backgroundColor = .custom.gray3
        contentView.addSubviews(mainTitleLabel, iconImageView)
        NSLayoutConstraint.activate([
            iconImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            iconImageView.topAnchor.constraint(equalTo: topAnchor, constant: 46),
            mainTitleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            mainTitleLabel.topAnchor.constraint(equalTo: iconImageView.bottomAnchor, constant: 11)
        ])
    }
    
}

extension MyChallengeEmptyCell {
    
    func setUp(title: String) {
        mainTitleLabel.text = title
    }
    
}
