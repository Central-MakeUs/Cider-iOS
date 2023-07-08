//
//  KeywordsView.swift
//  Cider
//
//  Created by 임영선 on 2023/07/07.
//

import UIKit

final class KeywordsView: UIView {
    
    private lazy var mainTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "관심 키워드"
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
    
    let jjanTechView = KeywordView(style: .unselected, title: "짠테크")
    let policyView = KeywordView(style: .unselected, title: "청년정책")
    let appTechView = KeywordView(style: .unselected, title: "앱테크")
    let consumptionView = KeywordView(style: .unselected, title: "소비생활")
    let savingView = KeywordView(style: .unselected, title: "적금")
    
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
        stackView1.addArrangedSubviews(jjanTechView, appTechView, policyView)
        stackView2.addArrangedSubviews(consumptionView, savingView)
        NSLayoutConstraint.activate([
            mainTitleLabel.topAnchor.constraint(equalTo: topAnchor),
            mainTitleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            subTitleLabel.topAnchor.constraint(equalTo: topAnchor),
            subTitleLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView1.topAnchor.constraint(equalTo: mainTitleLabel.bottomAnchor, constant: 24),
            stackView1.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 28.5),
            stackView1.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -28.5),
            stackView2.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 28.5),
            stackView2.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -28.5),
            stackView2.topAnchor.constraint(equalTo: stackView1.bottomAnchor, constant: 16)
            
        ])
    }
    
}

final class KeywordView: UIView {
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = CustomFont.PretendardBold(size: .xl).font
        return label
    }()
    
    private lazy var tagImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.heightAnchor.constraint(equalToConstant: 16).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 16).isActive = true
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    init(style: CiderSelectionStyle, title: String) {
        super.init(frame: .zero)
        titleLabel.text = title
        configure()
        setStyle(style)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        layer.cornerRadius = 4
        layer.borderWidth = 1
        addSubviews(titleLabel, tagImageView)
        NSLayoutConstraint.activate([
            heightAnchor.constraint(equalToConstant: 32),
            tagImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            tagImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: tagImageView.trailingAnchor, constant: 8)
        ])
    }
    
    func setStyle(_ style: CiderSelectionStyle) {
        titleLabel.textColor = style == .selected ? .white : .custom.gray4
        backgroundColor = style == .selected ? .custom.gray6 : .custom.gray1
        layer.borderColor = style == .selected ?  UIColor.clear.cgColor : UIColor.custom.gray2?.cgColor
        tagImageView.image = UIImage(named: style == .selected ? "tagSelected" : "tagUnselected")
    }
    
}
