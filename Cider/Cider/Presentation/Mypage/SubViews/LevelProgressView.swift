//
//  LevelProgressView.swift
//  Cider
//
//  Created by 임영선 on 2023/08/11.
//

import Foundation
import UIKit

final class LevelProgressView: UIView {

    let progressWidth = UIScreen.main.bounds.width - 87

    private lazy var progressView: UIProgressView = {
        let progressView = UIProgressView()
        progressView.trackTintColor = .custom.gray4
        progressView.progress = 0
        progressView.progressTintColor = .custom.main
        return progressView
    }()

    private lazy var percentLabel: UILabel = {
        let label = UILabel()
        label.font = CustomFont.PretendardBold(size: .sm).font
        label.textColor = .white
        label.heightAnchor.constraint(equalToConstant: 21).isActive = true
        label.widthAnchor.constraint(equalToConstant: 37).isActive = true
        label.clipsToBounds = true
        label.layer.cornerRadius = 4
        label.textAlignment = .center
        return label
    }()

    private lazy var levelLabel: DynamicLabel = {
        let label = DynamicLabel(horizontalPadding: 4, verticalPadding: 2)
        label.font = CustomFont.PretendardBold(size: .sm).font
        label.clipsToBounds = true
        label.layer.cornerRadius = 4
        label.textAlignment = .center
        label.backgroundColor = .custom.lightBlue
        label.textColor = .custom.main
        return label
    }()

    init() {
        super.init(frame: .zero)
        configure()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configure() {
        addSubviews(progressView, percentLabel, levelLabel)
        NSLayoutConstraint.activate([
            progressView.centerYAnchor.constraint(equalTo: centerYAnchor),
            progressView.trailingAnchor.constraint(equalTo: trailingAnchor),
            progressView.widthAnchor.constraint(equalToConstant: progressWidth),
            progressView.heightAnchor.constraint(equalToConstant: 6),
            levelLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            levelLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            percentLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])

    }

}

extension LevelProgressView {

    func setUp(percent: Double, level: String) {
        percentLabel.backgroundColor = percent < 0.1 ? .custom.gray4 : .custom.main
        percentLabel.text = "\(Int(percent*100))%"
        levelLabel.text = level

        var progressXPoint: CGFloat {
            switch percent {
            case 0..<0.1:
                return 0

            case 0.1..<0.9:
                return self.progressWidth*CGFloat(percent) + 37/2
                
            case 0.9...1:
                return self.progressWidth*CGFloat(percent)

            default:
                return self.progressWidth*CGFloat(percent) + 37/2
            }
        }

        self.percentLabel.leadingAnchor.constraint(
            equalTo: self.leadingAnchor,
            constant: progressXPoint
        ).isActive = true

        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+0.2) {
            self.progressView.setProgress(Float(percent), animated: false)
        }
    }

}

#if DEBUG
import SwiftUI

@available(iOS 13.0, *)
struct LevelProgressView_Preview: PreviewProvider {
    static var previews: some View {

        UIViewPreview {
            let view = LevelProgressView()
            view.setUp(percent: 0.18, level: "Lv 5")
            return view
        }
        .previewLayout(.sizeThatFits)
        .padding(24)
    }
}
#endif
