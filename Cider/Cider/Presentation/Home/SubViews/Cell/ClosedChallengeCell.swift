//
//  ClosedChallengeCell.swift
//  Cider
//
//  Created by 임영선 on 2023/07/27.
//
import UIKit

final class ClosedChallengeCell: UICollectionViewCell {
    
    static let identifier = "ClosedChallengeCell"
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .custom.text
        label.font = CustomFont.PretendardBold(size: .xl).font
        return label
    }()

    private lazy var peopleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .custom.gray6
        label.font = CustomFont.PretendardRegular(size: .xs).font
        return label
    }()

    private lazy var publicLabel: UILabel = {
        let label = UILabel()
        label.text = "공식 챌린지"
        label.textColor = .custom.gray6
        label.font = CustomFont.PretendardRegular(size: .xs).font
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
        return imageView
    }()
    
    lazy var challengeHomeView: ChallengeHomeView = {
        let view = ChallengeHomeView()
        return view
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 2
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

private extension ClosedChallengeCell {
    
    func configure() {
        contentView.addSubviews(challengeHomeView, stackView, peopleLabel, publicLabel, peopleImageView, publicImageView)
        stackView.addArrangedSubviews(titleLabel)
        NSLayoutConstraint.activate([
            challengeHomeView.topAnchor.constraint(equalTo: topAnchor),
            challengeHomeView.leadingAnchor.constraint(equalTo: leadingAnchor),
            challengeHomeView.trailingAnchor.constraint(equalTo: trailingAnchor),
            challengeHomeView.heightAnchor.constraint(equalTo: widthAnchor, multiplier: 1.28),
            stackView.topAnchor.constraint(equalTo: challengeHomeView.bottomAnchor, constant: 8),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 6),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -6),
            peopleImageView.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 5),
            peopleImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 6),
            peopleLabel.centerYAnchor.constraint(equalTo: peopleImageView.centerYAnchor),
            peopleLabel.leadingAnchor.constraint(equalTo: peopleImageView.trailingAnchor, constant: 4),
            publicImageView.topAnchor.constraint(equalTo: peopleImageView.bottomAnchor),
            publicImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 6),
            publicLabel.centerYAnchor.constraint(equalTo: publicImageView.centerYAnchor),
            publicLabel.leadingAnchor.constraint(equalTo: publicImageView.trailingAnchor, constant: 4)
        ])
    }
    
}

extension ClosedChallengeCell {
    func setUp(
        type: ChallengeType,
        isReward: Bool,
        date: String,
        title: String,
        status: String,
        people: String,
        isPublic: Bool
    ) {
        titleLabel.text = title
        peopleLabel.text = people
        publicLabel.isHidden = !isPublic
        publicImageView.isHidden = !isPublic
        challengeHomeView.setUp(type: type, status: status, isReward: isReward, date: date, isLike: true)
    }
}


#if DEBUG
import SwiftUI

@available(iOS 13.0, *)
struct ClosedChallengeCell_Preview: PreviewProvider {
    static var previews: some View {

        UIViewPreview {
            let cell = ClosedChallengeCell()
            cell.setUp(type: .financialTech, isReward: true, date: "1주", title: "만보걷기", status: "종료", people: "5명 모집중", isPublic: true)
            cell.challengeHomeView.setClosedChallenge(.fail)
            return cell
        }
        .previewLayout(.fixed(width: 150, height: 192))
        .padding(100)
    }
}
#endif
