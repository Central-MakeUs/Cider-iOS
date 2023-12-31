//
//  CiderTextField.swift
//  Cider
//
//  Created by 임영선 on 2023/07/09.
//

import UIKit
import Combine


final class CiderTextFieldView: UIView {
    
    lazy var ciderTextField = CiderTextField(notificationName: notificationName)
    let maxLength: Int
    let minLength: Int
    let notificationName: Notification.Name
    
    private lazy var countLabel: UILabel = {
        let label = UILabel()
        label.text = "0/\(maxLength)"
        label.font = CustomFont.PretendardRegular(size: .sm).font
        label.textColor = .custom.gray4

        return label
    }()
    
    private lazy var errorLabel: UILabel = {
        let label = UILabel()
        label.font = CustomFont.PretendardRegular(size: .sm).font
        label.textColor = .custom.error
        label.isHidden = true
        return label
    }()
    
    init(minLength: Int, maxLength: Int, notificationName: Notification.Name) {
        self.maxLength = maxLength
        self.minLength = minLength
        self.notificationName = notificationName
        super.init(frame: .zero)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        ciderTextField.addTarget(self, action: #selector(didChangeTextField), for: .editingChanged)
        ciderTextField.setPlaceholderColor(.custom.gray4 ?? .gray)
        ciderTextField.addActionClearButton(self, action: #selector(didTapClear))
        ciderTextField.delegate = self
        
        addSubviews(ciderTextField, countLabel, errorLabel)
        NSLayoutConstraint.activate([
            ciderTextField.topAnchor.constraint(equalTo: topAnchor),
            ciderTextField.leadingAnchor.constraint(equalTo: leadingAnchor),
            ciderTextField.trailingAnchor.constraint(equalTo: trailingAnchor),
            countLabel.topAnchor.constraint(equalTo: ciderTextField.bottomAnchor, constant: 4),
            countLabel.trailingAnchor.constraint(equalTo: ciderTextField.trailingAnchor),
            errorLabel.topAnchor.constraint(equalTo: countLabel.topAnchor),
            errorLabel.leadingAnchor.constraint(equalTo: ciderTextField.leadingAnchor)
        ])
       
    }
    
    @objc private func didChangeTextField(_ sender: UITextField) {
        guard let count = sender.text?.count else {
            return
        }
        countLabel.text = "\(count)/\(maxLength)"
        if count >= minLength && count <= maxLength {
            errorLabel.isHidden = true
            ciderTextField.setStyle(.enabled)
        }
        else if count < minLength {
            ciderTextField.setStyle(.disabled)
            errorLabel.isHidden = false
            errorLabel.textColor = .custom.error
            errorLabel.text = "최소 \(minLength)자 이상이어야 합니다"
        }
        else {
            ciderTextField.setStyle(.plain)
        }
        
        NotificationCenter.default.post(
            name: notificationName,
            object: sender.text
        )
    }
    
    @objc private func didTapClear(_ sender: Any?) {
        countLabel.text = "0/\(maxLength)"
        errorLabel.isHidden = true
    }
    
    func setPlaceHoder(_ text: String) {
        ciderTextField.placeholder = text
    }
    
    func setErrorMessage(message: String, isEnabled: Bool) {
        errorLabel.isHidden = false
        ciderTextField.setStyle(isEnabled ? .enabled : .disabled)
        errorLabel.text = message
        errorLabel.textColor = isEnabled ? .custom.main : .custom.error
    }
    
    func setTextCount(_ count: Int) {
        countLabel.text = "\(count)/\(maxLength)"
    }
    
    func isHiddenErrorMessage(_ isHidden: Bool) {
        errorLabel.isHidden = isHidden
    }
    
    func textPublisher() -> AnyPublisher<String, Never> {
        var textPublisher: AnyPublisher<String, Never> {
            NotificationCenter.default.publisher(
                for: notificationName,
                object: nil
            )
            .compactMap { $0.object as? String }
            .eraseToAnyPublisher()
        }
        return textPublisher
    }
    
    
}

extension CiderTextFieldView: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let currentText = textField.text,
              let rangeOfTextToReplace = Range(range, in: currentText) else {
            return false
        }
        
        let newText = currentText.replacingCharacters(in: rangeOfTextToReplace, with: string)
        return newText.count <= maxLength
    }
    
}


enum CiderTextFieldStyle {
    case plain
    case disabled
    case enabled
}

final class CiderTextField: UITextField {
    
    private lazy var clearButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "line_deletebox_24"), for: .normal)
        button.frame = CGRect(x: 0, y: 0, width: 24, height: 24)
        button.contentMode = .scaleAspectFit
        button.addTarget(self, action: #selector(didTapClear), for: .touchUpInside)
        return button
    }()
    
    private let paddingView = UIView()
    private let notificationName: Notification.Name
    
    init(notificationName: Notification.Name) {
        self.notificationName = notificationName
        super.init(frame: .zero)
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
    
    func addActionClearButton(_ target: Any?, action: Selector) {
        clearButton.addTarget(target, action: action, for: .touchUpInside)
    }
    
}


private extension CiderTextField {
    
    private func configure() {
        backgroundColor = .custom.gray1
        font = CustomFont.PretendardBold(size: .base).font
        heightAnchor.constraint(equalToConstant: 44).isActive = true
        addLeftPadding(12)
        layer.cornerRadius = 4
        layer.borderWidth = 2
        layer.borderColor = UIColor.clear.cgColor
        textColor = .custom.text
        
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
        NotificationCenter.default.post(
            name: notificationName,
            object: self.text
        )
    }
    
    @objc func didChangeTextField(_ textField: UITextField) {
        if self.text == "" {
            setHiddenClearButton(true)
        } else {
            setHiddenClearButton(false)
        }
    }
    
}
