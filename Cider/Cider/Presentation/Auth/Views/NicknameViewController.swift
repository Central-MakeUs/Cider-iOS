//
//  NicknameViewController.swift
//  Cider
//
//  Created by 임영선 on 2023/06/29.
//

import UIKit
import Combine

final class NicknameViewController: UIViewController {
    
    private let viewModel: NicknameViewModel
    private var cancellables = Set<AnyCancellable>()
    
    private let processView = ProcessView()
    
    private let mainTitleLabel = MainTitleLabel(title: "닉네임을\n입력해주세요")
    
    private lazy var subTitleLabel: UILabel = {
        let label = UILabel()
        label.font = CustomFont.PretendardBold(size: .lg).font
        label.text = "닉네임은 10자 이하로 입력해주세요"
        label.textColor = .custom.main
        label.setTextWithLineHeight(lineHeight: 39.2)
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var ciderTextFieldView: CiderTextFieldView = {
        let view = CiderTextFieldView(minLength: 2, maxLength: 10, notificationName: .didChangedCiderTextField)
        view.ciderTextField.addTarget(self, action: #selector(isAvailableNickname), for: .editingChanged)
        view.ciderTextField.addActionClearButton(self, action: #selector(didTapClear))
        view.setPlaceHoder("2~10자로 입력해주세요")
        return view
    }()
    
    private lazy var nextButton: CiderBottomButton = {
        let button = CiderBottomButton(style: .disabled, title: "다음")
        button.addTarget(self, action: #selector(didTapNext), for: .touchUpInside)
        return button
    }()
    
    private lazy var randomNicknameView: RandomNicknameView = {
        let view = RandomNicknameView()
        view.widthAnchor.constraint(equalToConstant: 170).isActive = true
        view.heightAnchor.constraint(equalToConstant: 36).isActive = true
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapRandomNickname)))
        return view
    }()
    
    var bottomConstraint: NSLayoutConstraint?
    
    init(viewModel: NicknameViewModel) {
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

private extension NicknameViewController {
    
    func setUp() {
        configure()
        hideKeyboard()
        addNotification()
        bind()
    }
    
    func bind() {
        viewModel.state.receive(on: DispatchQueue.main)
            .sink { [weak self] state in
                switch state {
                case .changeNextButtonState(let isEnabled):
                    self?.nextButton.setStyle(isEnabled ? .enabled : .disabled)
                    
                case .isEnabledNickname(let isEnabled, let message):
                    print(isEnabled, message)
                    self?.ciderTextFieldView.setErrorMessage(message: message, isEnabled: isEnabled)
                    
                case .getRandomNickname(let nickname):
                    self?.ciderTextFieldView.ciderTextField.text = nickname
                    self?.ciderTextFieldView.ciderTextField.setStyle(.enabled)
                    self?.ciderTextFieldView.isHiddenErrorMessage(true)
                    self?.ciderTextFieldView.setTextCount(nickname.count)
                }
            }
            .store(in: &cancellables)
    }
    
    func configure() {
        view.backgroundColor = .white
        processView.setProcessType(.dataInput)
        
        view.addSubviews(processView, mainTitleLabel, subTitleLabel, nextButton, randomNicknameView, ciderTextFieldView)
        NSLayoutConstraint.activate([
            processView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            processView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            processView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            mainTitleLabel.topAnchor.constraint(equalTo: processView.bottomAnchor, constant: 24),
            mainTitleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            subTitleLabel.topAnchor.constraint(equalTo: mainTitleLabel.bottomAnchor, constant: 8),
            subTitleLabel.leadingAnchor.constraint(equalTo: mainTitleLabel.leadingAnchor),
            ciderTextFieldView.topAnchor.constraint(equalTo: subTitleLabel.bottomAnchor, constant: 40),
            ciderTextFieldView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            ciderTextFieldView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            ciderTextFieldView.heightAnchor.constraint(equalToConstant: 65),
            nextButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            nextButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            nextButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            randomNicknameView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            randomNicknameView.bottomAnchor.constraint(equalTo: nextButton.topAnchor, constant: -12)
        ])
        
        bottomConstraint = NSLayoutConstraint(item: nextButton, attribute: .bottom, relatedBy: .equal, toItem: view.safeAreaLayoutGuide, attribute: .bottom, multiplier: 1.0, constant: 0)
        bottomConstraint?.isActive = true
    }
    
    func setNavigationBar() {
        self.navigationController?.navigationBar.topItem?.title = ""
        self.navigationItem.title = "회원가입"
    }
    
    func addNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
}

private extension NicknameViewController {
    
    @objc func didTapNext(_ sender: UIButton) {
        Onboarding.shared.memberName = ciderTextFieldView.ciderTextField.text
        let viewController = GenderAndBirthdayViewController()
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
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
    
    @objc func didTapRandomNickname(_ sender: Any?) {
        viewModel.didTapRandomNickname()
    }
    
    @objc func isAvailableNickname(_ sender: Any?) {
        guard let text = ciderTextFieldView.ciderTextField.text else {
            return
        }
        if text.count >= 2 {
            viewModel.endEditingNickname(text)
        } else {
            nextButton.setStyle(.disabled)
        }
    }
    
    @objc func didTapClear(_ sender: Any?) {
        nextButton.setStyle(.disabled)
    }
    
}

#if DEBUG
import SwiftUI

@available(iOS 13.0, *)
struct NicknameViewController_Preview: PreviewProvider {
    static var devices = ["iPhone 12", "iPhone SE", "iPhone 11 Pro Max"]
    
    static var previews: some View {
        ForEach(devices, id: \.self) { deviceName in
            NicknameViewController(
                viewModel: NicknameViewModel(
                    useCase: DefaultNicknameUsecase(
                        repository: DefaultNicknameRepository()
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

