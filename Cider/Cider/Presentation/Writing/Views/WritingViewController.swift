//
//  WritingViewController.swift
//  Cider
//
//  Created by 임영선 on 2023/07/16.
//

import UIKit

final class WritingViewController: UIViewController {
    
    private lazy var authenticationView: WritingView = {
        let view = WritingView(type: .authentication)
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapAuthentication)))
        return view
    }()
    
    private lazy var challengeOpenView: WritingView = {
        let view = WritingView(type: .challengeOpen)
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapChallengeOpen)))
        return view
    }()
    
    private let stackView = UIStackView(
        axis: .vertical,
        alignment: .fill,
        distribution: .fillEqually,
        spacing: 32
    )

    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
}

private extension WritingViewController {
    
    func setUp() {
        configure()
    }
    
    func configure() {
        view.backgroundColor = .white
        view.addSubviews(stackView)
        stackView.addArrangedSubviews(authenticationView, challengeOpenView)
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            stackView.topAnchor.constraint(equalTo: view.topAnchor, constant: 56),
            stackView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -66)
        ])
    }
    
    func pushChallengeTypeViewController() {
        guard let tabBarController = self.presentingViewController as? UITabBarController else {
            return
        }
        guard let navigationController = tabBarController.selectedViewController as? UINavigationController else {
            return
        }
        self.dismiss(animated: true) {
            let viewController = ChallengeTypeViewController()
            viewController.hidesBottomBarWhenPushed = true
            navigationController.pushViewController(viewController, animated: true)
        }
    }
    
    func pushCertifyViewController() {
        guard let tabBarController = self.presentingViewController as? UITabBarController else {
            return
        }
        guard let navigationController = tabBarController.selectedViewController as? UINavigationController else {
            return
        }
        self.dismiss(animated: true) {
            let viewController =  CertifyViewController(
                viewModel: CertifyViewModel(
                    usecase: DefaultCertifyUsecase(
                        repository: DefaultCertifyRepository()
                    )
                )
            )
            viewController.hidesBottomBarWhenPushed = true
            navigationController.pushViewController(viewController, animated: true)
        }
    }
    
}

private extension WritingViewController {
    
    @objc func didTapAuthentication(_ sender: Any?) {
        pushCertifyViewController()
    }
    
    @objc func didTapChallengeOpen(_ sender: Any?) {
        pushChallengeTypeViewController()
    }
    
}
