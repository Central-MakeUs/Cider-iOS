//
//  CiderInfoView.swift
//  Cider
//
//  Created by 임영선 on 2023/07/21.
//

import UIKit

final class CiderInfoView: UIView {
    
    private lazy var infoLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = CustomFont.PretendardBold(size: .base).font
        label.text = "사이다 소개"
        return label
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = CustomFont.PretendardMedium(size: .xl4).font
        label.numberOfLines = 0
        label.text = "금융과 소비 고민을\n시원하게 해결하다"
        return label
    }()
    
    private lazy var readingLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = CustomFont.PretendardBold(size: .lg).font
        label.numberOfLines = 0
        label.text = "바로 읽기 〉〉"
        return label
    }()
    
    private func configure() {
        backgroundColor = .custom.main
        addSubviews(infoLabel, titleLabel, readingLabel)
        NSLayoutConstraint.activate([
            infoLabel.topAnchor.constraint(equalTo: topAnchor, constant: 24),
            infoLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            titleLabel.topAnchor.constraint(equalTo: infoLabel.bottomAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            readingLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 24),
            readingLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20)
        ])
    }
    
}
