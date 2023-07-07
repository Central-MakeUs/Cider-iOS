//
//  KeywordViewController.swift
//  Cider
//
//  Created by 임영선 on 2023/07/07.
//

import UIKit

final class KeywordViewController: UIViewController {

    private let processView = ProcessView()
    
    private lazy var mainTitleLabel: UILabel = {
        let label = UILabel()
        label.font = CustomFont.PretendardBold(size: .xl5).font
        label.text = "관심 챌린지와 키워드를\n모두 선택해주세요"
        label.textColor = .custom.text
        label.setTextWithLineHeight(lineHeight: 39.2)
        label.numberOfLines = 0
        return label
    }()
    
    private let challengesView = ChallengesView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }


}


private extension KeywordViewController {
    
    func configure() {
        view.backgroundColor = .white
        processView.setProcessType(.keywordRecommendation)
        view.addSubviews(processView, mainTitleLabel, challengesView)
        NSLayoutConstraint.activate([
            processView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            processView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            processView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            mainTitleLabel.topAnchor.constraint(equalTo: processView.bottomAnchor, constant: 24),
            mainTitleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            challengesView.topAnchor.constraint(equalTo: mainTitleLabel.bottomAnchor, constant: 36),
            challengesView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            challengesView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            challengesView.heightAnchor.constraint(equalToConstant: 200)
        ])
    }
    
}

#if DEBUG
import SwiftUI

@available(iOS 13.0, *)
struct KeywordViewController_Preview: PreviewProvider {
    static var devices = ["iPhone 12", "iPhone SE", "iPhone 11 Pro Max"]

    static var previews: some View {
        ForEach(devices, id: \.self) { deviceName in
            KeywordViewController()
                .toPreview()
                .previewDevice(PreviewDevice(rawValue: deviceName))
                .previewDisplayName(deviceName)
        }
    }
}
#endif

