//
//  CategoryView.swift
//  Cider
//
//  Created by 임영선 on 2023/07/22.
//

import UIKit

final class CategoryView: UIView {
    
    let type: ChallengeType
   
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = type.koreanName
        label.textAlignment = .center
        return label
    }()
    
    private lazy var iconImageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    init(type: ChallengeType, style: CiderSelectionStyle) {
        self.type = type
        super.init(frame: .zero)
        setStyle(style)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        addSubviews(titleLabel, iconImageView)
        NSLayoutConstraint.activate([
            self.widthAnchor.constraint(equalToConstant: 72),
            self.heightAnchor.constraint(equalToConstant: 69),
            iconImageView.widthAnchor.constraint(equalToConstant: 36),
            iconImageView.heightAnchor.constraint(equalToConstant: 36),
            iconImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            iconImageView.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: iconImageView.bottomAnchor)
        ])
        self.layer.cornerRadius = 69/2
    }
    
    func setStyle(_ style: CiderSelectionStyle) {
        switch style {
        case .selected:
            iconImageView.image = UIImage(named: type.selectedName)
            titleLabel.textColor = .white
            titleLabel.font = CustomFont.PretendardBold(size: .sm).font
            self.backgroundColor = type.color
            
        case .unselected:
            iconImageView.image = UIImage(named: type.unselectedName)
            titleLabel.textColor = .custom.gray5
            titleLabel.font = CustomFont.PretendardRegular(size: .sm).font
            self.backgroundColor = .clear
        }
    }
    
}

#if DEBUG
import SwiftUI

@available(iOS 13.0, *)
struct CategoryView_Preview: PreviewProvider {
    static var previews: some View {

        UIViewPreview {
            let view = CategoryView(type: .moneySaving, style: .selected)
            return view
        }
        .previewLayout(.fixed(width: 150, height: 192))
        .padding(100)
    }
}
#endif
