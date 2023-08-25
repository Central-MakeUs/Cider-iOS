//
//  CertifyCell.swift
//  Cider
//
//  Created by 임영선 on 2023/08/10.
//

import UIKit

final class CertifyCell: UICollectionViewCell {
    
    static let identifier = "CertifyCell"
    
    private lazy var challengeNameLabel: UILabel = {
        let label = UILabel()
        label.text = "챌린지 이름"
        label.font = CustomFont.PretendardBold(size: .xl2).font
        label.textColor = .custom.text
        return label
    }()
    
    private lazy var photoSubTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "최소 1개 이상의 사진을 첨부해주세요"
        label.font = CustomFont.PretendardBold(size: .base).font
        label.textColor = .custom.icon
        return label
    }()
    
    private let certifyPhotoLabel = StarTitleLabel(
        title: "인증 사진 *"
    )
    
    private let titleLabel = StarTitleLabel(
        title: "제목 *"
    )
    
    private let contentLabel = StarTitleLabel(
        title: "내용 *"
    )
    
    let titleTextFieldView: CiderTextFieldView = {
        let view = CiderTextFieldView(minLength: 5, maxLength: 30, notificationName: .didChangedCiderTextField)
        view.setPlaceHoder("오늘 인증 완료!")
        return view
    }()
    
    let contentTextView = CiderTextView(
        minLength: 0,
        maxLength: 500,
        placeHolder: "인증에 대한 이야기와 다양한 생각들, 사진에 대한 설명을 작성해보세요!"
    )
    
    let challengeSelectionView = ChallengeSelectionView()
    
    private lazy var backView: UIView = {
        let view = UIView()
        view.backgroundColor = .black.withAlphaComponent(0.03)
        view.widthAnchor.constraint(equalToConstant: 80).isActive = true
        view.heightAnchor.constraint(equalToConstant: 80).isActive = true
        view.layer.cornerRadius = 4
        return view
    }()
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.isHidden = true
        imageView.layer.cornerRadius = 4
        imageView.contentMode = .scaleAspectFill
        imageView.widthAnchor.constraint(equalToConstant: 80).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 80).isActive = true
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private lazy var caemeraStackView: UIStackView = {
        let stackView = UIStackView(
            axis: .vertical,
            alignment: .fill,
            distribution: .fillEqually,
            spacing: 0
        )
        stackView.addArrangedSubviews(cameraImageView, cameraLabel)
        stackView.isUserInteractionEnabled = false
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
        label.text = "0/1"
        label.textColor = .custom.gray5
        label.font = CustomFont.PretendardRegular(size: .base).font
        label.textAlignment = .center
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        addSubviews(challengeNameLabel, challengeSelectionView, certifyPhotoLabel, backView, caemeraStackView, imageView,
                    titleLabel, titleTextFieldView, contentLabel, contentTextView, photoSubTitleLabel)
        NSLayoutConstraint.activate([
            challengeNameLabel.topAnchor.constraint(equalTo: topAnchor, constant: 24),
            challengeNameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24),
            challengeSelectionView.topAnchor.constraint(equalTo: challengeNameLabel.bottomAnchor, constant: 8),
            challengeSelectionView.leadingAnchor.constraint(equalTo: challengeNameLabel.leadingAnchor),
            challengeSelectionView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24),
            certifyPhotoLabel.topAnchor.constraint(equalTo: challengeSelectionView.bottomAnchor, constant: 24),
            certifyPhotoLabel.leadingAnchor.constraint(equalTo: challengeNameLabel.leadingAnchor),
            photoSubTitleLabel.centerYAnchor.constraint(equalTo: certifyPhotoLabel.centerYAnchor),
            photoSubTitleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24),
            backView.topAnchor.constraint(equalTo: certifyPhotoLabel.bottomAnchor, constant: 16),
            backView.leadingAnchor.constraint(equalTo: challengeNameLabel.leadingAnchor),
            imageView.topAnchor.constraint(equalTo: certifyPhotoLabel.bottomAnchor, constant: 8),
            imageView.leadingAnchor.constraint(equalTo: challengeNameLabel.leadingAnchor),
            caemeraStackView.centerYAnchor.constraint(equalTo: backView.centerYAnchor),
            caemeraStackView.centerXAnchor.constraint(equalTo: backView.centerXAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: challengeNameLabel.leadingAnchor),
            titleLabel.topAnchor.constraint(equalTo: caemeraStackView.bottomAnchor, constant: 36),
            titleTextFieldView.leadingAnchor.constraint(equalTo: challengeNameLabel.leadingAnchor),
            titleTextFieldView.trailingAnchor.constraint(equalTo: challengeSelectionView.trailingAnchor),
            titleTextFieldView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            titleTextFieldView.heightAnchor.constraint(equalToConstant: 65),
            contentLabel.leadingAnchor.constraint(equalTo: challengeNameLabel.leadingAnchor),
            contentLabel.topAnchor.constraint(equalTo: titleTextFieldView.bottomAnchor, constant: 24),
            contentTextView.topAnchor.constraint(equalTo: contentLabel.bottomAnchor, constant: 8),
            contentTextView.leadingAnchor.constraint(equalTo: challengeSelectionView.leadingAnchor),
            contentTextView.trailingAnchor.constraint(equalTo: challengeSelectionView.trailingAnchor),
            contentTextView.heightAnchor.constraint(equalToConstant: 171),
            contentTextView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10)
        ])
    }
    
    func setCameraImage(_ image: UIImage?) {
        imageView.isHidden = false
        imageView.image = image
    }
    
    func addTapGestureCameraView(_ target: Any?, action: Selector) {
        backView.addGestureRecognizer(UITapGestureRecognizer(target: target, action: action))
    }
    
}

#if DEBUG
import SwiftUI

@available(iOS 13.0, *)
struct CertifyCell_Preview: PreviewProvider {
    static var previews: some View {
        
        UIViewPreview {
            let cell = CertifyCell()
            return cell
        }
        .previewLayout(.sizeThatFits)
        .padding(10)
    }
}
#endif
