//
//  ServiceAgreeHeaderView.swift
//  Cider
//
//  Created by 임영선 on 2023/06/29.
//

import UIKit

final class ServiceAgreeHeaderView: UITableViewHeaderFooterView {
    
    static let identifier = "ServiceAgreeHeaderView"

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = CustomFont.PretendardBold(size: .xl5).font
        label.text = "서비스 이용에\n동의해주세요"
        label.textColor = .custom.text
        label.setTextWithLineHeight(lineHeight: 39.2)
        label.numberOfLines = 0
        return label
    }()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

private extension ServiceAgreeHeaderView {
    func configure() {
        addSubviews(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 24)
        ])
    }
}
