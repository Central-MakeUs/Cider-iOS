//
//  SettingView.swift
//  Cider
//
//  Created by 임영선 on 2023/08/18.
//

import UIKit

final class SettingView: UIView {
    
    private let title: String
    private let rightTitle: String?
    private let isHiddenArrowRight: Bool
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = CustomFont.PretendardBold(size: .xl2).font
        label.textColor = .custom.text
        label.text = title
        return label
    }()
    
    private lazy var rightLabel: UILabel = {
        let label = UILabel()
        label.font = CustomFont.PretendardRegular(size: .lg).font
        label.textColor = .custom.icon
        label.text = rightTitle
        return label
    }()
    
    private lazy var arrowRightButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "line_arrow-right_24"), for: .normal)
        button.isHidden = isHiddenArrowRight
        return button
    }()
    
    init(title: String, rightTitle: String, isHiddenArrowRight: Bool) {
        self.title = title
        self.rightTitle = rightTitle
        self.isHiddenArrowRight = isHiddenArrowRight
        super.init(frame: .zero)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        self.backgroundColor = .white
        addSubviews(titleLabel, rightLabel, arrowRightButton)
        NSLayoutConstraint.activate([
            self.heightAnchor.constraint(equalToConstant: 48),
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24),
            rightLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            rightLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24),
            arrowRightButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            arrowRightButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24),
            arrowRightButton.widthAnchor.constraint(equalToConstant: 24),
            arrowRightButton.heightAnchor.constraint(equalToConstant: 24)
        ])
    }
    
}
