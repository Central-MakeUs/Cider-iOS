//
//  CertifyViewController.swift
//  Cider
//
//  Created by 임영선 on 2023/08/10.
//

import UIKit
import Combine

final class CertifyViewController: UIViewController {
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        collectionView.register(ChallengeOpenCell.self, forCellWithReuseIdentifier: ChallengeOpenCell.identifier)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.keyboardDismissMode = .onDrag
        return collectionView
    }()
    
    private lazy var bottomButton: CiderBottomButton = {
        let button = CiderBottomButton(style: .disabled, title: "인증 완료하기")
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
    private var dataSource: UICollectionViewDiffableDataSource<Section, Item>?
    
    init(viewModel: ChallengeOpenViewModel) {
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
    }

}


private extension CertifyViewController {
    
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
        self.navigationItem.title = "인증하기"
        setNavigationBar(backgroundColor: .white, tintColor: .black)
    }
    
    func setUpDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, Item>(collectionView: collectionView, cellProvider: { [weak self] collectionView, indexPath, itemIdentifier in
            guard let self = self else {
                return UICollectionViewCell()
            }
            
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ChallengeOpenCell.identifier, for: indexPath) as? ChallengeOpenCell else {
                return UICollectionViewCell()
            }
            cell.missionFailView.setCameraImage(UIImage())
           
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

private extension CertifyViewController {
    
    @objc func didTapNextButton(_ sender: Any?) {
        pushPrecautionViewController()
    }
    
    @objc func didTapCameraView(_ sender: Any?) {
        self.present(imagePickerController, animated: true)
    }
}

extension CertifyViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            // TODO: image처리 
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
struct CertifyViewController_Preview: PreviewProvider {
    static var devices = ["iPhone 12", "iPhone SE", "iPhone 11 Pro Max"]
    
    static var previews: some View {
        ForEach(devices, id: \.self) { deviceName in
            CertifyViewController(viewModel: ChallengeOpenViewModel())
                .toPreview()
                .previewDevice(PreviewDevice(rawValue: deviceName))
                .previewDisplayName(deviceName)
        }
    }
}
#endif

