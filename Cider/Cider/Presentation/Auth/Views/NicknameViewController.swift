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
    
    private lazy var nicknameTextField: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = .custom.gray1
        textField.placeholder = "2~10자로 입력해주세요"
        textField.font = CustomFont.PretendardBold(size: .base).font
        textField.heightAnchor.constraint(equalToConstant: 44).isActive = true
        textField.addLeftPadding()
        textField.layer.cornerRadius = 4
        textField.layer.borderWidth = 2
        textField.layer.borderColor = UIColor.clear.cgColor
        textField.addTarget(self, action: #selector(didChangeTextField), for: .editingChanged)
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNavigationBar()
    }
    
}

private extension NicknameViewController {
    
    func configure() {
        view.backgroundColor = .white
        processView.setProcessType(.dataInput)
        view.addSubviews(processView, mainTitleLabel, subTitleLabel, nicknameTextField, nextButton)
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
            nextButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20)
        ])
    }
    
    func setNavigationBar() {
        self.navigationController?.navigationBar.topItem?.title = ""
        self.navigationItem.title = "회원가입"
    }
    
}

private extension NicknameViewController {
    
    @objc func didChangeTextField(_ sender: UITextField) {
        guard let count = sender.text?.count else {
            return
        }
        if count > 0 && count <= 10 {
            sender.layer.borderColor = UIColor.custom.main?.cgColor
        }
        else if count > 10 {
            sender.layer.borderColor = UIColor.custom.error?.cgColor
        }
        else {
            sender.layer.borderColor = UIColor.clear.cgColor
        }
    }
    
    @objc func didTapNext(_ sender: UIButton) {
        let viewController = GenderAndBitrhdayViewController()
        self.navigationController?.pushViewController(viewController, animated: true)
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
