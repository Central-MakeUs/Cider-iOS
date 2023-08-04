//
//  MissionView.swift
//  Cider
//
//  Created by 임영선 on 2023/08/01.
//

import UIKit

final class MissionView: UIView {
    
    private let type: ChallengeResultType
    
    private lazy var iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: type == .success ? "line_check_16" : "line_caution_16")
        imageView.heightAnchor.constraint(equalToConstant: 16).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 16).isActive = true
        return imageView
    }()
    
    private lazy var photoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.heightAnchor.constraint(equalToConstant: 150).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 150).isActive = true
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 4
        return imageView
    }()
    
    private lazy var infoLabel: UILabel = {
        let label = UILabel()
        label.font = CustomFont.PretendardBold(size: .base).font
        label.textColor = type == .success ? UIColor(red: 0.02, green: 0.53, blue: 1, alpha: 1) : .custom.text
        label.text = type == .success ? "이렇게 인증하면 성공" : "이렇게 인증하면 실패"
        return label
    }()
    
    init(type: ChallengeResultType) {
        self.type = type
        super.init(frame: .zero)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        addSubviews(iconImageView, photoImageView, infoLabel)
        NSLayoutConstraint.activate([
            self.heightAnchor.constraint(equalToConstant: 192),
            photoImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            photoImageView.bottomAnchor.constraint(equalTo: bottomAnchor),
            iconImageView.leadingAnchor.constraint(equalTo: photoImageView.leadingAnchor, constant: 9),
            iconImageView.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            infoLabel.topAnchor.constraint(equalTo: iconImageView.topAnchor),
            infoLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 4)
        ])
    }
    
}


extension MissionView {
    
    func setUp(image: UIImage?) {
        photoImageView.image = image
    }
    
}
