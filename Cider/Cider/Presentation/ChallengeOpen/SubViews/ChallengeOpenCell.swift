//
//  ChallengeOpenCell.swift
//  Cider
//
//  Created by 임영선 on 2023/07/11.
//

import UIKit

final class ChallengeOpenCell: UICollectionViewCell {
    
    private let challengeTitleLabel = StarTitleLabel(title: "챌린지 제목 *")
    private let challengeTitleTextFieldView: CiderTextFieldView = {
        let view = CiderTextFieldView(minLength: 5, maxLength: 30)
        view.setPlaceHoder("하루 만보 걷기 인증하기")
        return view
    }()
    private let challengeIntroductionLabel = StarTitleLabel(title: "챌린지 소개 *")
    private let challengeIntroductionTextView = CiderTextView(minLength: 5, maxLength: 1000, placeHolder: "챌린지 목적, 참여시 좋은 점, 참여 권유 대상 등\n챌린저들의 이해를 돕기 위한 설명을 적어주세요.")
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        addSubviews(challengeTitleLabel, challengeTitleTextFieldView, challengeIntroductionLabel, challengeIntroductionTextView)
        NSLayoutConstraint.activate([
            challengeTitleLabel.topAnchor.constraint(equalTo: topAnchor),
            challengeTitleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            challengeTitleTextFieldView.topAnchor.constraint(equalTo: challengeTitleLabel.bottomAnchor, constant: 8),
            challengeTitleTextFieldView.leadingAnchor.constraint(equalTo: leadingAnchor),
            challengeTitleTextFieldView.trailingAnchor.constraint(equalTo: trailingAnchor),
            challengeTitleTextFieldView.heightAnchor.constraint(equalToConstant: 65),
            challengeIntroductionLabel.topAnchor.constraint(equalTo: challengeTitleTextFieldView.bottomAnchor, constant: 24),
            challengeIntroductionLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            challengeIntroductionTextView.topAnchor.constraint(equalTo: challengeIntroductionLabel.bottomAnchor, constant: 8),
            challengeIntroductionTextView.leadingAnchor.constraint(equalTo: leadingAnchor),
            challengeIntroductionTextView.trailingAnchor.constraint(equalTo: trailingAnchor),
            challengeIntroductionTextView.heightAnchor.constraint(equalToConstant: 360)
        ])
    }
    
}

#if DEBUG
import SwiftUI

@available(iOS 13.0, *)
struct ChallengeOpenCell_Preview: PreviewProvider {
    static var previews: some View {
            
        UIViewPreview {
            let cell = ChallengeOpenCell()
            return cell
        }
        .previewLayout(.sizeThatFits)
        .padding(10)
    }
}
#endif
