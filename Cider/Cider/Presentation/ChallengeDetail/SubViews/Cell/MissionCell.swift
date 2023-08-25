//
//  MissionCell.swift
//  Cider
//
//  Created by 임영선 on 2023/07/28.
//

import UIKit

final class MissionCell: UICollectionViewCell {
    
    static let identifier = "MissionCell"

    private lazy var missionInfoLabel: UILabel = {
        let label = UILabel()
        label.font = CustomFont.PretendardRegular(size: .base).font
        label.textColor = .custom.text
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    private lazy var missionBackgroundView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 8
        view.backgroundColor = UIColor(red: 0.96, green: 0.96, blue: 0.96, alpha: 1)
        return view
    }()
    
    private let successView = MissionView(type: .success)
    private let failView = MissionView(type: .fail)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        addSubviews(missionBackgroundView, missionInfoLabel, successView, failView)
        NSLayoutConstraint.activate([
            missionBackgroundView.heightAnchor.constraint(equalTo: missionInfoLabel.heightAnchor, constant: 16),
            missionInfoLabel.centerYAnchor.constraint(equalTo: missionBackgroundView.centerYAnchor),
            missionInfoLabel.centerXAnchor.constraint(equalTo: missionBackgroundView.centerXAnchor),
            missionBackgroundView.topAnchor.constraint(equalTo: topAnchor),
            missionBackgroundView.leadingAnchor.constraint(equalTo: leadingAnchor),
            missionBackgroundView.trailingAnchor.constraint(equalTo: trailingAnchor),
            successView.topAnchor.constraint(equalTo: missionInfoLabel.bottomAnchor, constant: 16),
            successView.centerXAnchor.constraint(equalTo: centerXAnchor),
            failView.topAnchor.constraint(equalTo: successView.bottomAnchor, constant: 8),
            failView.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
    }

}

extension MissionCell {
    
    func setUp(mission: String, successUrl: String, failUrl: String) {
        missionInfoLabel.text = mission
        missionInfoLabel.setTextWithLineHeight(lineHeight: 18.2)
        successView.setUp(url: successUrl)
        failView.setUp(url: failUrl)
    }
    
}

#if DEBUG
import SwiftUI

@available(iOS 13.0, *)
struct MissionCell_Preview: PreviewProvider {
    static var previews: some View {
        
        UIViewPreview {
            let cell = MissionCell()
            cell.setUp(
               mission: "하루 한번 아침에 일어나서 물이 담긴 컵사진 인증\n하루 한번 아침에 일어나서 물이 담긴 컵사진 인증",
               successUrl:"url",
               failUrl:"rul"
            )
            return cell
        }
        .previewLayout(.fixed(width: 150, height: 192))
        .padding(10)
    }
}
#endif
