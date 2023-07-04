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
    
    private lazy var birthdayTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "생년월일"
        label.font = CustomFont.PretendardBold(size: .xl).font
        label.textColor = .custom.text
        return label
    }()
    
    private let genderStackView = UIStackView(axis: .horizontal, alignment: .fill, distribution: .fillEqually, spacing: 8)

    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        // Do any additional setup after loading the view.
    }
    


}

private extension BirthdayViewController {
    
    func configure() {
        processView.setProcessType(.dataInput)
        view.addSubviews(processView, mainTitleLabel, generTitleLabel, generSubLabel, genderStackView)
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
            genderStackView.heightAnchor.constraint(equalToConstant: 36)
            
        ])
        
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

