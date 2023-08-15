//
//  MypageInfoView.swift
//  Cider
//
//  Created by 임영선 on 2023/08/11.
//

import UIKit

final class MypageInfoView: UIView {

    private lazy var profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 46/2
        imageView.contentMode = .scaleAspectFill
        imageView.heightAnchor.constraint(equalToConstant: 46).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 46).isActive = true
        return imageView
    }()

    private lazy var nicknameLabel: UILabel = {
        let label = UILabel()
        label.font = CustomFont.PretendardBold(size: .xl).font
        label.textColor = .custom.gray7
        return label
    }()

    private lazy var levelLabel: UILabel = {
        let label = UILabel()
        label.font = CustomFont.PretendardBold(size: .sm).font
        label.textColor = .custom.main
        return label
    }()

    private lazy var participationLabel: UILabel = {
        let label = UILabel()
        label.font = CustomFont.PretendardBold(size: .sm).font
        label.textColor = .custom.secondary
        return label
    }()

    private lazy var barView: UIView = {
        let view = UIView()
        view.backgroundColor = .custom.gray3
        view.layer.cornerRadius = 4
        return view
    }()

    private lazy var levelCountView: MypageCountView = {
        let view = MypageCountView(type: .level)
        return view
    }()

    private lazy var certifyCountView: MypageCountView = {
        let view = MypageCountView(type: .certify)
        return view
    }()

    private lazy var heartCountView: MypageCountView = {
        let view = MypageCountView(type: .heart)
        return view
    }()

    private lazy var writingButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "line_edit_24"), for: .normal)
        return button
    }()

    private lazy var myChallengeButton: UIButton = {
        let button = UIButton()
        button.setTitle("내 챌린지 현황", for: .normal)
        button.titleLabel?.font = CustomFont.PretendardBold(size: .base).font
        button.setTitleColor(.custom.gray6, for: .normal)
        button.layer.cornerRadius = 4
        button.layer.borderColor = UIColor.custom.gray4?.cgColor
        button.layer.borderWidth = 1
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
        addSubviews(profileImageView, nicknameLabel, levelLabel, participationLabel, barView, levelCountView, certifyCountView, heartCountView, writingButton, myChallengeButton)
        NSLayoutConstraint.activate([
            profileImageView.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            profileImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24),
            nicknameLabel.topAnchor.constraint(equalTo: profileImageView.topAnchor),
            nicknameLabel.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 8),
            levelLabel.bottomAnchor.constraint(equalTo: profileImageView.bottomAnchor),
            levelLabel.leadingAnchor.constraint(equalTo: nicknameLabel.leadingAnchor),
            barView.heightAnchor.constraint(equalToConstant: 10),
            barView.widthAnchor.constraint(equalToConstant: 1),
            barView.centerYAnchor.constraint(equalTo: levelLabel.centerYAnchor),
            barView.leadingAnchor.constraint(equalTo: levelLabel.trailingAnchor, constant: 6),
            participationLabel.leadingAnchor.constraint(equalTo: barView.trailingAnchor, constant: 6),
            participationLabel.centerYAnchor.constraint(equalTo: levelLabel.centerYAnchor),
            certifyCountView.centerXAnchor.constraint(equalTo: centerXAnchor),
            certifyCountView.topAnchor.constraint(equalTo: levelLabel.bottomAnchor, constant: 14),
            levelCountView.topAnchor.constraint(equalTo: certifyCountView.topAnchor),
            levelCountView.trailingAnchor.constraint(equalTo: certifyCountView.leadingAnchor, constant: -8),
            heartCountView.topAnchor.constraint(equalTo: certifyCountView.topAnchor),
            heartCountView.leadingAnchor.constraint(equalTo: certifyCountView.trailingAnchor, constant: 8),
            writingButton.heightAnchor.constraint(equalToConstant: 24),
            writingButton.widthAnchor.constraint(equalToConstant: 24),
            writingButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24),
            writingButton.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            myChallengeButton.topAnchor.constraint(equalTo: levelCountView.bottomAnchor, constant: 12),
            myChallengeButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24),
            myChallengeButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24),
            myChallengeButton.heightAnchor.constraint(equalToConstant: 36)
        ])
    }

}

extension MypageInfoView {

    func setUp(
        profileURL: String,
        nickname: String,
        levelText: String,
        particiationText: String,
        levelCount: String,
        certifyCount: String,
        heartCount: String
    ) {
        profileImageView.load(url: profileURL)
        nicknameLabel.text = nickname
        levelLabel.text = levelText
        participationLabel.text = particiationText
        levelCountView.setCount(levelCount)
        certifyCountView.setCount(certifyCount)
        heartCountView.setCount(heartCount)
    }

}

enum MypageCountType {
    case level
    case certify
    case heart

    var title: String {
        switch self {
        case .level:
            return "나의 레벨"
        case .certify:
            return "나의 인증글"
        case .heart:
            return "관심 챌린지"
        }
    }

    var iconImage: String {
        switch self {
        case .level:
            return "line_info_16"
        case .certify:
            return "line_arrow-right_16"
        case .heart:
            return "line_arrow-right_16"
        }
    }
}

final class MypageCountView: UIView {

    private let type: MypageCountType

    private lazy var countLabel: UILabel = {
        let label = UILabel()
        label.font = CustomFont.PretendardBold(size: .xl2).font
        label.textColor = .custom.text
        return label
    }()

    private lazy var subTitleLabel: UILabel = {
        let label = UILabel()
        label.font = CustomFont.PretendardBold(size: .sm).font
        label.textColor = .custom.gray5
        label.text = type.title
        return label
    }()

    private lazy var iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.heightAnchor.constraint(equalToConstant: 16).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 16).isActive = true
        imageView.image = UIImage(named: type.iconImage)
        return imageView
    }()

    init(type: MypageCountType) {
        self.type = type
        super.init(frame: .zero)
        configure()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configure() {
        addSubviews(countLabel, subTitleLabel, iconImageView)
        NSLayoutConstraint.activate([
            self.widthAnchor.constraint(equalToConstant: 93),
            self.heightAnchor.constraint(equalToConstant: 72),
            countLabel.topAnchor.constraint(equalTo: topAnchor, constant: 11),
            countLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            subTitleLabel.topAnchor.constraint(equalTo: countLabel.bottomAnchor, constant: 15),
            subTitleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            iconImageView.centerYAnchor.constraint(equalTo: subTitleLabel.centerYAnchor),
            iconImageView.leadingAnchor.constraint(equalTo: subTitleLabel.trailingAnchor)
        ])
    }

    func setCount(_ text: String) {
        countLabel.text = text
    }

}


#if DEBUG
import SwiftUI

@available(iOS 13.0, *)
struct MypageInfoView_Preview: PreviewProvider {
    static var previews: some View {

        UIViewPreview {
            let view = MypageInfoView()
            view.setUp(
                profileURL: "https://cider-bucket.s3.ap-northeast-2.amazonaws.com/profile/30_6f9e33e8-9f25-4849-8abb-229e67455f9c_Cider5.jpeg",
                nickname: "혁신적인주식호랑이",
                levelText: "Lv 5 엘리트 챌린저",
                particiationText: "0번째 챌린지",
                levelCount: "Lv 1",
                certifyCount: "5",
                heartCount: "11"
            )
            return view
        }
        .previewLayout(.sizeThatFits)
        .padding(50)
    }
}
#endif
