//
//  ViewController.swift
//  Cider
//
//  Created by 임영선 on 2023/06/24.
//

import UIKit

final class LoginViewController: UIViewController {
    
    private lazy var logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "heart")
        imageView.heightAnchor.constraint(equalToConstant: 64).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 64).isActive = true
        return imageView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = CustomFont.PretendardBold(size: .xl5).font
        label.text = "금융과 소비를\n시원하게 연결하다\n사이다"
        label.textColor = .custom.text
        label.setTextWithLineHeight(lineHeight: 39.2)
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var appleLoginButton: UIButton = {
        let button = UIButton()
        button.setTitle("Apple로 시작", for: .normal)
        button.backgroundColor = .black
        button.heightAnchor.constraint(equalToConstant: 44).isActive = true
        button.layer.cornerRadius = 4
        button.addTarget(self, action: #selector(didTapAppleLogin), for: .touchUpInside)
        return button
    }()
    
    private lazy var kakaoLoginButton: UIButton = {
        let button = UIButton()
        button.setTitle("카카오톡으로 시작", for: .normal)
        button.backgroundColor = .custom.kakao
        button.heightAnchor.constraint(equalToConstant: 44).isActive = true
        button.setTitleColor(.custom.text, for: .normal)
        button.layer.cornerRadius = 4
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        configure()
        
    }

}

private extension LoginViewController {
    
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
    
}

private extension LoginViewController {
    
    @objc func didTapAppleLogin() {
        let viewController = ServiceAgreeViewController()
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
}


#if DEBUG
import SwiftUI

@available(iOS 13.0, *)
struct VCPreview: PreviewProvider {
    static var devices = ["iPhone 12", "iPhone SE", "iPhone 11 Pro Max"]

    static var previews: some View {
        ForEach(devices, id: \.self) { deviceName in
           LoginViewController()
                .toPreview()
                .previewDevice(PreviewDevice(rawValue: deviceName))
                .previewDisplayName(deviceName)
        }
    }
}
#endif
