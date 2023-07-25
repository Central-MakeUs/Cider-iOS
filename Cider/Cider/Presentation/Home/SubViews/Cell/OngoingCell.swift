//
//  OngoingCell.swift
//  Cider
//
//  Created by 임영선 on 2023/07/25.
//

import UIKit

final class OngoingCell: UICollectionViewCell {
    
    private lazy var mainTitleLabel: UILabel = {
        let label = UILabel()
        label.font = CustomFont.PretendardBold(size: .lg).font
        label.textColor = .custom.text
        return label
    }()
    
    private lazy var challengeTitleLabel: UILabel = {
        let label = UILabel()
        label.font = CustomFont.PretendardBold(size: .sm).font
        label.textColor = .custom.text
        return label
    }()
    
    private lazy var onGoingLabel: UILabel = {
        let label = UILabel()
        label.font = CustomFont.PretendardBold(size: .sm).font
        label.textColor = .custom.gray5
        return label
    }()
    
    private lazy var countLabel: UILabel = {
        let label = UILabel()
        label.font = CustomFont.PretendardBold(size: .xs).font
        label.textColor = .custom.gray6
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
        self.backgroundColor = .custom.gray1
        self.layer.cornerRadius = 4
        addSubviews(mainTitleLabel, challengeTitleLabel, onGoingLabel, countLabel)
        NSLayoutConstraint.activate([
            mainTitleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 12.5),
            mainTitleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 14),
            mainTitleLabel.trailingAnchor.constraint(equalTo: challengeTitleLabel.leadingAnchor, constant: -4),
            challengeTitleLabel.topAnchor.constraint(equalTo: mainTitleLabel.topAnchor),
            challengeTitleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -14),
            onGoingLabel.topAnchor.constraint(equalTo: mainTitleLabel.bottomAnchor, constant: 6),
            onGoingLabel.leadingAnchor.constraint(equalTo: mainTitleLabel.leadingAnchor),
            countLabel.centerYAnchor.constraint(equalTo: onGoingLabel.centerYAnchor),
            countLabel.trailingAnchor.constraint(equalTo: challengeTitleLabel.trailingAnchor)
        ])
    }
    
}

extension OngoingCell {
    
    func setUp(
        mainTitle: String,
        challengeType: ChallengeType,
        onGoing: String,
        countText: String
    ) {
        mainTitleLabel.text = mainTitle
        challengeTitleLabel.text = challengeType.koreanName
        challengeTitleLabel.textColor = challengeType.color
        onGoingLabel.text = onGoing
        countLabel.text = countText
    }
    
}

#if DEBUG
import SwiftUI

@available(iOS 13.0, *)
struct OngoingCell_Preview: PreviewProvider {
    static var previews: some View {
        
        UIViewPreview {
            let view = OngoingCell()
            view.setUp(
                mainTitle: "소비습관 고치기",
                challengeType: .financialLearning,
                onGoing: "챌린지 진행 +10일",
                countText: "30회 중 24회 달성"
            )
            return view
        }
        .previewLayout(.fixed(width: 150, height: 192))
        .padding(50)
    }
}
#endif
