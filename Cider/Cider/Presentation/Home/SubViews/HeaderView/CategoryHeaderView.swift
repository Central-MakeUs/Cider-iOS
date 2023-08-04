//
//  HomeHeaderView.swift
//  Cider
//
//  Created by 임영선 on 2023/07/21.
//

import UIKit

class CategoryHeaderView: UICollectionReusableView {
    
    static let identifier = "CategoryHeaderView"
    
    private lazy var leftTitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .custom.text
        label.font = CustomFont.PretendardBold(size: .xl2).font
        return label
    }()
    
    private lazy var rightTitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .custom.gray5
        label.font = CustomFont.PretendardBold(size: .lg).font
        return label
    }()
    
    private lazy var rightChevronImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "line_arrow-right_24")
        return imageView
    }()
    
    private lazy var allChallnegeStackView: UIStackView = {
        let stackView = UIStackView(axis: .horizontal, alignment: .fill, distribution: .fill, spacing: 4)
        stackView.addArrangedSubviews(rightTitleLabel, rightChevronImageView)
        return stackView
    }()
    
    lazy var financialTechView: CategoryView = {
        let view = CategoryView(type: .financialTech, style: .selected)
        return view
    }()
    
    lazy var moneyManagementView: CategoryView = {
        let view = CategoryView(type: .moneyManagement, style: .selected)
        return view
    }()
    
    lazy var financialLearningView: CategoryView = {
        let view = CategoryView(type: .financialLearning, style: .selected)
        return view
    }()
    
    lazy var moneySavingView: CategoryView = {
        let view = CategoryView(type: .moneySaving, style: .selected)
        return view
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        stackView.alignment = .center
        stackView.addArrangedSubviews(financialTechView, moneyManagementView, financialLearningView, moneySavingView)
        return stackView
    }()
    
    private lazy var backgroundView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 4
        return view
    }()
    
    private lazy var infoLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = CustomFont.PretendardBold(size: .base).font
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        addSubviews(leftTitleLabel, allChallnegeStackView, stackView, backgroundView, infoLabel)
        NSLayoutConstraint.activate([
            leftTitleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 12),
            leftTitleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24),
            allChallnegeStackView.topAnchor.constraint(equalTo: topAnchor, constant: 12),
            allChallnegeStackView.heightAnchor.constraint(equalToConstant: 16),
            allChallnegeStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24),
            rightChevronImageView.widthAnchor.constraint(equalToConstant: 16),
            stackView.topAnchor.constraint(equalTo: leftTitleLabel.bottomAnchor, constant: 12),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24),
            backgroundView.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 10),
            backgroundView.leadingAnchor.constraint(equalTo: stackView.leadingAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: stackView.trailingAnchor),
            backgroundView.heightAnchor.constraint(equalToConstant: 34),
            infoLabel.centerXAnchor.constraint(equalTo: backgroundView.centerXAnchor),
            infoLabel.centerYAnchor.constraint(equalTo: backgroundView.centerYAnchor)
        ])
    }
    
    private func selectChallengeType(_ type: ChallengeType) {
        backgroundView.backgroundColor = type.color
        infoLabel.text = type.infoMessage
        financialTechView.setStyle(type == .financialTech ? .selected : .unselected)
        moneyManagementView.setStyle(type == .moneyManagement ? .selected : .unselected)
        moneySavingView.setStyle(type == .moneySaving ? .selected : .unselected)
        financialLearningView.setStyle(type == .financialLearning ? .selected : .unselected)
    }
    
}

extension CategoryHeaderView {
    
    func setUp(leftTitle: String, rightTitle: String, selectedType: ChallengeType) {
        leftTitleLabel.text = leftTitle
        rightTitleLabel.text = rightTitle
        selectChallengeType(selectedType)
    }
    
    func addActionRightTitle(_ target: Any?, action: Selector) {
        allChallnegeStackView.addGestureRecognizer(UITapGestureRecognizer(target: target, action: action))
    }
    
}

#if DEBUG
import SwiftUI

@available(iOS 13.0, *)
struct CategoryHeaderView_Preview: PreviewProvider {
    static var previews: some View {
        
        UIViewPreview {
            let view = CategoryHeaderView()
            view.setUp(leftTitle: "카테고리", rightTitle: "전체 챌린지 보기", selectedType: .financialLearning)
            return view
        }
        .previewLayout(.fixed(width: 150, height: 192))
       // .padding(100)
    }
}
#endif
