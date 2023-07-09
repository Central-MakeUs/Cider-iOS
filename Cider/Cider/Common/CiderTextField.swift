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
    
    private lazy var clearButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "clearButton"), for: .normal)
        button.frame = CGRect(x: 0, y: 0, width: 24, height: 24)
        button.contentMode = .scaleAspectFit
        button.contentMode = .scaleAspectFit
        button.addTarget(self, action: #selector(didTapClear), for: .touchUpInside)
        return button
    }()
    
    private let paddingView = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
    
    func setHiddenClearButton(_ isHidden: Bool) {
        clearButton.isHidden = isHidden
    }
    
}


private extension CiderTextField {
    
    private func configure() {
        backgroundColor = .custom.gray1
        font = CustomFont.PretendardBold(size: .base).font
        heightAnchor.constraint(equalToConstant: 44).isActive = true
        addLeftPadding()
        layer.cornerRadius = 4
        layer.borderWidth = 2
        layer.borderColor = UIColor.clear.cgColor
        
        paddingView.addSubviews(clearButton)
        NSLayoutConstraint.activate([
            paddingView.widthAnchor.constraint(equalToConstant: 12+24),
            paddingView.heightAnchor.constraint(equalToConstant: 24),
            clearButton.topAnchor.constraint(equalTo: paddingView.topAnchor),
            clearButton.leadingAnchor.constraint(equalTo: paddingView.leadingAnchor),
            clearButton.bottomAnchor.constraint(equalTo: paddingView.bottomAnchor)
        ])
        rightView = paddingView
        rightViewMode = .always
        setHiddenClearButton(true)
        addTarget(self, action: #selector(didChangeTextField), for: .editingChanged)
        addTarget(self, action: #selector(didChangeTextField), for: .editingDidBegin)

    }
    
    @objc func didTapClear(_ sender: Any?) {
        self.text = ""
        setStyle(.plain)
        setHiddenClearButton(true)
    }
    
    @objc func didChangeTextField(_ textField: UITextField) {
        if self.text == "" {
            setHiddenClearButton(true)
        } else {
            setHiddenClearButton(false)
        }
    }
    
}
