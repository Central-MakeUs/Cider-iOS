//
//  HomeDetailHeaderView.swift
//  Cider
//
//  Created by 임영선 on 2023/07/24.
//

import UIKit

class SortingHeaderView: UICollectionReusableView {
    
    static let identifier = "SortingHeaderView"
        
    private lazy var sortingButton: UIButton = {
        let button = UIButton()
        button.setTitle("최신순", for: .normal)
        button.setTitleColor(UIColor.custom.text, for: .normal)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        addSubviews(sortingButton)
        NSLayoutConstraint.activate([
            sortingButton.leadingAnchor.constraint(equalTo: leadingAnchor),
            sortingButton.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}
