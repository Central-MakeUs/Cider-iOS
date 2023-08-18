//
//  AccountDetailView.swift
//  Cider
//
//  Created by 임영선 on 2023/08/18.
//

import UIKit

final class AccountDetailView: UIView {
    
    private let title: String
    private let account: String
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = CustomFont.PretendardRegular(size: .lg).font
        label.textColor = .custom.text
        label.text = title
        return label
    }()
    
    private lazy var accountLabel: UILabel = {
        let label = UILabel()
        label.font = CustomFont.PretendardBold(size: .base).font
        label.textColor = .custom.text
        label.text = account
        return label
    }()
    
    init(title: String, account: String) {
        self.title = title
        self.account = account
        super.init(frame: .zero)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        self.backgroundColor = .custom.gray1
        addSubviews(titleLabel, accountLabel)
        NSLayoutConstraint.activate([
            self.heightAnchor.constraint(equalToConstant: 36),
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24),
            accountLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            accountLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24)
        ])
    }
    
}
