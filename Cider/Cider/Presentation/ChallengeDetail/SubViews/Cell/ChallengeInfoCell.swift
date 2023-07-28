//
//  ChallengeInfoCell.swift
//  Cider
//
//  Created by 임영선 on 2023/07/28.
//

import UIKit

final class ChallengeInfoCell: UICollectionViewCell {
    
    static let identifier = "ChallengeInfoCell"

    private let recruitView = ChallengeInfoView(iconName: "filled_calender_16", title: "모집 기간")
    private let dateView = ChallengeInfoView(iconName: "filled_noti_16", title: "챌린지 기간")
    private let peopleView = ChallengeInfoView(iconName: "filled_community_16", title: "모집 인원")
    private let missionCountView = ChallengeInfoView(iconName: "filled_checkbox_16", title: "인증 횟수")
    private let missionTimeView = ChallengeInfoView(iconName: "filled_clock_16", title: "인증 시간")
    private let rewardView = ChallengeInfoView(iconName: "filled_gift_16", title: "리워드")
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        stackView.addArrangedSubviews(recruitView, dateView, peopleView, missionCountView, missionTimeView, rewardView)
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        addSubviews(stackView)
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.heightAnchor.constraint(equalToConstant: 216),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -24)
        ])
    }

}


extension ChallengeInfoCell {
    
    func setUp(
        recruit: String,
        date: String,
        people: String,
        missionCount: String,
        missionTime: String,
        reward: String
    ) {
        recruitView.setUp(content: recruit)
        dateView.setUp(content: date)
        peopleView.setUp(content: people)
        missionCountView.setUp(content: missionCount)
        missionTimeView.setUp(content: missionTime)
        rewardView.setUp(content: reward)
    }
    
}
