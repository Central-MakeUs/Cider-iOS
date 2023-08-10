//
//  ChallengeHomeView.swift
//  Cider
//
//  Created by 임영선 on 2023/07/20.
//

import UIKit

final class ChallengeHomeView: UIView {
    
    private lazy var backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    private lazy var iconImageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    private lazy var statusView: UIView = {
        let view = UIView()
        view.backgroundColor = .custom.gray6
        view.layer.cornerRadius = 10
        return view
    }()
    
    private lazy var statusLabel: UILabel = {
        let label = UILabel()
        label.font = CustomFont.PretendardRegular(size: .sm).font
        label.textColor = .white
        return label
    }()
    
    private lazy var rewardLabel: ChallengeTagLabel = {
        let label = ChallengeTagLabel()
        return label
    }()
    
    private lazy var typeLabel: ChallengeTagLabel = {
        let label = ChallengeTagLabel()
        return label
    }()
    
    private lazy var dateLabel: ChallengeTagLabel = {
        let label = ChallengeTagLabel()
        return label
    }()
    
    private lazy var heartButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "line_like_24")?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.tintColor = .white
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
        clipsToBounds = true
        layer.cornerRadius = 4
        addSubviews(backgroundImageView, statusView, rewardLabel, typeLabel, dateLabel, statusLabel, heartButton, iconImageView)
        NSLayoutConstraint.activate([
            backgroundImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            backgroundImageView.topAnchor.constraint(equalTo: topAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            backgroundImageView.bottomAnchor.constraint(equalTo: bottomAnchor),
            statusView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            statusView.topAnchor.constraint(equalTo: topAnchor, constant: 11.5),
            statusView.widthAnchor.constraint(equalToConstant: 53),
            statusView.heightAnchor.constraint(equalToConstant: 21),
            statusLabel.centerXAnchor.constraint(equalTo: statusView.centerXAnchor),
            statusLabel.centerYAnchor.constraint(equalTo: statusView.centerYAnchor),
            heartButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            heartButton.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            typeLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            typeLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8),
            dateLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8),
            dateLabel.leadingAnchor.constraint(equalTo: typeLabel.trailingAnchor, constant: 4),
            rewardLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            rewardLabel.bottomAnchor.constraint(equalTo: typeLabel.topAnchor, constant: -6),
            iconImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            iconImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            iconImageView.heightAnchor.constraint(equalToConstant: 104),
            iconImageView.widthAnchor.constraint(equalToConstant: 104)
        ])
    }
    
    func setUp(
        type: ChallengeType,
        status: String,
        isReward: Bool,
        date: String,
        isLike: Bool
    ) {
        backgroundImageView.image = UIImage(named: type.backgroundImageName)
        statusLabel.text = status
        rewardLabel.isHidden = !isReward
        rewardLabel.setUp(title: "리워드")
        typeLabel.setUp(title: type.koreanName)
        dateLabel.setUp(title: date)
        iconImageView.image = UIImage(named: type.iconImageName)
        heartButton.setImage(UIImage(named: isLike ? "color_like_24" : "line_like_24")?.withRenderingMode(.alwaysTemplate), for: .normal)
        heartButton.tintColor = isLike ? .custom.main : .white
    }
    
    func setClosedChallenge(_ type: ChallengeResultType) {
        statusView.backgroundColor = type == .success ? .custom.main : .custom.gray6
        statusLabel.text = type == .success ? "성공" : "실패"
        heartButton.setImage(UIImage(named: "filled_trash_24"), for: .normal)
    }
    
    func addActionHeart(_ target: Any?, action: Selector) {
        heartButton.addTarget(target, action: action, for: .touchUpInside)
    }
    
}

final class ChallengeTagLabel: UILabel {
    
    private var padding = UIEdgeInsets(top: 2.0, left: 6.0, bottom: 2.0, right: 6.0)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var intrinsicContentSize: CGSize {
        var contentSize = super.intrinsicContentSize
        contentSize.height += padding.top + padding.bottom
        contentSize.width += padding.left + padding.right
        
        return contentSize
    }
    
    private func configure() {
        textAlignment = .center
        font = CustomFont.PretendardRegular(size: .sm).font
        textColor = .custom.gray8
        backgroundColor = .white.withAlphaComponent(0.8)
        layer.borderColor = UIColor.custom.gray8?.cgColor
        layer.borderWidth = 0.5
    }
    
    private func setCornerRadius() {
        clipsToBounds = true
        let width = super.intrinsicContentSize.width
        let height = super.intrinsicContentSize.height
        let longLength = width > height ? width : height
        let shortLength = width < height ? width : height
        let cornerRadius = (longLength * (shortLength/longLength))/2 * 1.2
        layer.cornerRadius = cornerRadius
    }
    
    func setUp(title: String) {
        text = title
        setCornerRadius()
    }
    
}

#if DEBUG
import SwiftUI

@available(iOS 13.0, *)
struct ChallengeHomeView_Preview: PreviewProvider {
    static var previews: some View {
        
        UIViewPreview {
            let view = ChallengeHomeView()
            view.setUp(type: .financialTech, status: "모집중", isReward: true, date: "10주", isLike: true)
            return view
        }
        .previewLayout(.fixed(width: 150, height: 192))
        .padding(100)
    }
}
#endif
