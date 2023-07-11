//
//  NicknameViewController.swift
//  Cider
//
//  Created by 임영선 on 2023/06/29.
//

import UIKit

final class NicknameViewController: UIViewController {

    private let processView = ProcessView()
    
    private lazy var mainTitleLabel: UILabel = {
        let label = UILabel()
        label.font = CustomFont.PretendardBold(size: .xl5).font
        label.text = "닉네임을\n입력해주세요"
        label.textColor = .custom.text
        label.setTextWithLineHeight(lineHeight: 39.2)
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var subTitleLabel: UILabel = {
        let label = UILabel()
        label.font = CustomFont.PretendardBold(size: .lg).font
        label.text = "닉네임은 10자 이하로 입력해주세요"
        label.textColor = .custom.main
        label.setTextWithLineHeight(lineHeight: 39.2)
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var errorLabel: UILabel = {
        let label = UILabel()
        label.font = CustomFont.PretendardBold(size: .lg).font
        label.textColor = .custom.main
        label.setTextWithLineHeight(lineHeight: 39.2)
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var nicknameTextField: CiderTextField = {
        let textField = CiderTextField()
        textField.placeholder = "2~10자로 입력해주세요"
        textField.addTarget(self, action: #selector(didChangeTextField), for: .editingChanged)
        textField.setPlaceholderColor(.custom.gray4 ?? .gray)
        textField.addActionClearButton(self, action: #selector(didTapClear))
        textField.delegate = self
        return textField
    }()
    
    private lazy var nextButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .custom.gray4
        button.setTitle("다음", for: .normal)
        button.titleLabel?.font = CustomFont.PretendardBold(size: .xl2).font
        button.setTitleColor(UIColor.white, for: .normal)
        button.heightAnchor.constraint(equalToConstant: 48).isActive = true
        button.layer.cornerRadius = 4
        button.addTarget(self, action: #selector(didTapNext), for: .touchUpInside)
        return button
    }()
    
    private lazy var randomNicknameView: RandomNicknameView = {
        let view = RandomNicknameView()
        view.widthAnchor.constraint(equalToConstant: 170).isActive = true
        view.heightAnchor.constraint(equalToConstant: 36).isActive = true
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapRandomNickname)))
        return view
    }()
    
    private lazy var nicknameCountLabel: UILabel = {
        let label = UILabel()
        label.text = "0/10"
        label.font = CustomFont.PretendardRegular(size: .sm).font
        label.textColor = .custom.gray4

        return label
    }()
    
    private lazy var nicknameErrorLabel: UILabel = {
        let label = UILabel()
        label.font = CustomFont.PretendardRegular(size: .sm).font
        label.textColor = .custom.error
        label.isHidden = true
        return label
    }()
    
    var bottomConstraint: NSLayoutConstraint?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNavigationBar()
    }
    
}

private extension NicknameViewController {
    
    func setUp() {
        configure()
        hideKeyboard()
        addNotification()
    }
    
    func configure() {
        view.backgroundColor = .white
        processView.setProcessType(.dataInput)
        
        view.addSubviews(processView, mainTitleLabel, subTitleLabel, nicknameTextField, nextButton, randomNicknameView, nicknameCountLabel, nicknameErrorLabel)
        NSLayoutConstraint.activate([
            processView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            processView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            processView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            mainTitleLabel.topAnchor.constraint(equalTo: processView.bottomAnchor, constant: 24),
            mainTitleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            subTitleLabel.topAnchor.constraint(equalTo: mainTitleLabel.bottomAnchor, constant: 8),
            subTitleLabel.leadingAnchor.constraint(equalTo: mainTitleLabel.leadingAnchor),
            nicknameTextField.topAnchor.constraint(equalTo: subTitleLabel.bottomAnchor, constant: 40),
            nicknameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            nicknameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            nextButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            nextButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            nextButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            randomNicknameView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            randomNicknameView.bottomAnchor.constraint(equalTo: nextButton.topAnchor, constant: -12),
            nicknameCountLabel.topAnchor.constraint(equalTo: nicknameTextField.bottomAnchor, constant: 4),
            nicknameCountLabel.trailingAnchor.constraint(equalTo: nicknameTextField.trailingAnchor),
            nicknameErrorLabel.topAnchor.constraint(equalTo: nicknameCountLabel.topAnchor),
            nicknameErrorLabel.leadingAnchor.constraint(equalTo: nicknameTextField.leadingAnchor)
        ])
        
        bottomConstraint = NSLayoutConstraint(item: nextButton, attribute: .bottom, relatedBy: .equal, toItem: view.safeAreaLayoutGuide, attribute: .bottom, multiplier: 1.0, constant: 0)
        bottomConstraint?.isActive = true
    }
    
    func setNavigationBar() {
        self.navigationController?.navigationBar.topItem?.title = ""
        self.navigationItem.title = "회원가입"
    }
    
    func addNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
}

private extension NicknameViewController {
    
    @objc func didChangeTextField(_ sender: UITextField) {
        nicknameErrorLabel.isHidden = true
        guard let count = sender.text?.count else {
            return
        }
        nicknameCountLabel.text = "\(count)/10"
        if count >= 2 && count <= 10 {
            nicknameTextField.setStyle(.enabled)
        }
        else if count == 1 {
            nicknameTextField.setStyle(.disabled)
            nicknameErrorLabel.isHidden = false
            nicknameErrorLabel.text = "2자 이상이어야 합니다"
        }
        else {
            nicknameTextField.setStyle(.plain)
        }
    }
    
    @objc func didTapNext(_ sender: UIButton) {
        let viewController = GenderAndBirthdayViewController()
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            let keyboardHeight: CGFloat
            keyboardHeight = keyboardSize.height - self.view.safeAreaInsets.bottom
            self.bottomConstraint?.constant = -1 * keyboardHeight - 12
            self.view.layoutIfNeeded()
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        debugPrint("keyboardWillHide")
        self.bottomConstraint?.constant = 0
        self.view.layoutIfNeeded()
    }
    
    @objc func didTapRandomNickname(_ sender: Any?) {
        print("didTapRandomNickname")
    }
    
    @objc func didTapClear(_ sender: Any?) {
        nicknameCountLabel.text = "0/10"
        nicknameErrorLabel.isHidden = true
    }
    
}

extension NicknameViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let count = textField.text?.count else {
            return false
        }
        return count < 10
    }
    
}


#if DEBUG
import SwiftUI

@available(iOS 13.0, *)
struct NicknameViewController_Preview: PreviewProvider {
    static var devices = ["iPhone 12", "iPhone SE", "iPhone 11 Pro Max"]

    static var previews: some View {
        ForEach(devices, id: \.self) { deviceName in
            NicknameViewController()
                .toPreview()
                .previewDevice(PreviewDevice(rawValue: deviceName))
                .previewDisplayName(deviceName)
        }
    }
}
#endif

