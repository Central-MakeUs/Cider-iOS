//
//  ReviewInfoView.swift
//  Cider
//
//  Created by 임영선 on 2023/07/20.
//

import UIKit

final class ReviewInfoView: UIView {
    
    private let title1: String
    private let title2: String
    
    private lazy var titleLabel1: UILabel = {
        let label = UILabel()
        label.text = title1
        label.font = CustomFont.PretendardBold(size: .base).font
        label.textColor = .custom.gray6
        return label
    }()
    
    private lazy var titleLabel2: UILabel = {
        let label = UILabel()
        label.text = title2
        label.font = CustomFont.PretendardBold(size: .base).font
        label.textColor = .custom.gray6
        return label
    }()
    
    init(titles: [String]) {
        title1 = titles[0]
        title2 = titles[1]
        super.init(frame: .zero)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        backgroundColor = .custom.lightBlue
        layer.cornerRadius = 8
        addSubviews(titleLabel1, titleLabel2)
        NSLayoutConstraint.activate([
            titleLabel1.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
            titleLabel1.topAnchor.constraint(equalTo: topAnchor, constant: 20),
            titleLabel2.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
            titleLabel2.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20)
        ])
        
    }
    
}
