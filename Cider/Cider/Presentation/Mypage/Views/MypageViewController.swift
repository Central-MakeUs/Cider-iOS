//
//  MypageViewController.swift
//  Cider
//
//  Created by 임영선 on 2023/08/11.
//

import UIKit
import Combine

final class MypageViewController: UIViewController {

    private var cancellables: Set<AnyCancellable> = .init()
    private let viewModel: MypageViewModel

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

    init(viewModel: MypageViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
        viewModel.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNavigationBar()
    }

}

private extension MypageViewController {

    func setUp() {
        configure()
        bind()
    }
    
    func bind() {
        viewModel.state.receive(on: DispatchQueue.main)
            .sink { [weak self] state in
                switch state {
                case .sendData(let data):
                    print(data)
                    self?.setData(data)
                }
            }
            .store(in: &cancellables)
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

    func setData(_ data: MypageResponse) {
        mypageInfoView.setUp(
            profileURL: data.simpleMember.profilePath,
            nickname: data.simpleMember.memberName,
            levelText: data.simpleMember.memberLevelName,
            particiationText: "\(data.simpleMember.participateChallengeNum)번째 챌린지",
            levelCount: "Lv \(data.memberActivityInfo.myLevel)",
            certifyCount: String(data.memberActivityInfo.myCertifyNum),
            heartCount: String(data.memberActivityInfo.myLikeChallengeNum)
        )
        levelView.setUp(
            percent: Float(data.memberLevelInfo.levelPercent)*0.01,
            experience: "남은 경험치 \(data.memberLevelInfo.experienceLeft)",
            level: "Lv \(data.memberLevelInfo.myLevel)",
            currentLevel: "LV \(data.memberLevelInfo.currentLevel.level) \(data.memberLevelInfo.currentLevel.levelName)",
            nextLevel: "LV \(data.memberLevelInfo.nextLevel.level) \(data.memberLevelInfo.nextLevel.levelName)"
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
            MypageViewController(
                viewModel: MypageViewModel(
                    usecase: DefaultMypageUsecase(
                        repository: DefaultMypageRepository()
                    )
                )
            )
                .toPreview()
                .previewDevice(PreviewDevice(rawValue: deviceName))
                .previewDisplayName(deviceName)
        }
    }
}
#endif
