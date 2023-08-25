//
//  LoginBlockViewController.swift
//  Cider
//
//  Created by 임영선 on 2023/08/26.
//

import UIKit

final class LoginBlockViewController: UIViewController {

    private lazy var backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 8
        view.addSubviews(mainTitleLabel, subTitleLabel, cancelButton)
        return view
    }()
    
    private lazy var mainTitleLabel: UILabel = {
        let label = UILabel()
        label.font = CustomFont.PretendardBold(size: .xl).font
        label.textColor = .custom.text
        label.text = "재가입 불가"
        return label
    }()
    
    private lazy var subTitleLabel: UILabel = {
        let label = UILabel()
        label.font = CustomFont.PretendardRegular(size: .base).font
        label.textColor = .custom.text
        label.text = "회원 탈퇴시 일주일 동안\n가입하실 수 없어요."
        label.setTextWithLineHeight(lineHeight: 18.2)
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    private lazy var cancelButton: UIButton = {
        let button = UIButton()
        button.setTitle("확인했어요", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .custom.main
        button.titleLabel?.font = CustomFont.PretendardBold(size: .lg).font
        button.layer.cornerRadius = 4
        button.addTarget(self, action: #selector(didTapCancel), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
    }

}

private extension LoginBlockViewController {
    
    func setUp() {
        configure()
    }
    
    func configure() {
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapCancel)))
        view.backgroundColor = .black.withAlphaComponent(0.6)
        view.addSubviews(backgroundView)
        NSLayoutConstraint.activate([
            backgroundView.heightAnchor.constraint(equalToConstant: 162),
            backgroundView.widthAnchor.constraint(equalToConstant: 248),
            backgroundView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            backgroundView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            mainTitleLabel.centerXAnchor.constraint(equalTo: backgroundView.centerXAnchor),
            mainTitleLabel.topAnchor.constraint(equalTo: backgroundView.topAnchor, constant: 28),
            subTitleLabel.topAnchor.constraint(equalTo: mainTitleLabel.bottomAnchor, constant: 8),
            subTitleLabel.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor, constant: 24),
            subTitleLabel.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor, constant: -24),
            cancelButton.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor, constant: 12),
            cancelButton.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor, constant: -12),
            cancelButton.bottomAnchor.constraint(equalTo: backgroundView.bottomAnchor, constant: -12),
            cancelButton.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor, constant: 12),
            cancelButton.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
    
    @objc func didTapCancel(_ sender: Any?) {
        self.dismiss(animated: true)
    }
    
}
