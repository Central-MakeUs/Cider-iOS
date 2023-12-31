//
//  ChallengeCompleteViewController.swift
//  Cider
//
//  Created by 임영선 on 2023/07/20.
//

import UIKit

final class ChallengeCompleteViewController: UIViewController {

    private let titleLabel = MainTitleLabel(title: "챌린지 신청이\n완료되었습니다")
    
    private lazy var iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "challenge")
        return imageView
    }()
    
    private let reviewInfoView = ReviewInfoView(titles: [
        "·   심사는 최소 1일에서 최대 7일까지 소요되어요",
        "·   규칙에 어긋나는 내용이 있을시 반려될 수 있어요"
    ])
    
    private lazy var bottomButton: CiderBottomButton = {
        let button = CiderBottomButton(style: .enabled, title: "돌아가기")
        button.addTarget(self, action: #selector(didTapNextButton), for: .touchUpInside)
        return button
    }()
    
    private lazy var homeButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "line_home_24"), for: .normal)
        button.addTarget(self, action: #selector(didTapNextButton), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNavigationBar()
    }

}

private extension ChallengeCompleteViewController {
    
    func setUp() {
        configure()
    }
    
    func configure() {
        view.backgroundColor = .white
        view.addSubviews(titleLabel, iconImageView, reviewInfoView, bottomButton)
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 52),
            iconImageView.heightAnchor.constraint(equalToConstant: 150),
            iconImageView.widthAnchor.constraint(equalToConstant: 150),
            iconImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            iconImageView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor ,constant: 54),
            bottomButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            bottomButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            bottomButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            reviewInfoView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            reviewInfoView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            reviewInfoView.bottomAnchor.constraint(equalTo: bottomButton.topAnchor, constant: -12),
            reviewInfoView.heightAnchor.constraint(equalToConstant: 88)
        ])
    }
    
    func setNavigationBar() {
        self.navigationItem.hidesBackButton = true
        self.navigationController?.navigationBar.topItem?.title = ""
        self.navigationItem.title = "챌린지 신청 완료"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: homeButton)
    }
    
}

private extension ChallengeCompleteViewController {
    
    @objc func didTapNextButton(_ sender: Any?) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
}


#if DEBUG
import SwiftUI

@available(iOS 13.0, *)
struct ChallengeCompleteViewController_Preview: PreviewProvider {
    static var devices = ["iPhone 12", "iPhone SE", "iPhone 11 Pro Max"]

    static var previews: some View {
        ForEach(devices, id: \.self) { deviceName in
            ChallengeCompleteViewController()
            .toPreview()
            .previewDevice(PreviewDevice(rawValue: deviceName))
            .previewDisplayName(deviceName)
        }
    }
}
#endif
