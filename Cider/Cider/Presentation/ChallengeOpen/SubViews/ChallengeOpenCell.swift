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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        addSubviews(challengeTitleLabel, challengeTitleTextFieldView)
        NSLayoutConstraint.activate([
            challengeTitleLabel.topAnchor.constraint(equalTo: topAnchor),
            challengeTitleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            challengeTitleTextFieldView.topAnchor.constraint(equalTo: challengeTitleLabel.bottomAnchor, constant: 8),
            challengeTitleTextFieldView.leadingAnchor.constraint(equalTo: leadingAnchor),
            challengeTitleTextFieldView.trailingAnchor.constraint(equalTo: trailingAnchor),
            challengeTitleTextFieldView.heightAnchor.constraint(equalToConstant: 65)
        ])
    }
    
}

final class StarTitleLabel: UILabel {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    init(title: String) {
        super.init(frame: .zero)
        self.text = title
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        self.font = CustomFont.PretendardBold(size: .xl2).font
        self.textColor = .custom.text
        self.editTextColor(of: "*", in: .custom.main)
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
