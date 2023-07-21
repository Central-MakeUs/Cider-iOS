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
    
    private lazy var imagePickerController: UIImagePickerController = {
        let controller = UIImagePickerController()
        controller.delegate = self
        controller.sourceType = .photoLibrary
        controller.allowsEditing = true
        return controller
    }()
    
    private let viewModel: ChallengeOpenViewModel
    private var cancellables = Set<AnyCancellable>()
    
    private let challengeType: ChallengeType
    
    private enum Section { case main }
    
    private var dataSource: UICollectionViewDiffableDataSource<Section, Item>?
    
    private var failImage = UIImage()
    private var successImage = UIImage()
    private var missionType: MissionType?
    
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
    }
    
    func bind() {
        viewModel.state.receive(on: DispatchQueue.main)
            .sink { [weak self] state in
                switch state {
                case .changeNextButtonState(let isEnabled):
                    self?.bottomButton.setStyle(isEnabled ? .enabled : .disabled)
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
            
            cell.missionTextFieldView.textPublisher()
                .receive(on: DispatchQueue.main)
                .sink { [weak self] missionInfo in
                    self?.viewModel.changeMissionInfo(missionInfo)
                }
                .store(in: &self.cancellables)
            
            cell.challengeIntroductionTextView.textPublisher()
                .receive(on: DispatchQueue.main)
                .sink { [weak self] challengeInfo  in
                    self?.viewModel.changeChallengeInfo(challengeInfo)
                }
                .store(in: &self.cancellables)
            
            cell.memberView.unitPublisher()
                .receive(on: DispatchQueue.main)
                .sink { [weak self] recruitPeriod in
                    self?.viewModel.changeRecruitPeriod(recruitPeriod)
                }
                .store(in: &self.cancellables)
            
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
    
    func pushPrecautionViewController() {
        let viewController = PrecautionViewController(
            viewModel: PrecautionViewModel()
        )
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
}

private extension ChallengeOpenViewController {
    
    @objc func didTapSuccessMissionView(_ sender: Any?) {
        missionType = .success
        self.present(imagePickerController, animated: true)
    }
    
    @objc func didTapFailMissionView(_ sender: Any?) {
        missionType = .fail
        self.present(imagePickerController, animated: true)
    }
    
    @objc func didTapNextButton(_ sender: Any?) {
        pushPrecautionViewController()
    }
    
}

extension ChallengeOpenViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let missionType else {
            return
        }
        
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            if missionType == .success {
                successImage = image
                viewModel.selectSuccessImage(image)
            } else {
                failImage = image
                viewModel.selectFailImage(image)
            }
        }
        picker.dismiss(animated: true, completion: nil)
        applySnapshot()
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
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
