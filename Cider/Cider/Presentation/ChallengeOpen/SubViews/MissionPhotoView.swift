//
//  MissionPhotoView.swift
//  Cider
//
//  Created by 임영선 on 2023/07/13.
//

import UIKit

final class MissionPhotoView: UIView {
    
    private let type: MissionType
    
    private let stackViewHeight = (UIScreen.main.bounds.width-48)/2-5
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = type == .success ? "인증 성공 사진 예시를 올려주세요" : "인증 실패 사진 예시를 올려주세요"
        label.textColor = type == .success ? .custom.main : .custom.text
        label.font = CustomFont.PretendardBold(size: .base).font
        return label
    }()
    
    private lazy var iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: type == .success ? "line_check_16" : "line_caution_16")
        imageView.heightAnchor.constraint(equalToConstant: 16).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 16).isActive = true
        return imageView
    }()
    
    private lazy var backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .black.withAlphaComponent(0.03)
        view.widthAnchor.constraint(equalToConstant: stackViewHeight).isActive = true
        view.heightAnchor.constraint(equalToConstant: stackViewHeight).isActive = true
        view.layer.cornerRadius = 4
        return view
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(
            axis: .vertical,
            alignment: .fill,
            distribution: .fillEqually,
            spacing: 0
        )
        stackView.addArrangedSubviews(cameraImageView, cameraLabel)
        return stackView
    }()
    
    private lazy var cameraImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "line_cam_24")
        imageView.heightAnchor.constraint(equalToConstant: 24).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 24).isActive = true
        return imageView
    }()
    
    private lazy var cameraLabel: UILabel = {
        let label = UILabel()
        label.text = "0/2"
        label.textColor = .custom.gray5
        label.font = CustomFont.PretendardRegular(size: .base).font
        label.textAlignment = .center
        return label
    }()
    
    init(type: MissionType) {
        self.type = type
        super.init(frame: .zero)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        addSubviews(iconImageView, titleLabel, backgroundView, stackView)
        NSLayoutConstraint.activate([
            self.heightAnchor.constraint(equalToConstant: stackViewHeight+34),
            iconImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            iconImageView.topAnchor.constraint(equalTo: topAnchor),
            titleLabel.topAnchor.constraint(equalTo: topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 4),
            backgroundView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 19),
            backgroundView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.centerYAnchor.constraint(equalTo: backgroundView.centerYAnchor),
            stackView.centerXAnchor.constraint(equalTo: backgroundView.centerXAnchor)
        ])
    }
    
}


#if DEBUG
import SwiftUI

@available(iOS 13.0, *)
struct MissionPhotoView_Preview: PreviewProvider {
    static var previews: some View {
            
        UIViewPreview {
            let view = MissionPhotoView(type: .success)
            return view
        }
        .previewLayout(.sizeThatFits)
        .padding(10)
    }
}
#endif
