//
//  ChallengeEmptyCell.swift
//  Cider
//
//  Created by 임영선 on 2023/08/18.
//

import UIKit

final class ChallengeEmptyCell: UICollectionViewCell {
    
    static let identifier = "ChallengeEmptyCell"
    
    private lazy var mainTitleLabel: UILabel = {
        let label = UILabel()
        label.font = CustomFont.PretendardBold(size: .xl2).font
        label.textColor = .custom.text
        label.text = "아직 챌린지가 없습니다"
        label.textAlignment = .center
        return label
    }()
    
    private lazy var subTitleLabel: UILabel = {
        let label = UILabel()
        label.font = CustomFont.PretendardRegular(size: .base).font
        label.textColor = .custom.emptySub
        label.text = "함께 인증하는 금융 챌린지를\n직접 만들어보세요"
        label.setTextWithLineHeight(lineHeight: 18.2)
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    lazy var challengeOpenButton: UIButton = {
        let button = UIButton()
        button.heightAnchor.constraint(equalToConstant: 44).isActive = true
        button.widthAnchor.constraint(equalToConstant: 123).isActive = true
        button.backgroundColor = .custom.main
        button.layer.cornerRadius = 4
        button.setImage(UIImage(named: "line_arrow-right_16")?.withTintColor(.white), for: .normal)
        button.semanticContentAttribute = .forceRightToLeft
        button.setPreferredSymbolConfiguration(.init(scale: .small), forImageIn: .normal)
        button.setTitle("챌린지 만들기", for: .normal)
        button.titleLabel?.font = CustomFont.PretendardBold(size: .base).font
        button.setTitleColor(.white, for: .normal)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        self.backgroundColor = .custom.gray3
        contentView.addSubviews(mainTitleLabel, subTitleLabel, challengeOpenButton)
        NSLayoutConstraint.activate([
            mainTitleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            mainTitleLabel.bottomAnchor.constraint(equalTo: subTitleLabel.topAnchor, constant: -8),
            subTitleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            subTitleLabel.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -10),
            challengeOpenButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            challengeOpenButton.topAnchor.constraint(equalTo: subTitleLabel.bottomAnchor, constant: 16)
        ])
    }
    
}
