//
//  HomeDetailHeaderView.swift
//  Cider
//
//  Created by 임영선 on 2023/07/24.
//

import UIKit

class SortingHeaderView: UICollectionReusableView {
    
    static let identifier = "SortingHeaderView"
    private let sortingView = SortingView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        addSubviews(sortingView)
        NSLayoutConstraint.activate([
            sortingView.leadingAnchor.constraint(equalTo: leadingAnchor),
            sortingView.topAnchor.constraint(equalTo: topAnchor),
            sortingView.bottomAnchor.constraint(equalTo: bottomAnchor),
            sortingView.widthAnchor.constraint(equalToConstant: 75)
        ])
    }
}
