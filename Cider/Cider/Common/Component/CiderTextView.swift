//
//  CiderTextView.swift
//  Cider
//
//  Created by 임영선 on 2023/07/12.
//

import UIKit

final class CiderTextView: UIView {
    
    private lazy var textView: CiderUITextView = {
        let textView = CiderUITextView()
        textView.text = placeHolder
        return textView
    }()
    
    private let maxLength: Int
    private let minLength: Int
    private let placeHolder: String
    
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
    
    init(minLength: Int, maxLength: Int, placeHolder: String) {
        self.maxLength = maxLength
        self.minLength = minLength
        self.placeHolder = placeHolder
        super.init(frame: .zero)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        textView.delegate = self
        addSubviews(textView, countLabel, errorLabel)
        NSLayoutConstraint.activate([
            textView.topAnchor.constraint(equalTo: topAnchor),
            textView.leadingAnchor.constraint(equalTo: leadingAnchor),
            textView.trailingAnchor.constraint(equalTo: trailingAnchor),
            countLabel.topAnchor.constraint(equalTo: textView.bottomAnchor, constant: 4),
            countLabel.trailingAnchor.constraint(equalTo: textView.trailingAnchor),
            errorLabel.topAnchor.constraint(equalTo: countLabel.topAnchor),
            errorLabel.leadingAnchor.constraint(equalTo: textView.leadingAnchor)
        ])
       
    }
  
}

extension CiderTextView: UITextViewDelegate {
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        guard let count = textView.text?.count else {
            return false
        }
        return count < maxLength
    }
    
    func textViewDidChange(_ textView: UITextView) {
        errorLabel.isHidden = true
        guard let count = textView.text?.count else {
            return
        }
        countLabel.text = "\(count)/\(maxLength)"
        if count >= minLength && count <= maxLength {
            self.textView.setStyle(.enabled)
        }
        else if count < minLength {
            self.textView.setStyle(.disabled)
            errorLabel.isHidden = false
            errorLabel.text = "최소 \(minLength)자 이상이어야 합니다"
        }
        else {
            self.textView.setStyle(.plain)
        }
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == placeHolder {
            textView.text = nil
            textView.textColor = .custom.text
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            textView.text = placeHolder
            textView.textColor = .custom.gray4
            self.textView.setStyle(.plain)
            self.errorLabel.isHidden = true
        }
    }
   
}


final class CiderUITextView: UITextView {
    
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
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


private extension CiderUITextView {
    
    private func configure() {
        backgroundColor = .custom.gray1
        font = CustomFont.PretendardBold(size: .base).font
        heightAnchor.constraint(equalToConstant: 150).isActive = true
        layer.cornerRadius = 4
        layer.borderWidth = 2
        layer.borderColor = UIColor.clear.cgColor
        textColor = .custom.gray4
    }
    
}
