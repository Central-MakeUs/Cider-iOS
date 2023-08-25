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
        imageView.image = UIImage(named: "mypagePig")
        return imageView
    }()

    private lazy var separtorView: UIView = {
        let view = UIView()
        view.backgroundColor = .custom.gray2
        return view
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "마이페이지"
        label.font = CustomFont.PretendardBold(size: .xl3).font
        label.textColor = .white
        return label
    }()
    
    private lazy var settingButton: UIButton = {
        let button = UIButton()
        button.setImage(
            UIImage(named: "line_setting_24")?.withRenderingMode(.alwaysOriginal).withTintColor(.white),
            for: .normal
        )
        button.heightAnchor.constraint(equalToConstant: 24).isActive = true
        button.widthAnchor.constraint(equalToConstant: 24).isActive = true
        button.addTarget(self, action: #selector(didTapSetting), for: .touchUpInside)
        return button
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
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNavigationBar()
        viewModel.viewDidLoad()
    }

}

private extension MypageViewController {

    func setUp() {
        configure()
        bind()
        setTapEvent()
    }
    
    func bind() {
        viewModel.state.receive(on: DispatchQueue.main)
            .sink { [weak self] state in
                switch state {
                case .sendData(let data):
                    self?.setData(data)
                }
            }
            .store(in: &cancellables)
    }

    func setNavigationBar() {
        self.navigationController?.navigationBar.isHidden = true
    }

    func configure() {
        view.backgroundColor = .custom.main
        view.addSubviews(roundView, characterImageView, separtorView, mypageInfoView, levelView, titleLabel, settingButton)
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            settingButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            settingButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            characterImageView.heightAnchor.constraint(equalToConstant: 158),
            characterImageView.widthAnchor.constraint(equalToConstant: 144),
            characterImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant:67),
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
    
    func setTapEvent() {
        mypageInfoView.certifyCountView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapMyCertifty)))
        mypageInfoView.heartCountView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapMyHeartChallenge)))
        mypageInfoView.myChallengeButton.addTarget(self, action: #selector(didTapMyChallenge), for: .touchUpInside)
        mypageInfoView.levelCountView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapMyLevelInfo)))
        levelView.infoButton.addTarget(self, action: #selector(didTapMyLevelInfo), for: .touchUpInside)
        mypageInfoView.writingButton.addTarget(self, action: #selector(didTapModifyProfile), for: .touchUpInside)
    }

}

private extension MypageViewController {
    
    func pushMyCertifyViewController() {
        let viewController = MyCertifyViewController(
            viewModel: MyCertifyViewModel(
                usecase: DefaultMyCertifyUsecase(
                    repository: DefaultMyCertifyRepository()
                )
            )
        )
        viewController.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    func pushMyHeartChallengeViewController() {
        let viewController = MyHeartChallengeViewController(
            viewModel: MyHeartChallengeViewModel(
                usecase: DefaultMyHeartChallengeUsecase(
                    repository: DefaultMyHeartChallengeRepository()
                )
            ), count: viewModel.data?.memberActivityInfo.myLikeChallengeNum ?? 0
        )
        viewController.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    func pushMyChallengeViewController() {
        let viewController = MyChallengeViewController(
            viewModel: MyChallengeViewModel(
                usecase: DefaultMyChallengeUsecase(
                    repository: DefaultMyChallengeRepository()
                )
            )
        )
        viewController.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    func pushMyLevelViewController() {
        let viewController = MyLevelViewController()
        viewController.modalTransitionStyle = .crossDissolve
        viewController.modalPresentationStyle = .overFullScreen
        self.present(viewController, animated: true)
    }
    
    func pushProfileModifyViewController() {
        guard let profilePath = viewModel.data?.simpleMember.profilePath,
              let nickname = viewModel.data?.simpleMember.memberName,
              let url = URL(string: profilePath) else {
            return
        }
        
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        let viewController = ProfileModifyViewController(
                            viewModel: ProfileModifyViewModel(
                                useCase: DefaultProfileModifyUsecase(
                                    repository: DefaultProfileModifyRepository()
                                ),
                                nickname: nickname,
                                profileImage: image
                            )
                        )
                        viewController.hidesBottomBarWhenPushed = true
                        self?.navigationController?.pushViewController(viewController, animated: true)
                    }
                }
            }
        }
    }
    
    func pushSettingViewController() {
        let viewController = SettingViewController()
        viewController.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    @objc func didTapMyCertifty(_ sender: Any?) {
        pushMyCertifyViewController()
    }
    
    @objc func didTapMyHeartChallenge(_ sender: Any?) {
        pushMyHeartChallengeViewController()
    }
    
    @objc func didTapMyChallenge(_ sender: Any?) {
        pushMyChallengeViewController()
    }
    
    @objc func didTapMyLevelInfo(_ sender: Any?) {
        pushMyLevelViewController()
    }
    
    @objc func didTapModifyProfile(_ sender: Any?) {
        pushProfileModifyViewController()
    }
    
    @objc func didTapSetting(_ sender: Any?) {
        pushSettingViewController()
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
