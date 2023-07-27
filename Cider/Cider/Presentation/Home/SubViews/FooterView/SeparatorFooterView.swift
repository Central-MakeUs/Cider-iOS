//
//  SepartorFooterView.swift
//  Cider
//
//  Created by 임영선 on 2023/07/26.
//

import UIKit

final class SeparatorFooterView: UICollectionReusableView {
    
    static let identifier = "SepartorFooterView"
        
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .custom.gray2
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
