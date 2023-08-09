//
//  SortingView.swift
//  Cider
//
//  Created by 임영선 on 2023/07/25.
//

import UIKit

final class SortingView: UIView {
    
    private lazy var sortingLabel: UILabel = {
        let label = UILabel()
        label.font = CustomFont.PretendardBold(size: .xl2).font
        label.text = "최신순"
        label.textColor = UIColor.custom.text
        label.heightAnchor.constraint(equalToConstant: 24).isActive = true
        return label
    }()
    
    private lazy var arrowImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "line_arrow-down_24")
        imageView.widthAnchor.constraint(equalToConstant: 24).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 24).isActive = true
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
        addSubviews(sortingLabel, arrowImageView)
        NSLayoutConstraint.activate([
            sortingLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            sortingLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            arrowImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            arrowImageView.leadingAnchor.constraint(equalTo: sortingLabel.trailingAnchor, constant: 4)
        ])
    }
    
}

extension SortingView {
    
    func setUp(text: String) {
        sortingLabel.text = text
    }
    
}
