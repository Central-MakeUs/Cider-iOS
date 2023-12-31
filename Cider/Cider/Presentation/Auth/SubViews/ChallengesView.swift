//
//  ChallengeView.swift
//  Cider
//
//  Created by 임영선 on 2023/07/07.
//

import UIKit

final class ChallengesView: UIStackView {
    
    let financialTechView = ChallengeView(style: .selected, type: .financialTech)
    let financialLearningView = ChallengeView(style: .selected, type: .financialLearning)
    let moneySavingView = ChallengeView(style: .selected, type: .moneySaving)
    let moneyManagementView = ChallengeView(style: .selected, type: .moneyManagement)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
        setStackView()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        addArrangedSubviews(financialTechView, moneyManagementView, financialLearningView, moneySavingView)
    }
    
    private func setStackView() {
        axis = .vertical
        distribution = .fillEqually
        spacing = 16
    }
    
    
}

final class ChallengeView: UIView {
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = type.koreanName
        label.font = CustomFont.PretendardBold(size: .xl2).font
        return label
    }()
    
    private lazy var challengeImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: type.unselectedName)
        imageView.heightAnchor.constraint(equalToConstant: 36).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 36).isActive = true
        return imageView
    }()
    
    private let stackView = UIStackView(axis: .horizontal, alignment: .center, distribution: .fill, spacing: 8)
    
    var type: ChallengeType
    
    init(style: CiderSelectionStyle, type: ChallengeType) {
        self.type = type
        super.init(frame: .zero)
        configure()
        setStyle(style)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        layer.cornerRadius = 4
        layer.borderWidth = 1
        addSubviews(stackView)
        stackView.addArrangedSubviews(challengeImageView, titleLabel)
        NSLayoutConstraint.activate([
            heightAnchor.constraint(equalToConstant: 64),
            stackView.centerYAnchor.constraint(equalTo: centerYAnchor),
            stackView.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
    }
    
    func setStyle(_ style: CiderSelectionStyle) {
        titleLabel.textColor = style == .unselected ? .custom.gray4 : .white
        challengeImageView.image = UIImage(named: style == .unselected ? type.unselectedName : type.selectedName)
        layer.borderColor = style == .unselected ? UIColor.custom.gray2?.cgColor : UIColor.clear.cgColor
        backgroundColor = style == .unselected ? .custom.gray1 : type.color
    }
    
    func addTapGesture(_ target: Any?, action: Selector) {
        self.addGestureRecognizer(UITapGestureRecognizer(target: target, action: action))
    }
    
}
