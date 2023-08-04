//
//  HostCell.swift
//  Cider
//
//  Created by 임영선 on 2023/08/03.
//

import UIKit

final class HostCell: UICollectionViewCell {
    
    static let identifier = "HostCell"

    private lazy var levelLabel: DynamicLabel = {
        let label = DynamicLabel(horizontalPadding: 4, verticalPadding: 2)
        label.font = CustomFont.PretendardBold(size: .sm).font
        label.textColor = UIColor(red: 1, green: 0.49, blue: 0, alpha: 1)
        label.backgroundColor = UIColor(red: 1, green: 0.94, blue: 0.83, alpha: 1)
        label.clipsToBounds = true
        label.layer.cornerRadius = 4
        return label
    }()
    
    private lazy var hostCountLabel: DynamicLabel = {
        let label = DynamicLabel(horizontalPadding: 4, verticalPadding: 2)
        label.font = CustomFont.PretendardBold(size: .sm).font
        label.textColor = .custom.gray5
        label.backgroundColor = .custom.gray1
        label.clipsToBounds = true
        label.layer.cornerRadius = 4
        return label
    }()
    
    private lazy var nicknameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .custom.text
        label.font = CustomFont.PretendardBold(size: .lg).font
        return label
    }()
    
    private lazy var profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.heightAnchor.constraint(equalToConstant: 44).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 44).isActive = true
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 22
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        addSubviews(levelLabel, hostCountLabel, nicknameLabel, profileImageView)
        NSLayoutConstraint.activate([
            profileImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24),
            profileImageView.topAnchor.constraint(equalTo: topAnchor, constant: 0),
            nicknameLabel.topAnchor.constraint(equalTo: profileImageView.topAnchor),
            nicknameLabel.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 8),
            levelLabel.leadingAnchor.constraint(equalTo: nicknameLabel.leadingAnchor),
            levelLabel.bottomAnchor.constraint(equalTo: profileImageView.bottomAnchor),
            hostCountLabel.leadingAnchor.constraint(equalTo: levelLabel.trailingAnchor, constant: 6),
            hostCountLabel.bottomAnchor.constraint(equalTo: levelLabel.bottomAnchor)
        ])
    }
    
}

extension HostCell {
    
    func setUp(
        nickname: String,
        levelInfo: String,
        hostCountInfo: String,
        profileImage: UIImage?
    ) {
        nicknameLabel.text = nickname
        levelLabel.text = levelInfo
        hostCountLabel.text = hostCountInfo
        profileImageView.image = profileImage
    }
    
}

#if DEBUG
import SwiftUI

@available(iOS 13.0, *)
struct HostCell_Preview: PreviewProvider {
    static var previews: some View {
        
        UIViewPreview {
            let cell = HostCell()
            cell.setUp(
                nickname: "Sun",
                levelInfo: "LV5 능숙한 챌린저",
                hostCountInfo: "0번째 챌린지",
                profileImage: UIImage(named: "sample")
            )
            return cell
        }
        .previewLayout(.fixed(width: 150, height: 192))
        .padding(10)
    }
}
#endif
