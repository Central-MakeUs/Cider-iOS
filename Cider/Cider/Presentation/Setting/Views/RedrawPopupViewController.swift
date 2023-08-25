//
//  RedrawPopupViewController.swift
//  Cider
//
//  Created by 임영선 on 2023/08/18.
//

import UIKit

final class RedrawPopupViewController: UIViewController {
    
    private let viewModel: RedrawViewModel

    private lazy var backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 8
        view.addSubviews(mainTitleLabel, subTitleLabel, cancelButton, redrawButton)
        return view
    }()
    
    private lazy var mainTitleLabel: UILabel = {
        let label = UILabel()
        label.font = CustomFont.PretendardBold(size: .xl).font
        label.textColor = .custom.text
        label.text = "정말 탈퇴하시겠습니까?"
        return label
    }()
    
    private lazy var subTitleLabel: UILabel = {
        let label = UILabel()
        label.font = CustomFont.PretendardRegular(size: .base).font
        label.textColor = .custom.text
        label.text = "회원 탈퇴시 챌린지 내역과 내가 쓴 글이 영구적으로 삭제되며, 7일간 재가입이 불가해요."
        label.setTextWithLineHeight(lineHeight: 18.2)
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    private lazy var redrawButton: UIButton = {
        let button = UIButton()
        button.setTitle("탈퇴하기", for: .normal)
        button.setTitleColor(.custom.gray6, for: .normal)
        button.backgroundColor = .white
        button.layer.borderColor = UIColor.custom.gray3?.cgColor
        button.layer.borderWidth = 0.5
        button.titleLabel?.font = CustomFont.PretendardBold(size: .lg).font
        button.layer.cornerRadius = 4
        button.addTarget(self, action: #selector(didTapRedraw), for: .touchUpInside)
        return button
    }()
    
    private lazy var cancelButton: UIButton = {
        let button = UIButton()
        button.setTitle("돌아가기", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .custom.main
        button.titleLabel?.font = CustomFont.PretendardBold(size: .lg).font
        button.layer.cornerRadius = 4
        button.addTarget(self, action: #selector(didTapCancel), for: .touchUpInside)
        return button
    }()
    
    init(viewModel: RedrawViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
    }

}

private extension RedrawPopupViewController {
    
    func setUp() {
        configure()
    }
    
    func configure() {
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapCancel)))
        view.backgroundColor = .black.withAlphaComponent(0.6)
        view.addSubviews(backgroundView)
        NSLayoutConstraint.activate([
            backgroundView.heightAnchor.constraint(equalToConstant: 184),
            backgroundView.widthAnchor.constraint(equalToConstant: 256),
            backgroundView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            backgroundView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            mainTitleLabel.centerXAnchor.constraint(equalTo: backgroundView.centerXAnchor),
            mainTitleLabel.topAnchor.constraint(equalTo: backgroundView.topAnchor, constant: 28),
            subTitleLabel.topAnchor.constraint(equalTo: mainTitleLabel.bottomAnchor, constant: 8),
            subTitleLabel.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor, constant: 24),
            subTitleLabel.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor, constant: -24),
            cancelButton.heightAnchor.constraint(equalToConstant: 44),
            cancelButton.widthAnchor.constraint(equalToConstant: 110),
            cancelButton.bottomAnchor.constraint(equalTo: backgroundView.bottomAnchor, constant: -12),
            cancelButton.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor, constant: 12),
            redrawButton.heightAnchor.constraint(equalToConstant: 44),
            redrawButton.widthAnchor.constraint(equalToConstant: 110),
            redrawButton.bottomAnchor.constraint(equalTo: backgroundView.bottomAnchor, constant: -12),
            redrawButton.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor, constant: -12)
        ])
    }
    
    private func presentLoginViewController() {
        let viewController = LoginViewController(
            viewModel: LoginViewModel(
                useCase: DefaultLoginUsecase(
                    loginRepository: DefaultLoginRepository()
                )
            )
        )
        let navigationController = UINavigationController(rootViewController: viewController)
        navigationController.modalPresentationStyle = .fullScreen
        present(navigationController, animated: true)
    }
    
    @objc func didTapRedraw(_ sender: Any?) {
        // TODO: 탈퇴 로직 풀기
        //viewModel.redraw()
        if let loginType = UserDefaults.standard.read(key: .loginType) as? String {
            if loginType == "카카오" {
                UserDefaults.standard.write(key: .isRedrawKakao, value: true)
            } else if loginType == "애플" {
                UserDefaults.standard.write(key: .isRedrawKakao, value: true)
            }
        }
        
        UserManager.shared.updateLoginState(false)
        Keychain.deleteToken()
        self.presentLoginViewController()
    }
    
    @objc func didTapCancel(_ sender: Any?) {
        self.dismiss(animated: true)
    }
    
}
