//
//  challengeSelectionView.swift
//  Cider
//
//  Created by 임영선 on 2023/07/12.
//

import UIKit


final class ChallengeOpenSelectionView: UIView {
    
    private let type: ChallengeOpenSelectionType
    
    private lazy var mainTitleLabel = StarTitleLabel(title: type.mainTitle)
    
    private lazy var subTitleLabel: UILabel = {
        let label = UILabel()
        label.text = type.subTitle
        label.font = CustomFont.PretendardBold(size: .base).font
        label.textColor = .custom.icon
        return label
    }()
    
    private lazy var paddingView = {
        let view = UIView()
        view.isUserInteractionEnabled = false
        return view
    }()
    
    private lazy var iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: type.iconName)
        imageView.heightAnchor.constraint(equalToConstant: 24).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 24).isActive = true
        return imageView
    }()
    
    private lazy var textField: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = .white
        textField.text = String(type.defaultUnit) + type.unitString
        textField.font = CustomFont.PretendardRegular(size: .base).font
        textField.heightAnchor.constraint(equalToConstant: 44).isActive = true
        textField.addLeftPadding(12)
        textField.layer.cornerRadius = 4
        textField.layer.borderWidth = 0.5
        textField.layer.borderColor = UIColor.custom.gray2?.cgColor
        textField.textColor = .custom.text
        textField.tintColor = .clear
        textField.inputView = customPickerView
        textField.isUserInteractionEnabled = true
        return textField
    }()
    
    private lazy var customPickerView: UIPickerView = {
        let pickerView = UIPickerView()
        pickerView.delegate = self
        pickerView.dataSource = self
        return pickerView
    }()
    
    private lazy var selectedPickerViewData = String(type.defaultUnit) + type.unitString
    
    init(type: ChallengeOpenSelectionType) {
        self.type = type
        super.init(frame: .zero)
        setUp()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

private extension ChallengeOpenSelectionView {
    
    func setUp() {
        configure()
        setPickerToolbar()
    }
    
    func configure() {
        addSubviews(mainTitleLabel, subTitleLabel, textField, paddingView)
        paddingView.addSubviews(iconImageView)
        
        NSLayoutConstraint.activate([
            self.heightAnchor.constraint(equalToConstant: 77),
            mainTitleLabel.topAnchor.constraint(equalTo: topAnchor),
            mainTitleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            subTitleLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            subTitleLabel.topAnchor.constraint(equalTo: topAnchor),
            textField.topAnchor.constraint(equalTo: mainTitleLabel.bottomAnchor, constant: 8),
            textField.leadingAnchor.constraint(equalTo: leadingAnchor),
            textField.trailingAnchor.constraint(equalTo: trailingAnchor),
            paddingView.widthAnchor.constraint(equalToConstant: 12+24),
            paddingView.heightAnchor.constraint(equalToConstant: 24)
        ])
        textField.rightView = paddingView
        textField.rightViewMode = .always
    }
    
    func setPickerToolbar() {
        let toolbar = UIToolbar()
        toolbar.barTintColor = .white
        toolbar.sizeToFit()
        let cancelButton =  UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(didTapCancel))
        let doneButton =  UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(didTapDone))
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolbar.setItems([cancelButton, space, doneButton], animated: true)
        textField.inputAccessoryView = toolbar
    }
    
    @objc func didTapDone(_ sender: UIBarButtonItem) {
        textField.resignFirstResponder()
        textField.text = selectedPickerViewData
    }
    
    @objc func didTapCancel(_ sender: UIBarButtonItem) {
        textField.resignFirstResponder()
    }
    
}

extension ChallengeOpenSelectionView: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return type.unitList.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return String(type.unitList[row]) + type.unitString
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedPickerViewData = String(type.unitList[row]) + type.unitString
    }
    
}
