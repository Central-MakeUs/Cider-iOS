//
//  challengeSelectionView.swift
//  Cider
//
//  Created by 임영선 on 2023/07/12.
//

import UIKit


final class ChallengeOpenSelectionView: UIView {
    
    private var mainTitle: String
    private var subTitle: String
    
    private lazy var mainTitleLabel = StarTitleLabel(title: mainTitle)
    
    init(mainTitle: String, subTitle: String) {
        self.mainTitle = mainTitle
        self.subTitle = subTitle
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
