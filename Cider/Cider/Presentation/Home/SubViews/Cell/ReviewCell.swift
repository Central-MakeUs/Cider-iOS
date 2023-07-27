//
//  ReviewCell.swift
//  Cider
//
//  Created by 임영선 on 2023/07/26.
//

import UIKit

final class ReviewCell: UICollectionViewCell {
    
    static let identifier = "ReviewCell"
    
    private lazy var mainTitleLabel: UILabel = {
        let label = UILabel()
        label.font = CustomFont.PretendardBold(size: .lg).font
        label.textColor = .custom.text
        return label
    }()
    
    private lazy var challengeTypeLabel: UILabel = {
        let label = UILabel()
        label.font = CustomFont.PretendardBold(size: .sm).font
        label.textColor = .custom.text
        return label
    }()
    
    private lazy var leftLabel: UILabel = {
        let label = UILabel()
        label.font = CustomFont.PretendardRegular(size: .base).font
        label.textColor = .custom.gray6
        return label
    }()
    
    private lazy var arrowImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "arrowRight")
        imageView.heightAnchor.constraint(equalToConstant: 16).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 16).isActive = true
        return imageView
    }()
    
    private lazy var deleteLabel: UILabel = {
        let label = UILabel()
        label.font = CustomFont.PretendardRegular(size: .xs).font
        label.textColor = .custom.gray5
        label.text = "챌린지 삭제"
        return label
    }()
    
    private lazy var rightLabel: UILabel = {
        let label = UILabel()
        label.font = CustomFont.PretendardRegular(size: .xs).font
        label.textColor = .custom.gray5
        return label
    }()
    
    private lazy var deleteImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "filled_trash_16")
        imageView.heightAnchor.constraint(equalToConstant: 16).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 16).isActive = true
        return imageView
    }()
    
    private lazy var leftStackView: UIStackView = {
        let stackView = UIStackView(axis: .horizontal, alignment: .fill, distribution: .fill, spacing: 2)
        stackView.addArrangedSubviews(leftLabel, arrowImageView)
        return stackView
    }()
    
    private lazy var rightStackView: UIStackView = {
        let stackView = UIStackView(axis: .horizontal, alignment: .fill, distribution: .fill, spacing: 0)
        stackView.addArrangedSubviews(deleteLabel, deleteImageView)
        return stackView
    }()
    
    private let reviewstatusBarView = ReviewStatusBarView()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        backgroundColor = .custom.gray1
        addSubviews(mainTitleLabel, challengeTypeLabel, leftStackView, rightStackView, rightLabel, reviewstatusBarView)
        NSLayoutConstraint.activate([
            mainTitleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 12),
            mainTitleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 14),
            challengeTypeLabel.topAnchor.constraint(equalTo: mainTitleLabel.topAnchor),
            challengeTypeLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -14),
            reviewstatusBarView.leadingAnchor.constraint(equalTo: mainTitleLabel.leadingAnchor),
            reviewstatusBarView.trailingAnchor.constraint(equalTo: challengeTypeLabel.trailingAnchor),
            reviewstatusBarView.topAnchor.constraint(equalTo: mainTitleLabel.bottomAnchor, constant: 8),
            reviewstatusBarView.heightAnchor.constraint(equalToConstant: 36.8),
            leftStackView.leadingAnchor.constraint(equalTo: mainTitleLabel.leadingAnchor),
            leftStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12),
            rightStackView.trailingAnchor.constraint(equalTo: challengeTypeLabel.trailingAnchor),
            rightStackView.bottomAnchor.constraint(equalTo: leftStackView.bottomAnchor),
            rightLabel.trailingAnchor.constraint(equalTo: challengeTypeLabel.trailingAnchor),
            rightLabel.bottomAnchor.constraint(equalTo: leftStackView.bottomAnchor)
        ])
    }
    
    func setUp(
        title: String,
        challengeType: ChallengeType,
        reviewType: ReviewType,
        challengeSuccessMessage: String?
    ) {
        mainTitleLabel.text = title
        challengeTypeLabel.text = challengeType.koreanName
        challengeTypeLabel.textColor = challengeType.color
        
        switch reviewType {
        case .reviewing:
            reviewstatusBarView.setReviewStyle(.reviewing)
            leftStackView.isHidden = true
            rightStackView.isHidden = false
            rightLabel.isHidden = true
            
        case .failReview:
            reviewstatusBarView.setReviewStyle(.failReview)
            leftStackView.isHidden = false
            rightStackView.isHidden = false
            rightLabel.isHidden = true
            
            // TODO: 반려/실패 분기 처리
            leftLabel.text = "반려 사유"
            
        case .successReview:
            reviewstatusBarView.setReviewStyle(.successReview)
            leftStackView.isHidden = false
            leftLabel.text = "심사 완료"
            rightStackView.isHidden = true
            rightLabel.isHidden = false
            rightLabel.text = challengeSuccessMessage
        }
        
    }
    
}

#if DEBUG
import SwiftUI

@available(iOS 13.0, *)
struct ReviewCell_Preview: PreviewProvider {
    static var previews: some View {
        
        UIViewPreview {
            let cell = ReviewCell()
            cell.setUp(
                title: "만보 걷기",
                challengeType: .moneyManagement,
                reviewType: .reviewing,
                challengeSuccessMessage: "2023.07.11 챌린지 모집 시작"
            )
            return cell
        }
        .previewLayout(.fixed(width: 150, height: 192))
        .padding(50)
    }
}
#endif
