//
//  ViewController.swift
//  Cider
//
//  Created by 임영선 on 2023/06/24.
//

import UIKit
import Combine
import KakaoSDKAuth
import KakaoSDKUser
import AuthenticationServices

final class LoginViewController: UIViewController {
    
    private let viewModel: LoginViewModel
    private var cancellables = Set<AnyCancellable>()
    
    private lazy var logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "Logo")
        imageView.heightAnchor.constraint(equalToConstant: 64).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 64).isActive = true
        return imageView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = CustomFont.PretendardBold(size: .xl5).font
        label.text = "시작하는\n금융챌린지\n지금"
        label.textColor = .custom.text
        label.setTextWithLineHeight(lineHeight: 39.2)
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var appleLoginButton: UIButton = {
        var configuration = UIButton.Configuration.plain()
        configuration.image = UIImage(systemName: "apple.logo", withConfiguration: UIImage.SymbolConfiguration(pointSize: 13))
        configuration.imagePadding = 10
        configuration.imagePlacement = .leading
        let button = UIButton(configuration: configuration)
        button.setTitle("Apple로 시작", for: .normal)
        button.titleLabel?.font = CustomFont.PretendardMedium(size: .xl2).font
        button.tintColor = .white
        button.backgroundColor = .black
        button.heightAnchor.constraint(equalToConstant: 44).isActive = true
        button.layer.cornerRadius = 4
        button.addTarget(self, action: #selector(didTapAppleLogin), for: .touchUpInside)
        return button
    }()
    
    private lazy var kakaoLoginButton: UIButton = {
        let button = UIButton()
        button.setTitle("카카오톡으로 시작", for: .normal)
        button.titleLabel?.font = CustomFont.PretendardMedium(size: .xl2).font
        button.setImage(UIImage(named: "kakao"), for: .normal)
        button.backgroundColor = .custom.kakao
        button.heightAnchor.constraint(equalToConstant: 44).isActive = true
        button.setTitleColor(.custom.text, for: .normal)
        button.layer.cornerRadius = 4
        button.addTarget(self, action: #selector(didTapKakaoLogin), for: .touchUpInside)
        return button
    }()
    
    init(viewModel: LoginViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        setUp()
        
    }
    
}

private extension LoginViewController {
    
    func setUp() {
        configure()
        bind()
    }
    
    func configure() {
        view.addSubviews(logoImageView, titleLabel, appleLoginButton, kakaoLoginButton)
        NSLayoutConstraint.activate([
            logoImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 130),
            logoImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            titleLabel.leadingAnchor.constraint(equalTo: logoImageView.leadingAnchor),
            titleLabel.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 16),
            kakaoLoginButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            kakaoLoginButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            kakaoLoginButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            appleLoginButton.bottomAnchor.constraint(equalTo: kakaoLoginButton.topAnchor, constant: -12),
            appleLoginButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            appleLoginButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24)
            
        ])
    }
    
    func bind() {
        viewModel.state.receive(on: DispatchQueue.main)
            .sink { [weak self] state in
                switch state {
                case .login(let isSuccess, let isNewUser):
                    guard isSuccess else {
                        return
                    }
                    isNewUser ? self?.pushServiceAgreeViewController() : self?.presentTabBarViewController()
                case .showEnabledLogin:
                    self?.presentLoginBlockViewController()
                }
            }.store(in: &cancellables)
    }
    
    func pushServiceAgreeViewController() {
        let viewController = ServiceAgreeViewController(viewModel: ServiceAgreeViewModel())
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    func presentTabBarViewController() {
        UserManager.shared.updateLoginState(true)
        let viewController = TabBarViewController()
        viewController.modalPresentationStyle = .fullScreen
        self.present(viewController, animated: true)
    }
    
    func presentLoginBlockViewController() {
        let viewController = LoginBlockViewController()
        viewController.modalPresentationStyle = .overFullScreen
        viewController.modalTransitionStyle = .crossDissolve
        self.present(viewController, animated: true)
    }
    
}

private extension LoginViewController {
    
    @objc func didTapAppleLogin() {
        appleLogin()
    }
    
    @objc func didTapKakaoLogin() {
        kakaoLogin()
    }
    
}

private extension LoginViewController {
    
    func kakaoLogin() {
        if UserApi.isKakaoTalkLoginAvailable() {
            UserApi.shared.loginWithKakaoTalk { [weak self] oauthToken, error in
                if let error {
                    print(error)
                } else {
                    guard let accessToken = oauthToken?.accessToken else {
                        return
                    }
                    print("accessToken = \(accessToken)")
                    self?.viewModel.kakaoLogin(token: accessToken)
                    self?.writeKakaoUserDefaults()
                }
            }
        } else {
            UserApi.shared.loginWithKakaoAccount { [weak self] oauthToken, error in
                if let error {
                    print(error)
                } else {
                    guard let accessToken = oauthToken?.accessToken else {
                        return
                    }
                    print(accessToken)
                    self?.viewModel.kakaoLogin(token: accessToken)
                    self?.writeKakaoUserDefaults()
                }
            }
        }
    }
    
    func writeKakaoUserDefaults() {
        UserApi.shared.me() { user, error in
            guard let email = user?.kakaoAccount?.email else {
                return
            }
            UserDefaults.standard.write(key: .loginType, value: "카카오")
            UserDefaults.standard.write(key: .kakaoEmail, value: email)
        }
    }
    
    func appleLogin() {
        let request = ASAuthorizationAppleIDProvider().createRequest()
        request.requestedScopes = [.fullName, .email]
        let controller = ASAuthorizationController(authorizationRequests: [request])
        controller.delegate = self
        controller.presentationContextProvider = self as? ASAuthorizationControllerPresentationContextProviding
        controller.performRequests()
    }
    
}

extension LoginViewController: ASAuthorizationControllerDelegate {
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let credential = authorization.credential as? ASAuthorizationAppleIDCredential {
            
            guard let identityToken = credential.identityToken,
                  let token = String(data: identityToken, encoding: .utf8) else {
                return
            }
            viewModel.appleLogin(token: token)
            UserDefaults.standard.write(key: .loginType, value: "애플")
            if let email = credential.email {
                UserDefaults.standard.write(key: .appleEmail, value: email)
            }
           
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print(LoginError.loginFail)
    }
    
}

#if DEBUG
import SwiftUI

@available(iOS 13.0, *)
struct VCPreview: PreviewProvider {
    static var devices = ["iPhone 12", "iPhone SE", "iPhone 11 Pro Max"]
    
    static var previews: some View {
        ForEach(devices, id: \.self) { deviceName in
            LoginViewController(
                viewModel: LoginViewModel(
                    useCase: DefaultLoginUsecase(
                        loginRepository: DefaultLoginRepository()
                    )
                )
            )
            .toPreview()
            .previewDevice(PreviewDevice(rawValue: deviceName))
            .previewDisplayName(deviceName)
        }
    }
}
#endif
