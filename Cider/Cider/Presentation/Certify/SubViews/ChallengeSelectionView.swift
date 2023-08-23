//
//  ChallengeSelectionView.swift
//  Cider
//
//  Created by 임영선 on 2023/08/10.
//

import UIKit
import Combine

final class ChallengeSelectionView: UIView {
   
    private lazy var paddingView = {
        let view = UIView()
        view.isUserInteractionEnabled = false
        return view
    }()
    
    private lazy var iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "line_arrow-down_24")
        imageView.heightAnchor.constraint(equalToConstant: 24).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 24).isActive = true
        return imageView
    }()
    
    private lazy var textField: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = .white
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
    
    var selectedPickerViewData = ""
    var challengeList: [String] = []
    var selectedIndex = 0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func indexPublisher() -> AnyPublisher<Int, Never> {
        var unitPublisher: AnyPublisher<Int, Never> {
            NotificationCenter.default.publisher(
                for: .selectParticipateChallenge,
                object: nil
            )
            .compactMap { $0.object as? Int }
            .eraseToAnyPublisher()
        }
        return unitPublisher
    }
    
    func setTextFieltText(_ text: String) {
        textField.text = text
    }
    
}

private extension ChallengeSelectionView {
    
    func setUp() {
        configure()
        setPickerToolbar()
    }
    
    func configure() {
        addSubviews(textField, paddingView)
        paddingView.addSubviews(iconImageView)
        
        NSLayoutConstraint.activate([
            self.heightAnchor.constraint(equalToConstant: 44),
            textField.topAnchor.constraint(equalTo: topAnchor),
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
        textField.text = String(selectedPickerViewData)
        NotificationCenter.default.post(name: .selectParticipateChallenge, object: selectedIndex)
    }
    
    @objc func didTapCancel(_ sender: UIBarButtonItem) {
        textField.resignFirstResponder()
    }
    
}

extension ChallengeSelectionView: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return challengeList.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return challengeList[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedPickerViewData = challengeList[row]
        selectedIndex = row
    }
    
}
