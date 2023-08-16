//
//  LevelView.swift
//  Cider
//
//  Created by 임영선 on 2023/08/11.
//

import UIKit

final class LevelView: UIView {

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = CustomFont.PretendardBold(size: .xl2).font
        label.textColor = .custom.text
        return label
    }()

    lazy var infoButton: UIButton = {
        let button = UIButton()
        button.heightAnchor.constraint(equalToConstant: 24).isActive = true
        button.widthAnchor.constraint(equalToConstant: 24).isActive = true
        button.setImage(UIImage(named: "line_info_24"), for: .normal)
        return button
    }()

    private let levelProgressView = LevelProgressView()

    private lazy var experienceLabel: UILabel = {
        let label = UILabel()
        label.font = CustomFont.PretendardBold(size: .sm).font
        label.textColor = .custom.gray5
        return label
    }()

    private lazy var currentTextLabel: UILabel = {
        let label = UILabel()
        label.font = CustomFont.PretendardBold(size: .xs).font
        label.textColor = .custom.gray6
        label.text = "현재 레벨"
        return label
    }()

    private lazy var nextTextLabel: UILabel = {
        let label = UILabel()
        label.font = CustomFont.PretendardBold(size: .xs).font
        label.textColor = .custom.gray6
        label.text = "다음 레벨"
        return label
    }()

    private lazy var currentLevelLabel: UILabel = {
        let label = UILabel()
        label.font = CustomFont.PretendardBold(size: .sm).font
        label.textColor = .custom.gray7
        return label
    }()

    private lazy var nextLevelLabel: UILabel = {
        let label = UILabel()
        label.font = CustomFont.PretendardBold(size: .sm).font
        label.textColor = .custom.gray7
        return label
    }()

    private lazy var grayView: UIView = {
        let view = UIView()
        view.backgroundColor = .custom.gray1
        view.layer.cornerRadius = 8
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configure() {
        addSubviews(titleLabel, infoButton, levelProgressView, experienceLabel,
                    grayView, currentTextLabel, nextTextLabel, currentLevelLabel, nextLevelLabel)
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24),
            infoButton.topAnchor.constraint(equalTo: topAnchor),
            infoButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24),
            levelProgressView.heightAnchor.constraint(equalToConstant: 21),
            levelProgressView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24),
            levelProgressView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24),
            levelProgressView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 24),
            experienceLabel.topAnchor.constraint(equalTo: levelProgressView.bottomAnchor, constant: 8),
            experienceLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24),
            grayView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24),
            grayView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24),
            grayView.heightAnchor.constraint(equalToConstant: 71),
            grayView.topAnchor.constraint(equalTo: experienceLabel.bottomAnchor, constant: 8),
            currentLevelLabel.leadingAnchor.constraint(equalTo: grayView.leadingAnchor, constant: 33),
            currentLevelLabel.bottomAnchor.constraint(equalTo: grayView.bottomAnchor, constant: -18),
            currentTextLabel.topAnchor.constraint(equalTo: grayView.topAnchor, constant: 18),
            currentTextLabel.centerXAnchor.constraint(equalTo: currentLevelLabel.centerXAnchor),
            nextLevelLabel.trailingAnchor.constraint(equalTo: grayView.trailingAnchor, constant: -33),
            nextLevelLabel.bottomAnchor.constraint(equalTo: grayView.bottomAnchor, constant: -18),
            nextTextLabel.topAnchor.constraint(equalTo: grayView.topAnchor, constant: 18),
            nextTextLabel.centerXAnchor.constraint(equalTo: nextLevelLabel.centerXAnchor)
        ])
    }
    
    private func getTitleMessage(_ percent: Int) -> String {
        switch percent {
        case 0...20:
            return "좋은 시작이에요!"
        case 21...40:
            return "꾸준히 발전하고 있어요. 계속 나아가세요!"
        case 41...60:
            return "잘하고 있어요. 힘내세요!"
        case 61...80:
            return "거의 다 왔어요. 조금만 더 화이팅!"
        case 81...100:
            return "마지막 구간이에요. 한 걸음만 더 화이팅!"
        default:
            return ""
        }
    }

}

extension LevelView {

    func setUp(
        percent: Float,
        experience: String,
        level: String,
        currentLevel: String,
        nextLevel: String
    ) {
        levelProgressView.setUp(percent: percent, level: level)
        experienceLabel.text = experience
        currentLevelLabel.text = currentLevel
        nextLevelLabel.text = nextLevel
        titleLabel.text = getTitleMessage(Int(percent*100))
    }

}


#if DEBUG
import SwiftUI

@available(iOS 13.0, *)
struct LevelView_Preview: PreviewProvider {
    static var previews: some View {

        UIViewPreview {
            let view = LevelView()
            view.setUp(
                percent: 0.5,
                experience: "남은 경험치 234",
                level: "Lv 1",
                currentLevel: "LV 5 능숙한 챌린저",
                nextLevel: "LV 6 대단한 챌린저"
            )
            return view
        }
        .previewLayout(.sizeThatFits)
        .padding(50)
    }
}
#endif
