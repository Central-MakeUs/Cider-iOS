//
//  ReviewStatusView.swift
//  Cider
//
//  Created by 임영선 on 2023/07/26.
//

import UIKit

enum ReviewStyle {
    case none
    case done
    case success
}

final class ReviewStatusView: UIView {
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    init(style: ReviewStyle, title: String) {
        super.init(frame: .zero)
        cofigure()
        setStyle(style)
        titleLabel.text = title
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func cofigure() {
        layer.cornerRadius = 10
        layer.borderWidth = 0.5
        addSubviews(titleLabel)
        NSLayoutConstraint.activate([
            self.heightAnchor.constraint(equalToConstant: 20),
            self.widthAnchor.constraint(equalToConstant: 58),
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
    }
    
    func setStyle(_ style: ReviewStyle) {
        switch style {
        case .none:
            self.backgroundColor = .white
            titleLabel.font = CustomFont.PretendardRegular(size: .lg).font
            titleLabel.textColor = .custom.gray5
            self.layer.borderColor = UIColor.custom.gray2?.cgColor
            
        case .done:
            self.backgroundColor = .custom.gray5
            titleLabel.font = CustomFont.PretendardRegular(size: .lg).font
            titleLabel.textColor = .white
            self.layer.borderColor = UIColor.custom.gray2?.cgColor
            
        case .success:
            self.backgroundColor = .custom.main
            titleLabel.font = CustomFont.PretendardBold(size: .lg).font
            titleLabel.textColor = .white
            self.layer.borderColor = UIColor.custom.main?.cgColor
        }
    }
    
}
