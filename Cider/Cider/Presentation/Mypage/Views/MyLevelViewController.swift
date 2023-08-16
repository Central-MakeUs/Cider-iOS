//
//  MyLevelViewController.swift
//  Cider
//
//  Created by 임영선 on 2023/08/16.
//

import UIKit

final class MyLevelViewController: UIViewController {
    
    private let backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 8
        return view
    }()
    
    private let myLevelView = MyLevelView()
    
    private lazy var bottomButton: CiderBottomButton = {
        let button = CiderBottomButton(style: .enabled, title: "확인")
        button.addTarget(self, action: #selector(dismiss), for: .touchUpInside)
        return button
    }()
    
    private lazy var cancelButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "line_delete_24"), for: .normal)
        button.addTarget(self, action: #selector(dismiss), for: .touchUpInside)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    private func configure() {
        view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.6)
        view.addSubviews(backgroundView, myLevelView, bottomButton, cancelButton)
        NSLayoutConstraint.activate([
            backgroundView.heightAnchor.constraint(equalToConstant: 555),
            backgroundView.widthAnchor.constraint(equalToConstant: 256),
            backgroundView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            backgroundView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            myLevelView.topAnchor.constraint(equalTo: backgroundView.topAnchor, constant: 48),
            myLevelView.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor, constant: 16),
            myLevelView.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor, constant: -16),
            myLevelView.heightAnchor.constraint(equalToConstant: 491),
            bottomButton.heightAnchor.constraint(equalToConstant: 44),
            bottomButton.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor, constant: 16),
            bottomButton.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor, constant: -16),
            bottomButton.bottomAnchor.constraint(equalTo: backgroundView.bottomAnchor, constant: -16),
            cancelButton.topAnchor.constraint(equalTo: backgroundView.topAnchor, constant: 16),
            cancelButton.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor, constant: -16)
        ])
    }
    
    @objc private func dismiss(_ sender: Any?) {
        self.dismiss(animated: true)
    }
    
}
