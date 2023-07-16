//
//  OnboardingCompleteViewController.swift
//  Cider
//
//  Created by 임영선 on 2023/07/16.
//

import UIKit

final class OnboardingCompleteViewController: UIViewController {

    private let mainTitleLabel = MainTitleLabel(title: "회원가입이\n완료되었어요")
    
    private lazy var bottomButton: CiderBottomButton = {
        let button = CiderBottomButton(style: .enabled, title: "홈으로 이동")
        button.addTarget(self, action: #selector(didTapBottomButton), for: .touchUpInside)
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

private extension OnboardingCompleteViewController {
    
    func setUp() {
        configure()
    }
    
    func configure() {
        view.backgroundColor = .white
        view.addSubviews(mainTitleLabel, bottomButton)
        NSLayoutConstraint.activate([
            mainTitleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 76),
            mainTitleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            bottomButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            bottomButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            bottomButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20)
        ])
    }
    
    func setNavigationBar() {
        self.navigationController?.navigationBar.topItem?.title = ""
        self.navigationItem.title = "회원가입 완료"
        self.navigationItem.setHidesBackButton(true, animated: true)
    }
    
    func showTabBarViewController() {
        let viewController = TabBarViewController()
        viewController.modalPresentationStyle = .fullScreen
        self.present(viewController, animated: true)
    }
    
    @objc func didTapBottomButton(_ sender: Any?) {
        showTabBarViewController()
    }
    
}

#if DEBUG
import SwiftUI

@available(iOS 13.0, *)
struct OnboardingCompleteViewController_Preview: PreviewProvider {
    static var devices = ["iPhone 12", "iPhone SE", "iPhone 11 Pro Max"]
    
    static var previews: some View {
        ForEach(devices, id: \.self) { deviceName in
            OnboardingCompleteViewController()
                .toPreview()
                .previewDevice(PreviewDevice(rawValue: deviceName))
                .previewDisplayName(deviceName)
        }
    }
}
#endif
