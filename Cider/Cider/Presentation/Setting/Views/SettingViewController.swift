//
//  SettingViewController.swift
//  Cider
//
//  Created by 임영선 on 2023/08/18.
//

import UIKit

class SettingViewController: UIViewController {
    
    private lazy var accountView: SettingView = {
        let view = SettingView(title: "계정 관리", rightTitle: "", isHiddenArrowRight: true)
        return view
    }()
    
    private lazy var accountDetailView: AccountDetailView = {
        let title = UserDefaults.standard.read(key: .loginType) as? String ?? ""
        let email = UserDefaults.standard.read(key: .email) as? String ?? ""
        let view = AccountDetailView(title: title, account: email)
        return view
    }()
    
    private lazy var agreementView: SettingView = {
        let view = SettingView(title: "이용 약관", rightTitle: "", isHiddenArrowRight: false)
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapAgreement)))
        return view
    }()
    
    private lazy var privacyView: SettingView = {
        let view = SettingView(title: "개인정보 처리 방침", rightTitle: "", isHiddenArrowRight: false)
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapPrivacy)))
        return view
    }()
    
    private lazy var versionView: SettingView = {
        let view = SettingView(title: "버전 정보", rightTitle: version ?? "", isHiddenArrowRight: true)
        return view
    }()
    
    private lazy var logoutView: SettingView = {
        let view = SettingView(title: "로그아웃", rightTitle: "", isHiddenArrowRight: false)
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapLogout)))
        return view
    }()
    
    private lazy var withdrawButton: UIButton = {
        let button = UIButton()
        button.setTitle("회원 탈퇴", for: .normal)
        button.titleLabel?.font = CustomFont.PretendardRegular(size: .lg).font
        button.setTitleColor(.custom.icon, for: .normal)
        button.addTarget(self, action: #selector(didTapRedraw), for: .touchUpInside)
        return button
    }()
    
    private var version: String? {
        guard let dictionary = Bundle.main.infoDictionary else {
            return nil
        }
        return dictionary["CFBundleShortVersionString"] as? String
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNavigationBar()
    }

}

private extension SettingViewController {
    
    func setUp() {
        configure()
    }
    
    func setNavigationBar() {
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.navigationBar.topItem?.title = ""
        self.navigationItem.title = "설정"
        setNavigationBar(backgroundColor: .white, tintColor: .black, shadowColor: .clear)
    }
    
    func configure() {
        view.backgroundColor = .custom.gray2
        view.addSubviews(accountView, accountDetailView, agreementView, privacyView, versionView, logoutView, withdrawButton)
        NSLayoutConstraint.activate([
            accountView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            accountView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            accountView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            accountDetailView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            accountDetailView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            accountDetailView.topAnchor.constraint(equalTo: accountView.bottomAnchor),
            agreementView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            agreementView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            agreementView.topAnchor.constraint(equalTo: accountDetailView.bottomAnchor),
            privacyView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            privacyView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            privacyView.topAnchor.constraint(equalTo: agreementView.bottomAnchor),
            versionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            versionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            versionView.topAnchor.constraint(equalTo: privacyView.bottomAnchor),
            logoutView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            logoutView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            logoutView.topAnchor.constraint(equalTo: versionView.bottomAnchor),
            withdrawButton.topAnchor.constraint(equalTo: logoutView.bottomAnchor, constant: 8),
            withdrawButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24)
        ])
    }

}

private extension SettingViewController {
    
    func presentLoginViewController() {
        let viewController = LoginViewController(
            viewModel: LoginViewModel(
                useCase: DefaultLoginUsecase(
                    loginRepository: DefaultLoginRepository()
                )
            )
        )
        let navigationController = UINavigationController(rootViewController: viewController)
        navigationController.modalPresentationStyle = .fullScreen
        self.present(navigationController, animated: true)
    }
    
    func presentWebViewController(_ url: String) {
        let viewController = WebViewController(url: url)
        self.present(viewController, animated: true)
    }
    
    func presentPopupController() {
        let viewController = RedrawPopupViewController(
            viewModel: RedrawViewModel(
                usecase: DefaultRedrawUsecase(
                    repository: DefaultRedrawRepository()
                )
            )
        )
        viewController.modalPresentationStyle = .overFullScreen
        viewController.modalTransitionStyle = .crossDissolve
        self.present(viewController, animated: true)
    }
    
    @objc func didTapLogout() {
        UserManager.shared.updateLoginState(false)
        Keychain.deleteToken()
        presentLoginViewController()
    }
    
    @objc func didTapAgreement() {
        presentWebViewController("https://spiced-pentagon-516.notion.site/f54a1839ae5f43b6a839eda20124675d")
    }
    
    @objc func didTapPrivacy() {
       presentWebViewController("https://spiced-pentagon-516.notion.site/ccea6cb2cb6845d597cf76118fb6615c")
    }
    
    @objc func didTapRedraw() {
        presentPopupController()
    }
    
}
