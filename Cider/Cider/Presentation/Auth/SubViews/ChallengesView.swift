//
//  ChallengeView.swift
//  Cider
//
//  Created by 임영선 on 2023/07/07.
//

import UIKit

final class ChallengesView: UIView {
    
    private lazy var mainTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "관심있는 챌린지"
        label.font = CustomFont.PretendardBold(size: .xl).font
        label.textColor = .custom.text
        return label
    }()
    
    private lazy var subTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "최소 2개 선택"
        label.font = CustomFont.PretendardRegular(size: .base).font
        label.textColor = .custom.icon
        return label
    }()
    
    let financialTechView = ChallengeView(style: .unselected, type: .financialTech)
    let financialLearningView = ChallengeView(style: .unselected, type: .financialLearning)
    let moneySavingView = ChallengeView(style: .unselected, type: .moneySaving)
    let moneyManagementView = ChallengeView(style: .unselected, type: .moneyManagement)
    
    private let stackView1 = UIStackView(axis: .horizontal, alignment: .center, distribution: .fillEqually, spacing: 12)
    private let stackView2 = UIStackView(axis: .horizontal, alignment: .center, distribution: .fillEqually, spacing: 12)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        addSubviews(mainTitleLabel, subTitleLabel, stackView1, stackView2)
        stackView1.addArrangedSubviews(financialTechView, moneySavingView)
        stackView2.addArrangedSubviews(moneyManagementView, financialLearningView)
        NSLayoutConstraint.activate([
            mainTitleLabel.topAnchor.constraint(equalTo: topAnchor),
            mainTitleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            subTitleLabel.topAnchor.constraint(equalTo: topAnchor),
            subTitleLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView1.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView1.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView1.topAnchor.constraint(equalTo: mainTitleLabel.bottomAnchor, constant: 25),
            stackView2.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView2.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView2.topAnchor.constraint(equalTo: stackView1.bottomAnchor, constant: 12)
        ])
    }
    
    
}


final class ChallengeView: UIView {
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = type.getKoreanName()
        return label
    }()
    
    private lazy var challengeImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: type.getUnselectedName())
        imageView.heightAnchor.constraint(equalToConstant: 36).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 36).isActive = true
        return imageView
    }()
    
    var type: ChallengeType = .financialLearning
    
    private lazy var gradientView: GradientView = {
        let view = GradientView(type: type)
        view.layer.cornerRadius = 4
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    init(style: SelectionStyle, type: ChallengeType) {
        super.init(frame: .zero)
        self.type = type
        configure()
        setStyle(style)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        layer.cornerRadius = 4
        layer.borderWidth = 1
        addSubviews(gradientView, challengeImageView, titleLabel)
        
        NSLayoutConstraint.activate([
            heightAnchor.constraint(equalToConstant: 64),
            gradientView.leadingAnchor.constraint(equalTo: leadingAnchor),
            gradientView.trailingAnchor.constraint(equalTo: trailingAnchor),
            gradientView.topAnchor.constraint(equalTo: topAnchor),
            gradientView.bottomAnchor.constraint(equalTo: bottomAnchor),
            challengeImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            challengeImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 35),
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: challengeImageView.trailingAnchor, constant: 8)
        ])
    }
    
    func setStyle(_ style: SelectionStyle) {
        titleLabel.textColor = style == .unselected ? .custom.gray4 : .white
        titleLabel.font = style == .unselected ? CustomFont.PretendardRegular(size: .lg).font : CustomFont.PretendardBold(size: .lg).font
        challengeImageView.image = UIImage(named: style == .unselected ? type.getUnselectedName() : type.getSelectedName())
        layer.borderColor = style == .unselected ? UIColor.custom.gray2?.cgColor : UIColor.clear.cgColor
        backgroundColor = style == .unselected ? .custom.gray1 : .clear
        gradientView.isHidden = style == .unselected ? true : false
    }
    
    func addTapGesture(_ target: Any?, action: Selector) {
        self.addGestureRecognizer(UITapGestureRecognizer(target: target, action: action))
    }
    
}
