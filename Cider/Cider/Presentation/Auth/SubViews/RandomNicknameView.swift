//
//  RandomNicknameView.swift
//  Cider
//
//  Created by 임영선 on 2023/07/09.
//

import UIKit

final class RandomNicknameView: UIView {
    
    private lazy var refreshImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "refresh")
        imageView.heightAnchor.constraint(equalToConstant: 24).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 24).isActive = true
        return imageView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "랜덤 닉네임 만들기"
        label.textColor = .custom.gray6
        label.font = CustomFont.PretendardBold(size: .xl).font
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
        layer.borderColor = UIColor.custom.gray3?.cgColor
        layer.borderWidth = 1
        layer.cornerRadius = 4
        addSubviews(refreshImageView, titleLabel)
        NSLayoutConstraint.activate([
            refreshImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            refreshImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: refreshImageView.trailingAnchor)
        ])
    }
}
