//
//  CiderTextField.swift
//  Cider
//
//  Created by 임영선 on 2023/07/09.
//

import UIKit

enum CiderTextFieldStyle {
    case plain
    case disabled
    case enabled
}

final class CiderTextField: UITextField {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        backgroundColor = .custom.gray1
        font = CustomFont.PretendardBold(size: .base).font
        heightAnchor.constraint(equalToConstant: 44).isActive = true
        addLeftPadding()
        layer.cornerRadius = 4
        layer.borderWidth = 2
        layer.borderColor = UIColor.clear.cgColor
    }
    
    func setStyle(_ style: CiderTextFieldStyle) {
        switch style {
        case .plain:
            layer.borderColor = UIColor.clear.cgColor
        case .disabled:
            layer.borderColor = UIColor.custom.error?.cgColor
        case .enabled:
            layer.borderColor = UIColor.custom.main?.cgColor
        }
    }
    
}
