//
//  WritingViewController.swift
//  Cider
//
//  Created by 임영선 on 2023/07/16.
//

import UIKit

final class WritingViewController: UIViewController {
    
    private let authenticationView = WritingView(type: .authentication)
    private let feedView = WritingView(type: .feed)
    private let challengeOpenView = WritingView(type: .challengeOpen)
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
    
}
