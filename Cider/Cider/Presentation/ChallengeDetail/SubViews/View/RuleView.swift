//
//  RuleView.swift
//  Cider
//
//  Created by 임영선 on 2023/07/28.
//

import UIKit

enum RuleStyle {
    case fail
    case mission
    
    var info: String {
        switch self {
        case .fail:
            return "실패 기준"
        case .mission:
            return "인증 방법"
        }
    }

}

final class RuleView: UIView {
    
    private let style: RuleStyle
    
    init(_ style: RuleStyle) {
        self.style = style
        super.init(frame: .zero)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = CustomFont.PretendardBold(size: .lg).font
        label.textColor = .custom.text
        label.text = style == .fail ? "" : "실시간 사진촬영"
        return label
    }()
    
    private lazy var infoLabel: UILabel = {
        let label = UILabel()
        label.font = CustomFont.PretendardBold(size: .sm).font
        label.textColor = .custom.gray7
        label.text = style.info
        label.textColor = style == .fail ? .custom.error : .custom.main
        label.text = style == .fail ? "실패 기준" : "인증 방법"
        return label
    }()
    
    private lazy var miniImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.heightAnchor.constraint(equalToConstant: 16).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 16).isActive = true
        imageView.image = UIImage(named: style == .fail ? "line_deletebox_16" : "line_cam_16")?.withRenderingMode(.alwaysTemplate)
        imageView.tintColor = style == .fail ? .custom.error : .custom.main
        return imageView
    }()
    
    private lazy var bigImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.heightAnchor.constraint(equalToConstant: 24).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 24).isActive = true
        imageView.image = UIImage(named: style == .fail ? "line_delete_24" : "filled_cam_24")?.withRenderingMode(.alwaysTemplate)
        imageView.tintColor = style == .fail ? .custom.error : .custom.main
        return imageView
    }()
    
    private lazy var circleView: UIView = {
        let view = UIView()
        view.heightAnchor.constraint(equalToConstant: 40).isActive = true
        view.widthAnchor.constraint(equalToConstant: 40).isActive = true
        view.clipsToBounds = true
        view.layer.cornerRadius = 20
        view.backgroundColor = style == .fail ? UIColor(red: 1, green: 0.98,  blue: 0.98, alpha: 1) : UIColor(red: 0.95, green: 0.98, blue: 1, alpha: 1)
        view.layer.borderColor = style == .fail ? UIColor(red: 1, green: 0.87, blue: 0.87, alpha: 1).cgColor : UIColor(red: 0.87, green: 0.95, blue: 1, alpha: 1).cgColor
        view.layer.borderWidth = 2
        return view
    }()
    
    private func configure() {
        self.backgroundColor = .custom.gray1
        self.layer.cornerRadius = 4
        addSubviews(titleLabel, infoLabel, circleView, miniImageView, bigImageView)
        NSLayoutConstraint.activate([
            circleView.centerYAnchor.constraint(equalTo: centerYAnchor),
            circleView.centerXAnchor.constraint(equalTo: centerXAnchor),
            miniImageView.centerXAnchor.constraint(equalTo: centerXAnchor, constant: -23),
            miniImageView.centerYAnchor.constraint(equalTo: infoLabel.centerYAnchor),
            infoLabel.bottomAnchor.constraint(equalTo: circleView.topAnchor, constant: -8),
            infoLabel.leadingAnchor.constraint(equalTo: miniImageView.trailingAnchor, constant: 2),
            bigImageView.centerXAnchor.constraint(equalTo: circleView.centerXAnchor),
            bigImageView.centerYAnchor.constraint(equalTo: circleView.centerYAnchor),
            titleLabel.topAnchor.constraint(equalTo: circleView.bottomAnchor, constant: 8),
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
    }
    
    
}


extension RuleView {
    
    func setUp(title: String) {
        titleLabel.text = title
    }
    
}

#if DEBUG
import SwiftUI

@available(iOS 13.0, *)
struct RuleView_Preview: PreviewProvider {
    static var previews: some View {
        
        UIViewPreview {
            let view = RuleView(.fail)
            return view
        }
        .previewLayout(.fixed(width: 150, height: 192))
        .padding(100)
    }
}
#endif
