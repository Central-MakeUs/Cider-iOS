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
    
    private lazy var clearButton: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "clearButton")
        imageView.heightAnchor.constraint(equalToConstant: 24).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 24).isActive = true
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapClear)))
        return imageView
    }()
    
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
        delegate = self
        backgroundColor = .custom.gray1
        font = CustomFont.PretendardBold(size: .base).font
        heightAnchor.constraint(equalToConstant: 44).isActive = true
        addLeftPadding()
        layer.cornerRadius = 4
        layer.borderWidth = 2
        layer.borderColor = UIColor.clear.cgColor
        rightView = clearButton
        rightViewMode = .always
        setHiddenClearButton(true)
    }
    
    @objc func didTapClear(_ sender: Any?) {
        self.text = ""
    }
    
}

extension CiderTextField: UITextFieldDelegate {
    
    func didChangeTextField(_ textField: UITextField) {
        if self.text == "" {
            setHiddenClearButton(true)
        } else {
            setHiddenClearButton(false)
        }
    }
    
}
