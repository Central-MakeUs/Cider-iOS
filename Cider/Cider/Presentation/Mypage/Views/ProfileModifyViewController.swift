//
//  ProfileModifyViewController.swift
//  Cider
//
//  Created by 임영선 on 2023/08/17.
//

import UIKit
import Combine

final class ProfileModifyViewController: UIViewController {
    
    private var cancellables: Set<AnyCancellable> = .init()

    private lazy var profileLabel: UILabel = {
        let label = UILabel()
        label.text = "프로필"
        label.font = CustomFont.PretendardBold(size: .xl2).font
        label.textColor = .custom.text
        return label
    }()
    
    private lazy var nicknameLabel: UILabel = {
        let label = UILabel()
        label.text = "닉네임"
        label.font = CustomFont.PretendardBold(size: .xl2).font
        label.textColor = .custom.text
        return label
    }()
    
    private lazy var profileView: UIView = {
        let view = UIView()
        view.addSubviews(profileImageView, cameraImageView)
        view.heightAnchor.constraint(equalToConstant: 84).isActive = true
        view.widthAnchor.constraint(equalToConstant: 84).isActive = true
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapProfile)))
        return view
    }()
    
    private lazy var profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.heightAnchor.constraint(equalToConstant: 82).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 82).isActive = true
        imageView.layer.cornerRadius = 41
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage(named: "sample")
        return imageView
    }()
    
    private lazy var cameraImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.heightAnchor.constraint(equalToConstant: 24).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 24).isActive = true
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage(named: "circleCamera")
        return imageView
    }()
    
    private lazy var nicknameTextFieldView: ModifyTextFieldView = {
        let view = ModifyTextFieldView(minLength: 2, maxLength: 10)
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNavigationBar()
    }

}

private extension ProfileModifyViewController {
    
    func setUp() {
        configure()
        setNotificationCenter()
    }
    
    func setNavigationBar() {
        self.navigationController?.navigationBar.topItem?.title = ""
        self.navigationItem.title = "프로필 수정"
        setNavigationBar(backgroundColor: .white, tintColor: .black)
    }
    
    func configure() {
        view.backgroundColor = .white
        view.addSubviews(profileLabel, profileView, nicknameLabel, nicknameTextFieldView)
        NSLayoutConstraint.activate([
            profileLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            profileLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            profileImageView.topAnchor.constraint(equalTo: profileView.topAnchor),
            profileImageView.leadingAnchor.constraint(equalTo: profileView.leadingAnchor),
            cameraImageView.bottomAnchor.constraint(equalTo: profileView.bottomAnchor),
            cameraImageView.trailingAnchor.constraint(equalTo: profileView.trailingAnchor),
            profileView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            profileView.topAnchor.constraint(equalTo: profileLabel.bottomAnchor, constant: 16),
            nicknameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            nicknameLabel.topAnchor.constraint(equalTo: profileView.bottomAnchor, constant: 36),
            nicknameTextFieldView.heightAnchor.constraint(equalToConstant: 65),
            nicknameTextFieldView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            nicknameTextFieldView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            nicknameTextFieldView.topAnchor.constraint(equalTo: nicknameLabel.bottomAnchor, constant: 8)
        ])
    }
    
    func setNotificationCenter() {
        NotificationCenter.default.publisher(for: .selectProfileImage)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] notification in
                guard let self = self else {
                    return
                }
                guard let image = notification.object as? UIImage else {
                    return
                }
                self.profileImageView.image = image
            }
            .store(in: &cancellables)
    }
    
}

private extension ProfileModifyViewController {
    
    func presentBottomViewController() {
        let viewController = ProfileBottomViewController()
        if let sheet = viewController.sheetPresentationController {
            let identifier = UISheetPresentationController.Detent.Identifier("customMedium")
            let customDetent = UISheetPresentationController.Detent.custom(identifier: identifier) { context in
                return 200-34
            }
            sheet.detents = [customDetent]
            sheet.prefersScrollingExpandsWhenScrolledToEdge = false
            sheet.prefersGrabberVisible = true
        }
        self.present(viewController, animated: true)
    }
    
    @objc func didTapProfile(_ sender: Any?) {
        presentBottomViewController()
    }
    
}
