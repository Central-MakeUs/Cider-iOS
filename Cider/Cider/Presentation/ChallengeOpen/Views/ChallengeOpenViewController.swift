//
//  ChallengeOpenViewController.swift
//  Cider
//
//  Created by 임영선 on 2023/07/11.
//

import UIKit
import Combine

final class ChallengeOpenViewController: UIViewController {
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        collectionView.register(ChallengeOpenCell.self, forCellWithReuseIdentifier: ChallengeOpenCell.identifier)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.keyboardDismissMode = .onDrag
        return collectionView
    }()
    
    private lazy var bottomButton: CiderBottomButton = {
        let button = CiderBottomButton(style: .disabled, title: "챌린지 개설 신청하기")
        button.addTarget(self, action: #selector(didTapNextButton), for: .touchUpInside)
        return button
    }()

    private let viewModel: ChallengeOpenViewModel
    private var cancellables = Set<AnyCancellable>()
    
    private let challengeType: ChallengeType
    
    private var dataSource: UICollectionViewDiffableDataSource<Section, Item>?
    
    private var failImage = UIImage()
    private var successImage = UIImage()
    private var missionType: ChallengeResultType?
    
    init(challengeType: ChallengeType, viewModel: ChallengeOpenViewModel) {
        self.challengeType = challengeType
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        viewModel.selectChallengeType(challengeType)
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
    }
    
}

private extension ChallengeOpenViewController {
    
    func setUp() {
        configure()
        setUpDataSource()
        applySnapshot()
        bind()
        setNotificationCenter()
    }
    
    func setNotificationCenter() {
        NotificationCenter.default.publisher(for: .selectImage)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] notification in
                guard let self = self else {
                    return
                }
                guard let image = notification.object as? UIImage else {
                    return
                }
                
                guard let missionType = self.missionType else {
                    return
                }
                if missionType == .success {
                    successImage = image
                    viewModel.selectSuccessImage(image)
                } else {
                    failImage = image
                    viewModel.selectFailImage(image)
                }
                self.applySnapshot()
            }
            .store(in: &cancellables)
    }
    
    func bind() {
        viewModel.state.receive(on: DispatchQueue.main)
            .sink { [weak self] state in
                switch state {
                case .changeNextButtonState(let isEnabled):
                    self?.bottomButton.setStyle(isEnabled ? .enabled : .disabled)
                case .pushPrecautionViewController(let request, let successData, let failData):
                    self?.pushPrecautionViewController(request: request, successData: successData, failData: failData)
                }
            }
            .store(in: &cancellables)
    }
    
    func configure() {
        view.backgroundColor = .white
        view.addSubviews(collectionView, bottomButton)
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            collectionView.bottomAnchor.constraint(equalTo: bottomButton.topAnchor),
            bottomButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            bottomButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            bottomButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20)
        ])
    }
    
    func setNavigationBar() {
        self.navigationController?.navigationBar.topItem?.title = ""
        self.navigationItem.title = "챌린지 개설"
        setNavigationBar(backgroundColor: .white, tintColor: .black, shadowColor: .clear)
    }
    
    func setUpDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, Item>(collectionView: collectionView, cellProvider: { [weak self] collectionView, indexPath, itemIdentifier in
            guard let self = self else {
                return UICollectionViewCell()
            }
            
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ChallengeOpenCell.identifier, for: indexPath) as? ChallengeOpenCell else {
                return UICollectionViewCell()
            }
            cell.missionSuccessView.addTapGestureCameraView(self, action: #selector(self.didTapSuccessMissionView))
            cell.missionFailView.addTapGestureCameraView(self, action: #selector(self.didTapFailMissionView))
            cell.missionFailView.setCameraImage(self.failImage)
            cell.missionSuccessView.setCameraImage(self.successImage)
            
            cell.challengeTitleTextFieldView.textPublisher()
                .receive(on: DispatchQueue.main)
                .sink { [weak self] name in
                    self?.viewModel.changeChallengeName(name)
                }
                .store(in: &self.cancellables)
            
            if let challengeName = self.viewModel.challengeName {
                cell.challengeTitleTextFieldView.ciderTextField.text = challengeName
            }
            
            cell.missionTextFieldView.textPublisher()
                .receive(on: DispatchQueue.main)
                .sink { [weak self] missionInfo in
                    self?.viewModel.changeMissionInfo(missionInfo)
                }
                .store(in: &self.cancellables)
            
            if let missionInfo = self.viewModel.missionInfo {
                cell.missionTextFieldView.ciderTextField.text = missionInfo
            }
            
            
            cell.challengeIntroductionTextView.textPublisher()
                .receive(on: DispatchQueue.main)
                .sink { [weak self] challengeInfo  in
                    self?.viewModel.changeChallengeInfo(challengeInfo)
                }
                .store(in: &self.cancellables)
            
            if self.viewModel.challengeInfo != self.viewModel.infoPlaceHolder {
                cell.challengeIntroductionTextView.textView.text = self.viewModel.challengeInfo
            }
            
            cell.memberView.unitPublisher()
                .receive(on: DispatchQueue.main)
                .sink { [weak self] recruitPeriod in
                    self?.viewModel.changeChallengeCapacity(recruitPeriod)
                }
                .store(in: &self.cancellables)
            cell.memberView.setTextFieltText("\(String(self.viewModel.challengeCapacity))명")
            
            cell.recruitmentView.unitPublisher()
                .receive(on: DispatchQueue.main)
                .sink { [weak self] recruitPeriod in
                    self?.viewModel.changeRecruitPeriod(recruitPeriod)
                }
                .store(in: &self.cancellables)
            cell.recruitmentView.setTextFieltText("\(String(self.viewModel.recruitPeriod))일")
            
            cell.participationView.unitPublisher()
                .receive(on: DispatchQueue.main)
                .sink { [weak self] recruitPeriod in
                    self?.viewModel.changeChallengePeriod(recruitPeriod)
                }
                .store(in: &self.cancellables)
            cell.participationView.setTextFieltText("\(String(self.viewModel.challengePeriod))주")
            
            return cell
        })
    }
    
    func applySnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
        snapshot.appendSections([.main])
        snapshot.appendItems([Item()])
        dataSource?.apply(snapshot)
    }
    
    func createLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(1207)
        )
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                       subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
    
    func pushPrecautionViewController(request: ChallengeOpenRequest, successData: Data, failData: Data) {
        let viewController = PrecautionViewController(
            viewModel: PrecautionViewModel(
                usecase: DefaultChallengeOpenUsecase(
                    repository: DefaultChallengeOpenRepository()
                ),
                challengeOpenRequest: request,
                failData: failData,
                successData: successData
            )
        )
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    func presentPhotoBottomViewController() {
        let viewController = PhotoBottomViewController()
        if let sheet = viewController.sheetPresentationController {
            let identifier = UISheetPresentationController.Detent.Identifier("customMedium")
            let customDetent = UISheetPresentationController.Detent.custom(identifier: identifier) { context in
                return 160-34
            }
            sheet.detents = [customDetent]
            sheet.prefersScrollingExpandsWhenScrolledToEdge = false
            sheet.prefersGrabberVisible = true
        }
        self.present(viewController, animated: true)
        
    }
    
}

private extension ChallengeOpenViewController {
    
    @objc func didTapSuccessMissionView(_ sender: Any?) {
        missionType = .success
        presentPhotoBottomViewController()
    }
    
    @objc func didTapFailMissionView(_ sender: Any?) {
        missionType = .fail
        presentPhotoBottomViewController()
    }
    
    @objc func didTapNextButton(_ sender: Any?) {
        viewModel.didTapNextButton()
    }
    
}


#if DEBUG
import SwiftUI

@available(iOS 13.0, *)
struct ChallengeOpenViewController_Preview: PreviewProvider {
    static var devices = ["iPhone 12", "iPhone SE", "iPhone 11 Pro Max"]
    
    static var previews: some View {
        ForEach(devices, id: \.self) { deviceName in
            ChallengeOpenViewController(challengeType: .financialLearning, viewModel: ChallengeOpenViewModel())
                .toPreview()
                .previewDevice(PreviewDevice(rawValue: deviceName))
                .previewDisplayName(deviceName)
        }
    }
}
#endif
