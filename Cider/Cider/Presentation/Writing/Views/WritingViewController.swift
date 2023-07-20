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
    
    private lazy var feedView: WritingView = {
        let view = WritingView(type: .feed)
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapFeed)))
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
        stackView.addArrangedSubviews(authenticationView, feedView, challengeOpenView)
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            stackView.topAnchor.constraint(equalTo: view.topAnchor, constant: 56),
            stackView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -56)
        ])
    }
    
    func pushChallengeTypeViewController() {
        guard let presentingViewController = self.presentingViewController as? UINavigationController else {
            return
        }
        print(type(of: presentingViewController))
        self.dismiss(animated: true) {
            let viewController = ChallengeTypeViewController()
            presentingViewController.pushViewController(viewController, animated: true)
        }
    }
    
}

private extension WritingViewController {
    
    @objc func didTapAuthentication(_ sender: Any?) {
        print("didTapAuthentication")
    }
    
    @objc func didTapFeed(_ sender: Any?) {
        print("didTapFeed")
    }
    
    @objc func didTapChallengeOpen(_ sender: Any?) {
        pushChallengeTypeViewController()
    }
    
}
