//
//  MyMissionCell.swift
//  Cider
//
//  Created by 임영선 on 2023/08/04.
//

import UIKit

final class MyMissionCell: UICollectionViewCell {
    
    static let identifier = "MyMissionCell"
        
    private lazy var leftTitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .custom.text
        label.font = CustomFont.PretendardBold(size: .xl2).font
        label.text = "나의 인증글"
        return label
    }()
    
    private lazy var rightChevronImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "line_arrow-right_24")
        return imageView
    }()
    
    private lazy var countLabel: UILabel = {
        let label = UILabel()
        label.font = CustomFont.PretendardBold(size: .sm).font
        label.textColor = .custom.main
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
        addSubviews(leftTitleLabel, rightChevronImageView, countLabel)
        NSLayoutConstraint.activate([
            leftTitleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 12),
            leftTitleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24),
            leftTitleLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            rightChevronImageView.widthAnchor.constraint(equalToConstant: 16),
            rightChevronImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            rightChevronImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24),
            countLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            countLabel.leadingAnchor.constraint(equalTo: leftTitleLabel.trailingAnchor, constant: 6)
        ])
    }
    
}

extension MyMissionCell {
    
    func setUp(count: String) {
        countLabel.text = count
    }
    
}
