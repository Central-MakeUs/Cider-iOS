//
//  ChallengeHomeView.swift
//  Cider
//
//  Created by 임영선 on 2023/07/20.
//

import UIKit

final class ChallengeHomeView: UIView {
    
    private let type: ChallengeType
    private let status: String
    private let isReward: Bool
    private let date: String
    
    private lazy var backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: type.backgroundImageName)
        return imageView
    }()
    
    private lazy var statusView: UIView = {
        let view = UIView()
        view.backgroundColor = .custom.gray6
        view.layer.cornerRadius = 12
        return view
    }()
    
    private lazy var statusLabel: UILabel = {
        let label = UILabel()
        label.text = status
        label.font = CustomFont.PretendardRegular(size: .sm).font
        label.textColor = .white
        return label
    }()
    
    private lazy var rewardLabel: ChallengeTagLabel = {
        let label = ChallengeTagLabel(title: "리워드")
        label.isHidden = !isReward
        return label
    }()
    
    private lazy var typeLabel: ChallengeTagLabel = {
        let label = ChallengeTagLabel(title: type.koreanName)
        return label
    }()
    
    private lazy var dateLabel: ChallengeTagLabel = {
        let label = ChallengeTagLabel(title: date)
        return label
    }()
    
    private lazy var heartButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "line_like_24")?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.tintColor = .white
        return button
    }()
    
    init(type: ChallengeType, status: String, isReward: Bool, date: String) {
        self.type = type
        self.status = status
        self.isReward = isReward
        self.date = date
        super.init(frame: .zero)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        clipsToBounds = true
        layer.cornerRadius = 4
        addSubviews(backgroundImageView, statusView, rewardLabel, typeLabel, dateLabel, statusLabel, heartButton)
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
            rewardLabel.bottomAnchor.constraint(equalTo: typeLabel.topAnchor, constant: -6)
        ])
    }
    
}

final class ChallengeTagLabel: UILabel {
    
    private let title: String
    private var padding = UIEdgeInsets(top: 2.0, left: 6.0, bottom: 2.0, right: 6.0)
    
    init(title: String) {
        self.title = title
        super.init(frame: .zero)
        configure()
        setCornerRadius()
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
        text = title
        textAlignment = .center
        font = CustomFont.PretendardRegular(size: .sm).font
        textColor = .custom.gray8
        backgroundColor = .white.withAlphaComponent(0.8)
        layer.borderColor = UIColor.custom.gray8?.cgColor
        layer.borderWidth = 0.5
        clipsToBounds = true
    }
    
    private func setCornerRadius() {
        let width = super.intrinsicContentSize.width
        let height = super.intrinsicContentSize.height
        let longLength = width > height ? width : height
        let shortLength = width < height ? width : height
        let cornerRadius = (longLength * (shortLength/longLength))/2 * 1.2
        layer.cornerRadius = cornerRadius
    }
    
}

#if DEBUG
import SwiftUI

@available(iOS 13.0, *)
struct ChallengeHomeView_Preview: PreviewProvider {
    static var previews: some View {
        
        UIViewPreview {
            let view = ChallengeHomeView(type: .financialTech, status: "모집중", isReward: false, date: "1주")
            return view
        }
        .previewLayout(.fixed(width: 150, height: 192))
        .padding(100)
    }
}
#endif
