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
        label.setTextWithLineHeight(lineHeight: 33.6)
        return label
    }()
    
    private lazy var readingLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = CustomFont.PretendardBold(size: .lg).font
        label.numberOfLines = 0
        label.text = "바로 읽기"
        return label
    }()
    
    private lazy var arrowImageView1: UIView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "line9")
        imageView.tintColor = .white
        imageView.heightAnchor.constraint(equalToConstant: 11.78).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 6.69).isActive = true
        return imageView
    }()
    
    private lazy var arrowImageView2: UIView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "line9")
        imageView.tintColor = .white
        imageView.heightAnchor.constraint(equalToConstant: 11.78).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 6.69).isActive = true
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
        backgroundColor = .custom.main
        addSubviews(infoLabel, titleLabel, readingLabel, arrowImageView1, arrowImageView2)
        NSLayoutConstraint.activate([
            infoLabel.topAnchor.constraint(equalTo: topAnchor, constant: 24),
            infoLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            titleLabel.topAnchor.constraint(equalTo: infoLabel.bottomAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            readingLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -24),
            readingLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            arrowImageView1.centerYAnchor.constraint(equalTo: readingLabel.centerYAnchor),
            arrowImageView1.leadingAnchor.constraint(equalTo: readingLabel.trailingAnchor, constant: 8),
            arrowImageView2.centerYAnchor.constraint(equalTo: arrowImageView1.centerYAnchor),
            arrowImageView2.leadingAnchor.constraint(equalTo: arrowImageView1.trailingAnchor)
        ])
    }
    
}
