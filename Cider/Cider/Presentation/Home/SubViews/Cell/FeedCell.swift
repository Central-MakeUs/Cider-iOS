//
//  FeedCell.swift
//  Cider
//
//  Created by 임영선 on 2023/07/24.
//

import UIKit

final class FeedCell: UICollectionViewCell {
    
    static let identifier = "FeedCell"
    var certifyId: Int?
    
    private lazy var profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 18
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private lazy var nicknameLabel: UILabel = {
        let label = UILabel()
        label.font = CustomFont.PretendardBold(size: .sm).font
        label.textColor = .custom.gray6
        return label
    }()
    
    private lazy var levelLabel: UILabel = {
        let label = UILabel()
        label.font = CustomFont.PretendardBold(size: .sm).font
        label.textColor = .custom.main
        return label
    }()
    
    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.font = CustomFont.PretendardRegular(size: .sm).font
        label.textColor = .custom.gray4
        return label
    }()
    
    lazy var meatballButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "line_more(meatball)_24"), for: .normal)
        return button
    }()
    
    private lazy var moreButton: UIButton = {
        let button = UIButton()
        button.setTitle("자세히 보기", for: .normal)
        button.setTitleColor(UIColor.custom.gray5, for: .normal)
        button.titleLabel?.font = CustomFont.PretendardBold(size: .sm).font
        button.addTarget(self, action: #selector(didTapMore), for: .touchUpInside)
        return button
    }()
    
    private lazy var mainTitleLabel: UILabel = {
        let label = UILabel()
        label.font = CustomFont.PretendardBold(size: .xl).font
        label.textColor = .custom.text
        return label
    }()
    
    private lazy var subTitleLabel: UILabel = {
        let label = UILabel()
        label.font = CustomFont.PretendardRegular(size: .base).font
        label.textColor = .custom.text
        label.numberOfLines = 1
        return label
    }()
    
    private lazy var feedImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 4
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private lazy var challengeTypeLabel: UILabel = {
        let label = UILabel()
        label.font = CustomFont.PretendardBold(size: .sm).font
        label.setContentHuggingPriority(UILayoutPriority(252), for: .horizontal)
        return label
    }()
    
    private lazy var challengeTitleLabel: UILabel = {
        let label = UILabel()
        label.font = CustomFont.PretendardRegular(size: .sm).font
        label.textColor = .custom.gray6
        label.setContentCompressionResistancePriority(UILayoutPriority(749), for: .horizontal)
        return label
    }()
    
    private lazy var peopleLabel: UILabel = {
        let label = UILabel()
        label.font = CustomFont.PretendardRegular(size: .sm).font
        label.textColor = .custom.gray5
        label.setContentHuggingPriority(UILayoutPriority(252), for: .horizontal)
        return label
    }()
    
    private lazy var peopleImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "line_community_16")
        return imageView
    }()
    
    private lazy var challengeTypeStackView: UIStackView = {
        let stackView = UIStackView(axis: .horizontal, alignment: .center, distribution: .fill, spacing: 4)
        stackView.addArrangedSubviews(challengeTypeLabel, challengeTitleLabel, peopleImageView, peopleLabel)
        stackView.setCustomSpacing(0, after: peopleImageView)
        return stackView
    }()
    
    private lazy var roundView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 33/2
        view.layer.borderColor = UIColor.custom.gray2?.cgColor
        view.layer.borderWidth = 1
        return view
    }()
    
    private lazy var heartButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "line_like_24"), for: .normal)
        return button
    }()
    
    private lazy var heartLabel: UILabel = {
        let label = UILabel()
        label.font = CustomFont.PretendardBold(size: .sm).font
        label.textColor = .custom.gray5
        return label
    }()
    
    private lazy var bottomView: UIView = {
        let view = UIView()
        view.backgroundColor = .custom.gray2
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        feedImageView.image = nil
        profileImageView.image = nil
    }
    
    private func configure() {
        addSubviews(profileImageView, nicknameLabel, levelLabel, dateLabel, meatballButton,
                    moreButton, mainTitleLabel, subTitleLabel, feedImageView, challengeTypeStackView, roundView, heartButton, heartLabel, bottomView)
        NSLayoutConstraint.activate([
            profileImageView.widthAnchor.constraint(equalToConstant: 36),
            profileImageView.heightAnchor.constraint(equalToConstant: 36),
            profileImageView.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            profileImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            nicknameLabel.topAnchor.constraint(equalTo: profileImageView.topAnchor, constant: 2),
            nicknameLabel.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 6),
            levelLabel.topAnchor.constraint(equalTo: nicknameLabel.topAnchor),
            levelLabel.leadingAnchor.constraint(equalTo: nicknameLabel.trailingAnchor, constant: 6),
            dateLabel.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 6),
            dateLabel.bottomAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: -2),
            meatballButton.widthAnchor.constraint(equalToConstant: 24),
            meatballButton.heightAnchor.constraint(equalToConstant: 24),
            meatballButton.trailingAnchor.constraint(equalTo: trailingAnchor),
            meatballButton.bottomAnchor.constraint(equalTo: profileImageView.bottomAnchor),
            mainTitleLabel.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 12),
            mainTitleLabel.leadingAnchor.constraint(equalTo: profileImageView.leadingAnchor),
            mainTitleLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            subTitleLabel.topAnchor.constraint(equalTo: mainTitleLabel.bottomAnchor, constant: 4),
            subTitleLabel.leadingAnchor.constraint(equalTo: mainTitleLabel.leadingAnchor),
            subTitleLabel.trailingAnchor.constraint(equalTo: mainTitleLabel.trailingAnchor),
            moreButton.topAnchor.constraint(equalTo: subTitleLabel.bottomAnchor, constant: 8),
            moreButton.leadingAnchor.constraint(equalTo: profileImageView.leadingAnchor),
            moreButton.heightAnchor.constraint(equalToConstant: 12),
            feedImageView.topAnchor.constraint(equalTo: moreButton.bottomAnchor, constant: 16),
            feedImageView.leadingAnchor.constraint(equalTo: profileImageView.leadingAnchor),
            feedImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            feedImageView.heightAnchor.constraint(equalTo: feedImageView.widthAnchor),
            roundView.leadingAnchor.constraint(equalTo: profileImageView.leadingAnchor),
            roundView.trailingAnchor.constraint(equalTo: trailingAnchor),
            roundView.heightAnchor.constraint(equalToConstant: 33),
            peopleImageView.heightAnchor.constraint(equalToConstant: 16),
            peopleImageView.widthAnchor.constraint(equalToConstant: 16),
            roundView.topAnchor.constraint(equalTo: feedImageView.bottomAnchor, constant: 8),
            challengeTypeStackView.leadingAnchor.constraint(equalTo: roundView.leadingAnchor, constant: 12),
            challengeTypeStackView.trailingAnchor.constraint(equalTo: roundView.trailingAnchor, constant: -12),
            challengeTypeStackView.centerYAnchor.constraint(equalTo: roundView.centerYAnchor),
            heartLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            heartLabel.centerYAnchor.constraint(equalTo: heartButton.centerYAnchor),
            heartButton.widthAnchor.constraint(equalToConstant: 16),
            heartButton.heightAnchor.constraint(equalToConstant: 16),
            heartButton.topAnchor.constraint(equalTo: roundView.bottomAnchor, constant: 8.5),
            heartButton.trailingAnchor.constraint(equalTo: heartLabel.leadingAnchor, constant: -4),
            bottomView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: -24),
            bottomView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 24),
            bottomView.heightAnchor.constraint(equalToConstant: 8),
            bottomView.topAnchor.constraint(equalTo: heartButton.bottomAnchor, constant: 16),
            bottomView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
}


extension FeedCell {
    
    func setUp(
        nickname: String,
        level: String,
        date: String,
        mainTitle: String,
        subTitle: String,
        challengeType: ChallengeType,
        challengeTitle: String,
        people: String,
        heart: String,
        profileImageURL: String,
        feedImageURL: String,
        isLike: Bool
    ) {
        nicknameLabel.text = nickname
        levelLabel.text = level
        dateLabel.text = date
        mainTitleLabel.text = mainTitle
        subTitleLabel.text = subTitle
        challengeTypeLabel.text = challengeType.koreanName
        challengeTypeLabel.textColor = challengeType.color
        challengeTitleLabel.text = challengeTitle
        peopleLabel.text = people + "명"
        heartLabel.text = heart
        profileImageView.load(url: profileImageURL)
        feedImageView.load(url: feedImageURL)
        heartButton.setImage(UIImage(named: isLike ? "color_like_24" : "line_like_24"), for: .normal)
    }
    
    func addMoreButtonAction(_ target: Any?, action: Selector) {
        moreButton.addTarget(target, action: action, for: .touchUpInside)
    }
    
    func addHeartButtonAction(_ target: Any?, action: Selector) {
        heartButton.addTarget(target, action: action, for: .touchUpInside)
    }
    
    @objc func didTapMore(_ sender: Any?) {
        // TODO: collectionView applysnapshot 해주기
        subTitleLabel.numberOfLines = subTitleLabel.numberOfLines == 0 ? 1 : 0
    }
    
}

#if DEBUG
import SwiftUI

@available(iOS 13.0, *)
struct FeedCell_Preview: PreviewProvider {
    static var previews: some View {
        
        UIViewPreview {
            let view = FeedCell()
            view.setUp(
                nickname: "화이팅",
                level: "LV 1",
                date: "23.05.15 15:45",
                mainTitle: "오늘 챌린지 인증하는데",
                subTitle: "챌린지 하면 할수록 너무 힘들구 어쩌고 저쩌고 근데 할 수 있다 챌린지 하면 할수록 챌린지 하면 할수록\n챌린지 하면 할수록 너무 힘들구 어쩌고 저쩌고 근데 할 수 있다\n챌린지 하면 할수록 너무 힘들구 어쩌고 저쩌고 근데 할 수 있다\n",
                challengeType: .financialTech,
                challengeTitle: "하루에 만보 걷기 챌린지 하루를 열심히 살아보아요!!!",
                people: "231",
                heart: "1111",
                profileImageURL: "https://cider-bucket.s3.ap-northeast-2.amazonaws.com/profileExample/bear.png",
                feedImageURL: "https://cider-bucket.s3.ap-northeast-2.amazonaws.com/profileExample/bear.png",
                isLike: true
            )
            return view
        }
        .previewLayout(.fixed(width: 150, height: 192))
        .padding(50)
    }
}
#endif
