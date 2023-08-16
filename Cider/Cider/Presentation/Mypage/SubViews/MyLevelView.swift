//
//  MyLevelView.swift
//  Cider
//
//  Created by 임영선 on 2023/08/16.
//

import UIKit

final class MyLevelView: UIView {
    
    private lazy var myLevelLabel: DynamicLabel = {
        let label = DynamicLabel(horizontalPadding: 24.5, verticalPadding: 2)
        label.font = CustomFont.PretendardBold(size: .sm).font
        label.textColor = .custom.main
        label.backgroundColor = .custom.lightBlue
        label.clipsToBounds = true
        label.layer.cornerRadius = 4
        label.text = "나의 레벨"
        return label
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = CustomFont.PretendardBold(size: .xl2).font
        label.textColor = .custom.text
        label.text = "레벨별로 캐릭터가 성장해요"
        return label
    }()
    
    private lazy var smallImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 40).isActive = true
        imageView.image = UIImage(named: "Rectangle512")
        return imageView
    }()
    
    private lazy var mediumImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.heightAnchor.constraint(equalToConstant: 48).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 48).isActive = true
        imageView.image = UIImage(named: "Rectangle512")
        return imageView
    }()
    
    private lazy var largeImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.heightAnchor.constraint(equalToConstant: 60).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 60).isActive = true
        imageView.image = UIImage(named: "Rectangle512")
        return imageView
    }()
    
    private lazy var dotdotImageView1: UIImageView = {
        let imageView = UIImageView()
        imageView.heightAnchor.constraint(equalToConstant: 6).isActive = true
        imageView.image = UIImage(named: "dotdot")
        return imageView
    }()
    
    private lazy var arrowRightImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.heightAnchor.constraint(equalToConstant: 16).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 16).isActive = true
        imageView.image = UIImage(named: "arrowRight")
        return imageView
    }()
    
    private lazy var dotdotImageView2: UIImageView = {
        let imageView = UIImageView()
        imageView.heightAnchor.constraint(equalToConstant: 6).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 16).isActive = true
        imageView.image = UIImage(named: "dotdot")
        return imageView
    }()
    
    private lazy var contentLabel: UILabel = {
        let label = UILabel()
        label.font = CustomFont.PretendardBold(size: .sm).font
        label.textColor = .custom.gray5
        label.text = "레벨별 필요 경험치"
        return label
    }()
    
    private lazy var level1Label: UILabel = {
        let label = UILabel()
        label.font = CustomFont.PretendardRegular(size: .xs).font
        label.textColor = .custom.gray5
        label.text = "Lv 1"
        return label
    }()
    
    private lazy var leve61Label: UILabel = {
        let label = UILabel()
        label.font = CustomFont.PretendardRegular(size: .xs).font
        label.textColor = .custom.gray5
        label.text = "Lv 6"
        return label
    }()
    
    private let level1View = LevelUpView(level: "Lv 1", levelTitle: "시작 챌린저", experience: "1 - 999")
    private let level2View = LevelUpView(level: "Lv 2", levelTitle: "성실한 챌린저", experience: "1000 - 1999")
    private let level3View = LevelUpView(level: "Lv 3", levelTitle: "능숙한 챌린저", experience: "2000 - 2999")
    private let level4View = LevelUpView(level: "Lv 4", levelTitle: "열정적인 챌린저", experience: "3000 - 3999")
    private let level5View = LevelUpView(level: "Lv 5", levelTitle: "엘리트 챌린저", experience: "4000 - 4999")
    private let level6View = LevelUpView(level: "Lv 6", levelTitle: "엘리트 챌린저", experience: "경험치 5000 -")
    
    private lazy var levelStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        stackView.addArrangedSubviews(level1View, level2View, level3View, level4View, level5View, level6View)
        return stackView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        addSubviews(myLevelLabel, titleLabel, smallImageView, mediumImageView, largeImageView,
                    dotdotImageView1, dotdotImageView2, contentLabel, levelStackView, arrowRightImageView,
                    level1Label, leve61Label)
        NSLayoutConstraint.activate([
            myLevelLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            myLevelLabel.topAnchor.constraint(equalTo: topAnchor),
            titleLabel.topAnchor.constraint(equalTo: myLevelLabel.bottomAnchor, constant: 4),
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            smallImageView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 30),
            smallImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            dotdotImageView1.leadingAnchor.constraint(equalTo: smallImageView.trailingAnchor, constant: 6),
            dotdotImageView1.centerYAnchor.constraint(equalTo: smallImageView.centerYAnchor),
            mediumImageView.centerYAnchor.constraint(equalTo: smallImageView.centerYAnchor),
            mediumImageView.leadingAnchor.constraint(equalTo: dotdotImageView1.trailingAnchor, constant: 6),
            dotdotImageView2.leadingAnchor.constraint(equalTo: mediumImageView.trailingAnchor, constant: 6),
            dotdotImageView2.centerYAnchor.constraint(equalTo: smallImageView.centerYAnchor),
            arrowRightImageView.leadingAnchor.constraint(equalTo: dotdotImageView2.trailingAnchor, constant: 2),
            arrowRightImageView.centerYAnchor.constraint(equalTo: smallImageView.centerYAnchor),
            largeImageView.centerYAnchor.constraint(equalTo: smallImageView.centerYAnchor),
            largeImageView.leadingAnchor.constraint(equalTo: arrowRightImageView.trailingAnchor, constant: 4),
            level1Label.centerXAnchor.constraint(equalTo: smallImageView.centerXAnchor),
            leve61Label.centerXAnchor.constraint(equalTo: largeImageView.centerXAnchor),
            leve61Label.topAnchor.constraint(equalTo: largeImageView.bottomAnchor, constant: 2),
            level1Label.topAnchor.constraint(equalTo: leve61Label.topAnchor),
            contentLabel.topAnchor.constraint(equalTo: leve61Label.bottomAnchor, constant: 20),
            contentLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            levelStackView.topAnchor.constraint(equalTo: contentLabel.bottomAnchor, constant: 8),
            levelStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            levelStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            levelStackView.heightAnchor.constraint(equalToConstant: 254)
            
            
        ])
    }
    
    
}

final class LevelUpView: UIView {
    
    private let level: String
    private let levelTitle: String
    private let experience: String
    
    private lazy var levelLabel: UILabel = {
        let label = UILabel()
        label.font = CustomFont.PretendardBold(size: .sm).font
        label.textColor = .custom.gray5
        label.text = level
        return label
    }()
    
    private lazy var levelTitleLabel: UILabel = {
        let label = UILabel()
        label.font = CustomFont.PretendardBold(size: .base).font
        label.textColor = .custom.gray6
        label.text = levelTitle
        return label
    }()
    
    private lazy var experienceLabel: UILabel = {
        let label = UILabel()
        label.font = CustomFont.PretendardRegular(size: .sm).font
        label.textColor = .custom.gray7
        label.text = experience
        return label
    }()
    
    private lazy var iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.heightAnchor.constraint(equalToConstant: 16).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 16).isActive = true
        imageView.image = UIImage(named: "line_certificate_16")
        return imageView
    }()
    
    init(level: String, levelTitle: String, experience: String) {
        self.level = level
        self.levelTitle = levelTitle
        self.experience = experience
        super.init(frame: .zero)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        self.backgroundColor = .custom.gray1
        self.layer.cornerRadius = 4
        addSubviews(levelLabel, levelTitleLabel, experienceLabel, iconImageView)
        NSLayoutConstraint.activate([
            self.heightAnchor.constraint(equalToConstant: 39),
            iconImageView.topAnchor.constraint(equalTo: topAnchor, constant: 2),
            iconImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 4),
            levelLabel.topAnchor.constraint(equalTo: iconImageView.topAnchor),
            levelLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor),
            levelTitleLabel.leadingAnchor.constraint(equalTo: iconImageView.leadingAnchor),
            levelTitleLabel.topAnchor.constraint(equalTo: levelLabel.bottomAnchor, constant: 1),
            experienceLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -4),
            experienceLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
}

#if DEBUG
import SwiftUI

@available(iOS 13.0, *)
struct MyLevelView_Preview: PreviewProvider {
    static var previews: some View {
        
        UIViewPreview {
            let view = MyLevelView()
            return view
        }
        .previewLayout(.fixed(width: 150, height: 192))
        .padding(50)
    }
}
#endif
