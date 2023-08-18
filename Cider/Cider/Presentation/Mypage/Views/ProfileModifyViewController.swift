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
    private let viewModel: ProfileModifyViewModel

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
        view.setPlaceHoder("별명을 입력해주세요")
        return view
    }()
    
    private lazy var bottomButton: CiderBottomButton = {
        let button = CiderBottomButton(style: .enabled, title: "수정완료")
        button.addTarget(self, action: #selector(didTapModify), for: .touchUpInside)
        return button
    }()
    
    var bottomConstraint: NSLayoutConstraint?
    
    init(viewModel: ProfileModifyViewModel) {
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNavigationBar()
    }

}

private extension ProfileModifyViewController {
    
    func setUp() {
        configure()
        setNotificationCenter()
        hideKeyboard()
        bind()
        setData()
    }
    
    func bind() {
        viewModel.state.receive(on: DispatchQueue.main)
            .sink { [weak self] state in
                switch state {
                case .changeNextButtonState(let isEnabled):
                    self?.bottomButton.setStyle(isEnabled ? .enabled : .disabled)
                case .isSuccess(let isSuccess):
                    guard isSuccess else {
                        return
                    }
                    self?.navigationController?.popViewController(animated: true)
                }
            }
            .store(in: &cancellables)
        nicknameTextFieldView.textPublisher()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] name in
                self?.viewModel.changeNickname(name)
            }
            .store(in: &self.cancellables)
    }
    
    func setData() {
        profileImageView.image = viewModel.profileImage
        nicknameTextFieldView.modifyTextField.text = viewModel.nickname
    }
    
    func setNavigationBar() {
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.navigationBar.topItem?.title = ""
        self.navigationItem.title = "프로필 수정"
        setNavigationBar(backgroundColor: .white, tintColor: .black, shadowColor: .clear)
    }
    
    func configure() {
        view.backgroundColor = .white
        view.addSubviews(profileLabel, profileView, nicknameLabel, nicknameTextFieldView, bottomButton)
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
            nicknameTextFieldView.topAnchor.constraint(equalTo: nicknameLabel.bottomAnchor, constant: 8),
            bottomButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            bottomButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            bottomButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20)
        ])
        bottomConstraint = NSLayoutConstraint(item: bottomButton, attribute: .bottom, relatedBy: .equal, toItem: view.safeAreaLayoutGuide, attribute: .bottom, multiplier: 1.0, constant: 0)
        bottomConstraint?.isActive = true
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
                self.viewModel.profileImage = image
            }
            .store(in: &cancellables)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
}

private extension ProfileModifyViewController {
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            let keyboardHeight: CGFloat
            keyboardHeight = keyboardSize.height - self.view.safeAreaInsets.bottom
            self.bottomConstraint?.constant = -1 * keyboardHeight - 12
            self.view.layoutIfNeeded()
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        self.bottomConstraint?.constant = 0
        self.view.layoutIfNeeded()
    }
    
    @objc func didTapModify(_ sender: Any?) {
        viewModel.didTapModify()
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
