//
//  ChallengeHomeCell.swift
//  Cider
//
//  Created by 임영선 on 2023/07/21.
//

import UIKit

final class ChallengeHomeCell: UICollectionViewCell {
    
    private let type: ChallengeType
    private let status: String
    private let isReward: Bool
    private let date: String
    private let ranking: String?
    private let title: String
    private let people: String
    private let isPublic: Bool
    private let dDay: String

    
    private lazy var rankingLabel: UILabel = {
        let label = UILabel()
        label.textColor = .custom.main
        label.font = CustomFont.PretendardBold(size: .xs).font
        label.text = ranking
        return label
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .custom.text
        label.font = CustomFont.PretendardBold(size: .xl).font
        label.text = title
        return label
    }()

    private lazy var peopleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .custom.gray6
        label.font = CustomFont.PretendardRegular(size: .xs).font
        label.text = people
        return label
    }()

    private lazy var publicLabel: UILabel = {
        let label = UILabel()
        label.text = "공식 챌린지"
        label.textColor = .custom.gray6
        label.font = CustomFont.PretendardRegular(size: .xs).font
        label.isHidden = !isPublic
        return label
    }()

    private lazy var dDayLabel: UILabel = {
        let label = UILabel()
        label.textColor = .custom.main
        label.font = CustomFont.PretendardBold(size: .xs).font
        return label
    }()

    private lazy var peopleImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "line_community_16")
        imageView.heightAnchor.constraint(equalToConstant: 16).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 16).isActive = true
        return imageView
    }()

    private lazy var publicImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "line_certificate_16")
        imageView.heightAnchor.constraint(equalToConstant: 16).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 16).isActive = true
        imageView.isHidden = !isPublic
        return imageView
    }()
    
    private lazy var challengeHomeView: ChallengeHomeView = {
        let view = ChallengeHomeView(type: type, status: status, isReward: isReward, date: date)
        return view
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        return stackView
    }()

    
    init(type: ChallengeType, isReward: Bool, date: String, ranking: String?, title: String, status: String, people: String, isPublic: Bool, dDay: String) {
        self.type = type
        self.isReward = isReward
        self.date = date
        self.ranking = ranking
        self.title = title
        self.status = status
        self.people = people
        self.isPublic = isPublic
        self.dDay = dDay
        super.init(frame: .zero)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

private extension ChallengeHomeCell {
    
    func configure() {
        contentView.addSubviews(challengeHomeView, stackView, peopleLabel, publicLabel,
                                dDayLabel, peopleImageView, publicImageView)
        stackView.addArrangedSubviews(ranking == nil ? titleLabel : rankingLabel, titleLabel)
        NSLayoutConstraint.activate([
            challengeHomeView.topAnchor.constraint(equalTo: topAnchor),
            challengeHomeView.leadingAnchor.constraint(equalTo: leadingAnchor),
            challengeHomeView.trailingAnchor.constraint(equalTo: trailingAnchor),
            challengeHomeView.heightAnchor.constraint(equalTo: widthAnchor, multiplier: 1.28),
            stackView.topAnchor.constraint(equalTo: challengeHomeView.bottomAnchor, constant: 8),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 6),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -6),
            stackView.heightAnchor.constraint(equalToConstant: ranking == nil ? 22 : 36),
            peopleImageView.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 4),
            peopleImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 6),
            peopleLabel.centerYAnchor.constraint(equalTo: peopleImageView.centerYAnchor),
            peopleLabel.leadingAnchor.constraint(equalTo: peopleImageView.trailingAnchor, constant: 4),
            publicImageView.topAnchor.constraint(equalTo: peopleImageView.bottomAnchor, constant: 4),
            publicImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 6),
            publicLabel.centerYAnchor.constraint(equalTo: publicImageView.centerYAnchor),
            publicLabel.leadingAnchor.constraint(equalTo: publicImageView.trailingAnchor, constant: 4),
            dDayLabel.topAnchor.constraint(equalTo: peopleImageView.topAnchor),
            dDayLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -6)
        ])
    }
    
}


#if DEBUG
import SwiftUI

@available(iOS 13.0, *)
struct ChallengeHomeCell_Preview: PreviewProvider {
    static var previews: some View {
        
        UIViewPreview {
            let view = ChallengeHomeCell(type: .moneyManagement, isReward: true, date: "3주", ranking: "1위", title: "만보 걷기", status: "모집중", people: "5명 진행중", isPublic: true, dDay: "D-32")
            return view
        }
        .previewLayout(.fixed(width: 150, height: 192))
        .padding(100)
    }
}
#endif
