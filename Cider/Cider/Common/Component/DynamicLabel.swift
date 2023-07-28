//
//  DynamicLabel.swift
//  Cider
//
//  Created by 임영선 on 2023/07/28.
//

import UIKit

final class DynamicLabel: UILabel {
    
    let horizontalPadding: CGFloat
    let verticalPadding: CGFloat
    private lazy var padding = UIEdgeInsets(top: verticalPadding, left: horizontalPadding, bottom: verticalPadding, right: horizontalPadding)
    
    init(horizontalPadding: CGFloat, verticalPadding: CGFloat) {
        self.horizontalPadding = horizontalPadding
        self.verticalPadding = verticalPadding
        super.init(frame: .zero)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var intrinsicContentSize: CGSize {
        var contentSize = super.intrinsicContentSize
        contentSize.height += padding.top + padding.bottom
        contentSize.width += padding.left + padding.right
        
        return contentSize
    }
    
    private func configure() {
        textAlignment = .center
    }
    
    private func setCornerRadius() {
        clipsToBounds = true
        let width = super.intrinsicContentSize.width
        let height = super.intrinsicContentSize.height
        let longLength = width > height ? width : height
        let shortLength = width < height ? width : height
        let cornerRadius = (longLength * (shortLength/longLength))/2 * 1.2
        layer.cornerRadius = cornerRadius
    }
    
}
