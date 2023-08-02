//
//  MissionCell.swift
//  Cider
//
//  Created by 임영선 on 2023/07/28.
//

import UIKit

final class MissionCell: UICollectionViewCell {
    
    private lazy var missionInfoLabel: DynamicLabel = {
        let label = DynamicLabel(horizontalPadding: 0, verticalPadding: 8)
        label.backgroundColor = UIColor(red: 0.96, green: 0.96, blue: 0.96, alpha: 1)
        label.font = CustomFont.PretendardRegular(size: .base).font
        label.textColor = .custom.text
        label.numberOfLines = 0
        label.layer.cornerRadius = 8
        label.textAlignment = .center
        return label
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
        addSubviews(missionInfoLabel, successView, failView)
        NSLayoutConstraint.activate([
            missionInfoLabel.topAnchor.constraint(equalTo: topAnchor),
            missionInfoLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            missionInfoLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            successView.topAnchor.constraint(equalTo: missionInfoLabel.bottomAnchor, constant: 16),
            successView.centerXAnchor.constraint(equalTo: centerXAnchor),
            failView.topAnchor.constraint(equalTo: successView.bottomAnchor, constant: 8),
            failView.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
    }

}

extension MissionCell {
    
    func setUp(mission: String, successImage: UIImage?, failImage: UIImage?) {
        missionInfoLabel.text = mission
        missionInfoLabel.setTextWithLineHeight(lineHeight: 18.2)
        successView.setUp(image: successImage)
        failView.setUp(image: failImage)
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
               successImage: UIImage(named: "sample"),
               failImage: UIImage(named: "sample")
            )
            return cell
        }
        .previewLayout(.fixed(width: 150, height: 192))
        .padding(10)
    }
}
#endif
