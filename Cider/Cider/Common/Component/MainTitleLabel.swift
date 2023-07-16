//
//  MainTitleLabel.swift
//  Cider
//
//  Created by 임영선 on 2023/07/16.
//

import UIKit

final class MainTitleLabel: UILabel {
    
    init(title: String) {
        super.init(frame: .zero)
        self.text = title
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        self.font = CustomFont.PretendardBold(size: .xl5).font
        self.textColor = .custom.text
        self.setTextWithLineHeight(lineHeight: 39.2)
        self.numberOfLines = 0
    }
    
}
