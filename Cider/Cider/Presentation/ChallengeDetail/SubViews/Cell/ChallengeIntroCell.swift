//
//  ChallengeInfoCell.swift
//  Cider
//
//  Created by 임영선 on 2023/07/28.
//

import UIKit

final class ChallengeIntroCell: UICollectionViewCell {
    
    static let identifier = "ChallengeIntroCell"
    
    private lazy var infoLabel: UILabel = {
        let label = UILabel()
        label.font = CustomFont.PretendardRegular(size: .base).font
        label.textColor = .custom.text
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
        self.backgroundColor = .white
        addSubviews(infoLabel)
        NSLayoutConstraint.activate([
            infoLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            infoLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            infoLabel.topAnchor.constraint(equalTo: topAnchor, constant: 0),
            infoLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -24)
        ])
    }
}

extension ChallengeIntroCell {
    
    func setUp(info: String) {
        infoLabel.text = info
        infoLabel.setTextWithLineHeight(lineHeight: 18.20)
    }
    
}
