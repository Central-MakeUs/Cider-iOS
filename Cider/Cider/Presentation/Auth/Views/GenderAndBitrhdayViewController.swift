//
//  BirthdayViewController.swift
//  Cider
//
//  Created by 임영선 on 2023/07/04.
//

import UIKit
import Combine

final class GenderAndBitrhdayViewController: UIViewController {
    
    private let viewModel = GenderAndBitrhdayViewModel()
    private var cancellables = Set<AnyCancellable>()
    
    private let processView = ProcessView()
    
    private lazy var mainTitleLabel: UILabel = {
        let label = UILabel()
        label.font = CustomFont.PretendardBold(size: .xl5).font
        label.text = "성별과 생년월일을\n입력해주세요"
        label.textColor = .custom.text
        label.setTextWithLineHeight(lineHeight: 39.2)
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var generTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "성별"
        label.font = CustomFont.PretendardBold(size: .xl).font
        label.textColor = .custom.text
        return label
    }()
    
    private lazy var generSubLabel: UILabel = {
        let label = UILabel()
        label.text = "본인의 성별을 반드시 1개 선택해주세요"
        label.font = CustomFont.PretendardRegular(size: .base).font
        label.textColor = .custom.icon
        return label
    }()
    
    private lazy var maleButton: UIButton = {
        let button = UIButton()
        button.setTitle("남성", for: .normal)
        button.setTitleColor(.custom.text, for: .normal)
        button.tintColor = .custom.text
        button.titleLabel?.font = CustomFont.PretendardRegular(size: .xl).font
        button.layer.borderColor = UIColor.custom.gray3?.cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 4
        button.addTarget(self, action: #selector(didTapMale), for: .touchUpInside)
        return button
    }()
    
    private lazy var femaleButton: UIButton = {
        let button = UIButton()
        button.setTitle("여성", for: .normal)
        button.setTitleColor(.custom.text, for: .normal)
        button.titleLabel?.font = CustomFont.PretendardRegular(size: .xl).font
        button.layer.borderColor = UIColor.custom.gray3?.cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 4
        button.addTarget(self, action: #selector(didTapFemale), for: .touchUpInside)
        return button
    }()
    
    private lazy var barView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.custom.gray1
        view.heightAnchor.constraint(equalToConstant: 2).isActive = true
        return view
    }()
    
    private lazy var birthdayTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "생년월일"
        label.font = CustomFont.PretendardBold(size: .xl).font
        label.textColor = .custom.text
        return label
    }()
    
    private lazy var birthdayTextField: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = .custom.gray1
        textField.placeholder = "0000년 00월 00일"
        textField.font = CustomFont.PretendardBold(size: .base).font
        textField.textColor = .custom.text
        textField.heightAnchor.constraint(equalToConstant: 44).isActive = true
        textField.addLeftPadding(12)
        textField.layer.cornerRadius = 4
        textField.layer.borderWidth = 2
        textField.layer.borderColor = UIColor.clear.cgColor
        textField.inputView = birthdatDatePicker
        textField.heightAnchor.constraint(equalToConstant: 44).isActive = true
        textField.setPlaceholderColor(.custom.gray4 ?? .gray)
        textField.rightView = textFieldPaddingView
        textField.rightViewMode = .always
        return textField
    }()
    
    private lazy var birthdatDatePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.datePickerMode = .date
        datePicker.locale = Locale(identifier: "ko_KR")
        return datePicker
    }()
    
    private lazy var errorLabel: UILabel = {
        let label = UILabel()
        label.text = "14세 이상으로 선택해주세요"
        label.textColor = .custom.error
        label.font = CustomFont.PretendardRegular(size: .lg).font
        label.isHidden = true
        return label
    }()
    
    private let textFieldPaddingView = UIView()
    
    private lazy var calendarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "clearButton")
        return imageView
    }()
    
    private lazy var nextButton: CiderBottomButton = {
        let button = CiderBottomButton(style: .disabled, title: "다음")
        button.addTarget(self, action: #selector(didTapNext), for: .touchUpInside)
        return button
    }()
    
    private let genderStackView = UIStackView(axis: .horizontal, alignment: .fill, distribution: .fillEqually, spacing: 8)

    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        bind()
        setDatePickerToolbar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNavigationBar()
    }

}

private extension GenderAndBitrhdayViewController {
    
    func configure() {
        view.backgroundColor = .white
        processView.setProcessType(.dataInput)
        view.addSubviews(processView, mainTitleLabel, generTitleLabel, generSubLabel, genderStackView, barView,
                         birthdayTitleLabel, birthdayTextField, nextButton, errorLabel, textFieldPaddingView)
        textFieldPaddingView.addSubviews(calendarImageView)
        genderStackView.addArrangedSubviews(maleButton, femaleButton)
        NSLayoutConstraint.activate([
            textFieldPaddingView.widthAnchor.constraint(equalToConstant: 12+24),
            textFieldPaddingView.heightAnchor.constraint(equalToConstant: 24),
            processView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            processView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            processView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            mainTitleLabel.topAnchor.constraint(equalTo: processView.bottomAnchor, constant: 24),
            mainTitleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            generTitleLabel.topAnchor.constraint(equalTo: mainTitleLabel.bottomAnchor, constant: 45),
            generTitleLabel.leadingAnchor.constraint(equalTo: mainTitleLabel.leadingAnchor),
            generSubLabel.centerYAnchor.constraint(equalTo: generTitleLabel.centerYAnchor),
            generSubLabel.leadingAnchor.constraint(equalTo: generTitleLabel.trailingAnchor, constant: 8),
            genderStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            genderStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            genderStackView.topAnchor.constraint(equalTo: generTitleLabel.bottomAnchor, constant: 21),
            genderStackView.heightAnchor.constraint(equalToConstant: 36),
            barView.topAnchor.constraint(equalTo: genderStackView.bottomAnchor, constant: 31),
            barView.leadingAnchor.constraint(equalTo: genderStackView.leadingAnchor),
            barView.trailingAnchor.constraint(equalTo: genderStackView.trailingAnchor),
            birthdayTitleLabel.topAnchor.constraint(equalTo: barView.bottomAnchor, constant: 12),
            birthdayTitleLabel.leadingAnchor.constraint(equalTo: mainTitleLabel.leadingAnchor),
            birthdayTextField.topAnchor.constraint(equalTo: birthdayTitleLabel.bottomAnchor, constant: 20),
            birthdayTextField.leadingAnchor.constraint(equalTo: mainTitleLabel.leadingAnchor),
            birthdayTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            errorLabel.topAnchor.constraint(equalTo: birthdayTextField.bottomAnchor, constant: 8),
            errorLabel.leadingAnchor.constraint(equalTo: mainTitleLabel.leadingAnchor),
            nextButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            nextButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            nextButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20)
            
        ])
        
    }
    
    func bind() {
        viewModel.state.receive(on: DispatchQueue.main)
            .sink { [weak self] state in
                switch state {
                case .changeNextButtonState(let isEnabled):
                    self?.nextButton.setStyle(isEnabled == true ? .enabled : .disabled)
                case .checkAge(let isEnabled):
                    self?.birthdayTextField.layer.borderColor = isEnabled ? UIColor.clear.cgColor : UIColor.custom.error?.cgColor
                    self?.errorLabel.isHidden = isEnabled
                case .selectBitrhday(let birthday):
                    self?.birthdayTextField.text = birthday
                }
            }
            .store(in: &cancellables)
        
        viewModel.$femaleButtonIsPressed.receive(on: DispatchQueue.main)
            .sink { [weak self] isPressed in
                self?.femaleButton.backgroundColor = isPressed ? .custom.main : .white
                self?.femaleButton.setTitleColor(isPressed ? .white : .custom.text, for: .normal)
            }
            .store(in: &cancellables)
        
        viewModel.$maleButtonIsPressed.receive(on: DispatchQueue.main)
            .sink { [weak self] isPressed in
                self?.maleButton.backgroundColor = isPressed ? .custom.main : .white
                self?.maleButton.setTitleColor(isPressed ? .white : .custom.text, for: .normal)
            }
            .store(in: &cancellables)
    }
    
    func setDatePickerToolbar() {
        let toolbar = UIToolbar()
        toolbar.barTintColor = .white
        toolbar.sizeToFit()
        let cancelButton =  UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(didTapCancel))
        let doneButton =  UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(didTapDone))
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolbar.setItems([cancelButton, space, doneButton], animated: true)
        birthdayTextField.inputAccessoryView = toolbar
    }
    
    func setNavigationBar() {
        self.navigationController?.navigationBar.topItem?.title = ""
        self.navigationItem.title = "회원가입"
    }
    
}

private extension GenderAndBitrhdayViewController {
    
    @objc func didTapDone(_ sender: UIBarButtonItem) {
        birthdayTextField.resignFirstResponder()
        viewModel.selectBirthday(date: birthdatDatePicker.date)
    }
    
    @objc func didTapCancel(_ sender: UIBarButtonItem) {
        birthdayTextField.resignFirstResponder()
    }
    
    @objc func didTapMale(_ sender: Any?) {
        viewModel.didTapMaleButton()
    }
    
    @objc func didTapFemale(_ sender: Any?) {
        viewModel.didTapFemaleButton()
    }
    
    @objc func didTapNext(_ sender: Any?) {
        let viewController = ChallengeSelectionViewController()
        navigationController?.pushViewController(viewController, animated: true)
    }
    
}


#if DEBUG
import SwiftUI

@available(iOS 13.0, *)
struct BirthdayViewController_Preview: PreviewProvider {
    static var devices = ["iPhone 12", "iPhone SE", "iPhone 11 Pro Max"]

    static var previews: some View {
        ForEach(devices, id: \.self) { deviceName in
            GenderAndBitrhdayViewController()
                .toPreview()
                .previewDevice(PreviewDevice(rawValue: deviceName))
                .previewDisplayName(deviceName)
        }
    }
}
#endif

