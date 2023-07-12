//
//  StarTitleLabel.swift
//  Cider
//
//  Created by 임영선 on 2023/07/12.
//

import UIKit

final class StarTitleLabel: UILabel {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    init(title: String) {
        super.init(frame: .zero)
        self.text = title
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        self.font = CustomFont.PretendardBold(size: .xl2).font
        self.textColor = .custom.text
        self.editTextColor(of: "*", in: .custom.main)
    }
    
}
