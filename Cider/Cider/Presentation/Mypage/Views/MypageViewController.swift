//
//  MypageViewController.swift
//  Cider
//
//  Created by 임영선 on 2023/08/11.
//

import UIKit

final class MypageViewController: UIViewController {

    private lazy var roundView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 12
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        return view
    }()

    private lazy var characterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "Rectangle512")
        return imageView
    }()

    private lazy var separtorView: UIView = {
        let view = UIView()
        view.backgroundColor = .custom.gray2
        return view
    }()

    private let mypageInfoView = MypageInfoView()
    private let levelView = LevelView()

    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNavigationBar()
    }

}

private extension MypageViewController {

    func setUp() {
        configure()
        setData()
    }

    func setNavigationBar() {
        self.navigationController?.navigationBar.topItem?.title = ""
        self.navigationItem.title = "마이페이지"
        self.navigationController?.navigationBar.scrollEdgeAppearance?.shadowColor = .clear
        self.navigationController?.navigationBar.standardAppearance.shadowColor = .clear
        setNavigationBar(
            backgroundColor: .custom.main,
            tintColor: .white
        )
    }

    func configure() {
        view.backgroundColor = .custom.main
        view.addSubviews(roundView, characterImageView, separtorView, mypageInfoView, levelView)
        NSLayoutConstraint.activate([
            characterImageView.heightAnchor.constraint(equalToConstant: 144),
            characterImageView.widthAnchor.constraint(equalToConstant: 144),
            characterImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 23),
            characterImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            roundView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            roundView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            roundView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            roundView.topAnchor.constraint(equalTo: characterImageView.bottomAnchor, constant: 51),
            mypageInfoView.leadingAnchor.constraint(equalTo: roundView.leadingAnchor),
            mypageInfoView.topAnchor.constraint(equalTo: roundView.topAnchor),
            mypageInfoView.trailingAnchor.constraint(equalTo: roundView.trailingAnchor),
            mypageInfoView.heightAnchor.constraint(equalToConstant: 207),
            separtorView.heightAnchor.constraint(equalToConstant: 8),
            separtorView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            separtorView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            separtorView.topAnchor.constraint(equalTo: mypageInfoView.bottomAnchor, constant: 3),
            levelView.topAnchor.constraint(equalTo: separtorView.bottomAnchor, constant: 24),
            levelView.leadingAnchor.constraint(equalTo: roundView.leadingAnchor),
            levelView.trailingAnchor.constraint(equalTo: roundView.trailingAnchor),
            levelView.heightAnchor.constraint(equalToConstant: 140)
        ])
    }

    func setData() {
        mypageInfoView.setUp(
            profileURL: "https://cider-bucket.s3.ap-northeast-2.amazonaws.com/profile/30_6f9e33e8-9f25-4849-8abb-229e67455f9c_Cider5.jpeg",
            nickname: "혁신적인주식호랑이",
            levelText: "Lv 5 엘리트 챌린저",
            particiationText: "0번째 챌린지",
            levelCount: "Lv 1",
            certifyCount: "5",
            heartCount: "11"
        )
        levelView.setUp(
            percent: 0.2,
            experience: "남은 경험치 234",
            level: "Lv 1",
            currentLevel: "LV 5 능숙한 챌린저",
            nextLevel: "LV 6 대단한 챌린저"
        )
    }

}

#if DEBUG
import SwiftUI

@available(iOS 13.0, *)
struct MypageViewController_Preview: PreviewProvider {
    static var devices = ["iPhone 12", "iPhone SE", "iPhone 11 Pro Max"]

    static var previews: some View {
        ForEach(devices, id: \.self) { deviceName in
            MypageViewController()
                .toPreview()
                .previewDevice(PreviewDevice(rawValue: deviceName))
                .previewDisplayName(deviceName)
        }
    }
}
#endif
