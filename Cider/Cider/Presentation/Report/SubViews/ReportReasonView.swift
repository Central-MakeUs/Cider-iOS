//
//  ReportReasonView.swift
//  Cider
//
//  Created by 임영선 on 2023/08/18.
//

import UIKit

final class ReportReasonView: UIView {
    
    let reason: String
   
    private lazy var reasonLabel: UILabel = {
        let label = UILabel()
        label.font = CustomFont.PretendardBold(size: .base).font
        label.textColor = .custom.text
        label.text = reason
        return label
    }()
    
    private lazy var checkboxButton: UIButton = {
        let button = UIButton()
        button.heightAnchor.constraint(equalToConstant: 18).isActive = true
        button.widthAnchor.constraint(equalToConstant: 18).isActive = true
        return button
    }()
    
    private lazy var underBarView: UIView = {
        let view = UIView()
        view.backgroundColor = .custom.underBar
        view.heightAnchor.constraint(equalToConstant: 2).isActive = true
        return view
    }()
    
    
    init(reason: String, style: CiderSelectionStyle) {
        self.reason = reason
        super.init(frame: .zero)
        setStyle(style)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        addSubviews(reasonLabel, checkboxButton, underBarView)
        NSLayoutConstraint.activate([
            reasonLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            reasonLabel.leadingAnchor.constraint(equalTo: checkboxButton.trailingAnchor, constant: 7),
            checkboxButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 3),
            checkboxButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            underBarView.leadingAnchor.constraint(equalTo: leadingAnchor),
            underBarView.trailingAnchor.constraint(equalTo: trailingAnchor),
            underBarView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
}

extension ReportReasonView {
    
    func setUnderbarHidden() {
        underBarView.isHidden = true
    }
    
    func setStyle(_ style: CiderSelectionStyle) {
        switch style {
        case .selected:
            checkboxButton.setImage(UIImage(named: "radioSelected"), for: .normal)
            reasonLabel.textColor = .custom.text

        case .unselected:
            checkboxButton.setImage(UIImage(named: "radioUnselected"), for: .normal)
            reasonLabel.textColor = .custom.text
        }
    }
    
}
