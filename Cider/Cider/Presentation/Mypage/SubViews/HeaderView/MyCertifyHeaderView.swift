//
//  MyCertifyHeaderView.swift
//  Cider
//
//  Created by 임영선 on 2023/08/15.
//

import UIKit

final class MyCertifyHeaderView: UICollectionReusableView {
    
    static let identifier = "MyCertifyHeaderView"
    
    let challengeSelectionView = ChallengeSelectionView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        addSubviews(challengeSelectionView)
        NSLayoutConstraint.activate([
            challengeSelectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            challengeSelectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            challengeSelectionView.topAnchor.constraint(equalTo: topAnchor),
            challengeSelectionView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
}
