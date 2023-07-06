//
//  BirthdayViewController.swift
//  Cider
//
//  Created by 임영선 on 2023/07/04.
//

import UIKit

class BirthdayViewController: UIViewController {
    
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
        textField.heightAnchor.constraint(equalToConstant: 44).isActive = true
        textField.addLeftPadding()
        textField.layer.cornerRadius = 4
        textField.layer.borderWidth = 2
        textField.layer.borderColor = UIColor.clear.cgColor
        textField.inputView = birthdatDatePicker
        return textField
    }()
    
    private lazy var birthdatDatePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.datePickerMode = .date
        datePicker.backgroundColor = .white
        return datePicker
    }()
    
    private lazy var nextButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .custom.gray4
        button.setTitle("다음", for: .normal)
        button.titleLabel?.font = CustomFont.PretendardBold(size: .xl2).font
        button.setTitleColor(UIColor.white, for: .normal)
        button.heightAnchor.constraint(equalToConstant: 48).isActive = true
        button.layer.cornerRadius = 4
        return button
    }()
    
    private let genderStackView = UIStackView(axis: .horizontal, alignment: .fill, distribution: .fillEqually, spacing: 8)

    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        setDatePickerToolbar()
    }
    


}

private extension BirthdayViewController {
    
    func configure() {
        view.backgroundColor = .white
        processView.setProcessType(.dataInput)
        view.addSubviews(processView, mainTitleLabel, generTitleLabel, generSubLabel, genderStackView, barView, birthdayTitleLabel, birthdayTextField, nextButton)
        genderStackView.addArrangedSubviews(maleButton, femaleButton)
        NSLayoutConstraint.activate([
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
            nextButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            nextButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            nextButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20)
            
        ])
        
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
    
}

private extension BirthdayViewController {
    
    @objc func didTapDone(_ sender: UIBarButtonItem) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy년 MM월 dd일"
        birthdayTextField.text = formatter.string(from: birthdatDatePicker.date)
        birthdayTextField.resignFirstResponder()
    }
    
    @objc func didTapCancel(_ sender: UIBarButtonItem) {
        birthdayTextField.resignFirstResponder()
    }
    
}


#if DEBUG
import SwiftUI

@available(iOS 13.0, *)
struct BirthdayViewController_Preview: PreviewProvider {
    static var devices = ["iPhone 12", "iPhone SE", "iPhone 11 Pro Max"]

    static var previews: some View {
        ForEach(devices, id: \.self) { deviceName in
            BirthdayViewController()
                .toPreview()
                .previewDevice(PreviewDevice(rawValue: deviceName))
                .previewDisplayName(deviceName)
        }
    }
}
#endif

