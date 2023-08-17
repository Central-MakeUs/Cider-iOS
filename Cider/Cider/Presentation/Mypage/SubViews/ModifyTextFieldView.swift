//
//  ModifyTextFieldView.swift
//  Cider
//
//  Created by 임영선 on 2023/08/17.
//

import UIKit
import Combine

final class ModifyTextFieldView: UIView {
    
    var modifyTextField = ModifyTextField()
    let maxLength: Int
    let minLength: Int
    
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
    
    init(minLength: Int, maxLength: Int) {
        self.maxLength = maxLength
        self.minLength = minLength
        super.init(frame: .zero)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        modifyTextField.addTarget(self, action: #selector(didChangeTextField), for: .editingChanged)
        modifyTextField.setPlaceholderColor(.custom.gray4 ?? .gray)
        modifyTextField.delegate = self
        
        addSubviews(modifyTextField, countLabel, errorLabel)
        NSLayoutConstraint.activate([
            modifyTextField.topAnchor.constraint(equalTo: topAnchor),
            modifyTextField.leadingAnchor.constraint(equalTo: leadingAnchor),
            modifyTextField.trailingAnchor.constraint(equalTo: trailingAnchor),
            countLabel.topAnchor.constraint(equalTo: modifyTextField.bottomAnchor, constant: 4),
            countLabel.trailingAnchor.constraint(equalTo: modifyTextField.trailingAnchor),
            errorLabel.topAnchor.constraint(equalTo: countLabel.topAnchor),
            errorLabel.leadingAnchor.constraint(equalTo: modifyTextField.leadingAnchor)
        ])
       
    }
    
    @objc private func didChangeTextField(_ sender: UITextField) {
        guard let count = sender.text?.count else {
            return
        }
        countLabel.text = "\(count)/\(maxLength)"
        if count >= minLength && count <= maxLength {
            errorLabel.isHidden = true
            modifyTextField.setStyle(.enabled)
        }
        else if count < minLength {
            modifyTextField.setStyle(.disabled)
            errorLabel.isHidden = false
            errorLabel.textColor = .custom.error
            errorLabel.text = "최소 \(minLength)자 이상이어야 합니다"
        }
        else {
            modifyTextField.setStyle(.plain)
        }
        
        NotificationCenter.default.post(
            name: .didChangedCiderTextField,
            object: sender.text
        )
    }
    
    func setPlaceHoder(_ text: String) {
        modifyTextField.placeholder = text
    }
    
    func setErrorMessage(message: String, isEnabled: Bool) {
        errorLabel.isHidden = false
        modifyTextField.setStyle(isEnabled ? .enabled : .disabled)
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
                for: .didChangedCiderTextField,
                object: nil
            )
            .compactMap { $0.object as? String }
            .eraseToAnyPublisher()
        }
        return textPublisher
    }
    
    
}

extension ModifyTextFieldView: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let currentText = textField.text,
              let rangeOfTextToReplace = Range(range, in: currentText) else {
            return false
        }
        
        let newText = currentText.replacingCharacters(in: rangeOfTextToReplace, with: string)
        return newText.count <= maxLength
    }
    
}


final class ModifyTextField: UITextField {
    
    private lazy var editingButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "line_edit_24"), for: .normal)
        button.frame = CGRect(x: 0, y: 0, width: 24, height: 24)
        button.contentMode = .scaleAspectFit
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
  
}


private extension ModifyTextField {
    
    private func configure() {
        backgroundColor = .custom.gray1
        font = CustomFont.PretendardBold(size: .base).font
        heightAnchor.constraint(equalToConstant: 44).isActive = true
        addLeftPadding(12)
        layer.cornerRadius = 4
        layer.borderWidth = 2
        layer.borderColor = UIColor.clear.cgColor
        textColor = .custom.text
        
        paddingView.addSubviews(editingButton)
        NSLayoutConstraint.activate([
            paddingView.widthAnchor.constraint(equalToConstant: 12+24),
            paddingView.heightAnchor.constraint(equalToConstant: 24),
            editingButton.topAnchor.constraint(equalTo: paddingView.topAnchor),
            editingButton.leadingAnchor.constraint(equalTo: paddingView.leadingAnchor),
            editingButton.bottomAnchor.constraint(equalTo: paddingView.bottomAnchor)
        ])
        rightView = paddingView
        rightViewMode = .always
    }
   
}
