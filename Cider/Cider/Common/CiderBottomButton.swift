//
//  CiderBottomButton.swift
//  Cider
//
//  Created by 임영선 on 2023/07/07.
//

import UIKit

public enum CiderBottomButtonStyle {
    case disabled
    case enabled
}

final class CiderBottomButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    init(style: CiderBottomButtonStyle, title: String) {
        super.init(frame: .zero)
        setTitle(title, for: .normal)
        setStyle(style)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        titleLabel?.font = CustomFont.PretendardBold(size: .xl2).font
        setTitleColor(UIColor.white, for: .normal)
        heightAnchor.constraint(equalToConstant: 48).isActive = true
        layer.cornerRadius = 4
    }
    
    func setStyle(_ style: CiderBottomButtonStyle) {
        backgroundColor = style == .enabled ? UIColor.custom.main :  UIColor.custom.gray4
        isEnabled = style == .enabled ? true : false
    }
}
