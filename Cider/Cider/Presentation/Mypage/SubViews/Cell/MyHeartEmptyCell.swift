//
//  MyHeartEmptyCell.swift
//  Cider
//
//  Created by 임영선 on 2023/08/22.
//

import UIKit

final class MyHeartEmptyCell: UICollectionViewCell {
    
    static let identifier = "MyHeartEmptyCell"
    
    private let emptyStateView = EmptyStateView(mainTitle: "관심을 누른 챌린지가 없습니다", subTitle: "마음에 드는 챌린지가 없나요?\n직접 챌린지를 만들어보세요")
    
    lazy var bottomButton: UIButton = {
        let button = UIButton()
        button.heightAnchor.constraint(equalToConstant: 44).isActive = true
        button.widthAnchor.constraint(equalToConstant: 134).isActive = true
        button.backgroundColor = .custom.main
        button.layer.cornerRadius = 4
        button.setImage(UIImage(named: "line_arrow-right_16")?.withTintColor(.white), for: .normal)
        button.semanticContentAttribute = .forceRightToLeft
        button.setPreferredSymbolConfiguration(.init(scale: .small), forImageIn: .normal)
        button.setTitle("챌린지 만들기", for: .normal)
        button.titleLabel?.font = CustomFont.PretendardBold(size: .base).font
        button.setTitleColor(.white, for: .normal)
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
        self.backgroundColor = .custom.gray3
        addSubviews(emptyStateView, bottomButton)
        NSLayoutConstraint.activate([
            emptyStateView.centerXAnchor.constraint(equalTo: centerXAnchor),
            emptyStateView.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -50),
            bottomButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            bottomButton.topAnchor.constraint(equalTo: emptyStateView.bottomAnchor, constant: 16)
        ])
    }
}

