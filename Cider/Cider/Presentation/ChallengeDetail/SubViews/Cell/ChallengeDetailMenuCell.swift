//
//  ChallengeDetailMenuCell.swift
//  Cider
//
//  Created by 임영선 on 2023/07/28.
//

import UIKit

final class ChallengeDetailMenuCell: UICollectionViewCell {
    
    static let identifier = "ChallengeDetailMenuCell"
    
    private lazy var challengeIconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.heightAnchor.constraint(equalToConstant: 170).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 170).isActive = true
        return imageView
    }()
    
    private lazy var profileBackgorundView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.heightAnchor.constraint(equalToConstant: 64).isActive = true
        view.widthAnchor.constraint(equalToConstant: 64).isActive = true
        view.layer.cornerRadius = 32
        return view
    }()
    
    private lazy var profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 55/2
        imageView.contentMode = .scaleAspectFill
        imageView.heightAnchor.constraint(equalToConstant: 55).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 55).isActive = true
        return imageView
    }()
    
    private lazy var mainTitleLabel: UILabel = {
        let label = UILabel()
        label.font = CustomFont.PretendardBold(size: .xl2).font
        label.textColor = .custom.text
        return label
    }()
    
    private lazy var participantsLabel: UILabel = {
        let label = UILabel()
        label.font = CustomFont.PretendardBold(size: .sm).font
        label.textColor = .custom.gray5
        return label
    }()
    
    private lazy var statusLabel: DynamicLabel = {
        let label = DynamicLabel(horizontalPadding: 4, verticalPadding: 2)
        label.font = CustomFont.PretendardBold(size: .sm).font
        label.textColor = UIColor(red: 1, green: 0.49, blue: 0, alpha: 1)
        label.backgroundColor = UIColor(red: 1, green: 0.94, blue: 0.83, alpha: 1)
        label.clipsToBounds = true
        label.layer.cornerRadius = 4
        return label
    }()
    
    private lazy var infoMenuButton: UIButton = {
        let button = UIButton()
        button.setTitle("챌린지 정보", for: .normal)
        button.setTitleColor(.custom.main, for: .normal)
        button.titleLabel?.font = CustomFont.PretendardBold(size: .lg).font
        button.addTarget(self, action: #selector(didTapInfo), for: .touchUpInside)
        return button
    }()
    
    private lazy var feedMenuButton: UIButton = {
        let button = UIButton()
        button.setTitle("피드", for: .normal)
        button.setTitleColor(.custom.gray5, for: .normal)
        button.titleLabel?.font = CustomFont.PretendardBold(size: .lg).font
        button.addTarget(self, action: #selector(didTapFeed), for: .touchUpInside)
        return button
    }()
    
    private lazy var infoUnderBarView: UIView = {
        let view = UIView()
        view.backgroundColor = .custom.main
        view.heightAnchor.constraint(equalToConstant: 3).isActive = true
        return view
    }()
    
    private lazy var feedUnderBarView: UIView = {
        let view = UIView()
        view.backgroundColor = .custom.main
        view.heightAnchor.constraint(equalToConstant: 3).isActive = true
        return view
    }()
    
    private lazy var menuStackView: UIStackView = {
        let stackView = UIStackView(axis: .horizontal, alignment: .fill, distribution: .fillEqually, spacing: 0)
        stackView.addArrangedSubviews(infoMenuButton, feedMenuButton)
        return stackView
    }()
    
    private lazy var radiusView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 8
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
        setUpMenu(.info)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        addSubviews(challengeIconImageView, radiusView, profileBackgorundView, profileImageView, mainTitleLabel, participantsLabel,
                    statusLabel, menuStackView, infoUnderBarView, feedUnderBarView)
        NSLayoutConstraint.activate([
            challengeIconImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            challengeIconImageView.topAnchor.constraint(equalTo: topAnchor, constant: 4),
            radiusView.topAnchor.constraint(equalTo: challengeIconImageView.bottomAnchor, constant: 34.76),
            radiusView.leadingAnchor.constraint(equalTo: leadingAnchor),
            radiusView.trailingAnchor.constraint(equalTo: trailingAnchor),
            radiusView.bottomAnchor.constraint(equalTo: bottomAnchor),
            profileBackgorundView.bottomAnchor.constraint(equalTo: radiusView.topAnchor, constant: 22),
            profileBackgorundView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24),
            profileImageView.centerXAnchor.constraint(equalTo: profileBackgorundView.centerXAnchor),
            profileImageView.centerYAnchor.constraint(equalTo: profileBackgorundView.centerYAnchor),
            mainTitleLabel.topAnchor.constraint(equalTo: radiusView.topAnchor, constant: 20),
            mainTitleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24),
            participantsLabel.topAnchor.constraint(equalTo: mainTitleLabel.bottomAnchor, constant: 12),
            participantsLabel.leadingAnchor.constraint(equalTo: mainTitleLabel.leadingAnchor),
            statusLabel.centerYAnchor.constraint(equalTo: participantsLabel.centerYAnchor),
            statusLabel.leadingAnchor.constraint(equalTo: participantsLabel.trailingAnchor, constant: 10),
            menuStackView.topAnchor.constraint(equalTo: statusLabel.bottomAnchor, constant: 16),
            menuStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            menuStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            menuStackView.heightAnchor.constraint(equalToConstant: 41),
            infoUnderBarView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width/2),
            infoUnderBarView.topAnchor.constraint(equalTo: menuStackView.bottomAnchor),
            infoUnderBarView.centerXAnchor.constraint(equalTo: infoMenuButton.centerXAnchor),
            infoUnderBarView.bottomAnchor.constraint(equalTo: bottomAnchor),
            feedUnderBarView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width/2),
            feedUnderBarView.topAnchor.constraint(equalTo: menuStackView.bottomAnchor),
            feedUnderBarView.centerXAnchor.constraint(equalTo: feedMenuButton.centerXAnchor),
            feedUnderBarView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }
    
    @objc func didTapInfo(_ sender: Any?) {
        let menyType: ChallengeDetailMenuType = .info
        NotificationCenter.default.post(name: .tapChallengeDetailMenu, object: menyType)
    }
    
    @objc func didTapFeed(_ sender: Any?) {
        let menyType: ChallengeDetailMenuType = .feed
        NotificationCenter.default.post(name: .tapChallengeDetailMenu, object: menyType)
    }
    
}

extension ChallengeDetailMenuCell {
    
    func setUp(
        challengeType: ChallengeType,
        profileImage: UIImage?,
        mainTitle: String,
        participant: String,
        status: String
    ) {
        self.backgroundColor = challengeType.color
        profileImageView.image = profileImage
        challengeIconImageView.image = UIImage(named: challengeType.bannerImageName)
        mainTitleLabel.text = mainTitle
        participantsLabel.text = participant
        statusLabel.text = status
    }
    
    func setUpMenu(_ type: ChallengeDetailMenuType) {
        infoMenuButton.setTitleColor(type == .info ? .custom.main : .custom.gray5, for: .normal)
        feedMenuButton.setTitleColor(type == .feed ? .custom.main : .custom.gray5, for: .normal)
        feedUnderBarView.isHidden = type == .info
        infoUnderBarView.isHidden = type == .feed
    }
    
}


#if DEBUG
import SwiftUI

@available(iOS 13.0, *)
struct ChallengeDetailMenuCell_Preview: PreviewProvider {
    static var previews: some View {
        
        UIViewPreview {
            let cell = ChallengeDetailMenuCell()
            cell.setUp(
                challengeType: .moneySaving,
                profileImage: UIImage(named: "sample"),
                mainTitle: "만보 걷기~~~~~~",
                participant: "29 / 30명",
                status: "진행중 D-6"
            )
            return cell
        }
        .previewLayout(.fixed(width: 150, height: 192))
        //.padding(100)
    }
}
#endif
