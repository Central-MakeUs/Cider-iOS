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
        collectionView.register(CertifyCell.self, forCellWithReuseIdentifier: CertifyCell.identifier)
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
        controller.sourceType = .camera
        controller.allowsEditing = true
        return controller
    }()

    private let viewModel: CertifyViewModel
    private var cancellables = Set<AnyCancellable>()
    private var dataSource: UICollectionViewDiffableDataSource<Section, Item>?
    
    init(viewModel: CertifyViewModel) {
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
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomButton.topAnchor),
            bottomButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            bottomButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            bottomButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20)
        ])
    }
    
    func setNavigationBar() {
        self.navigationController?.navigationBar.topItem?.title = ""
        self.navigationItem.title = "인증하기"
        setNavigationBar(backgroundColor: .white, tintColor: .black, shadowColor: .clear)
    }
    
    func setUpDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, Item>(collectionView: collectionView, cellProvider: { [weak self] collectionView, indexPath, itemIdentifier in
            guard let self = self else {
                return UICollectionViewCell()
            }
            
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CertifyCell.identifier, for: indexPath) as? CertifyCell else {
                return UICollectionViewCell()
            }
            cell.challengeSelectionView.setTextFieltText("만보 걷기")
            cell.addTapGestureCameraView(self, action: #selector(self.didTapCameraView))
            cell.setCameraImage(self.viewModel.certifyImage)
            cell.titleTextFieldView.textPublisher()
                .receive(on: DispatchQueue.main)
                .sink { [weak self] title in
                    self?.viewModel.changeChallengeName(title)
                }
                .store(in: &self.cancellables)
            
            if self.viewModel.challengeName == self.viewModel.challengeNamePlaceHolder {
                cell.titleTextFieldView.setPlaceHoder(self.viewModel.challengeNamePlaceHolder)
            } else {
                cell.titleTextFieldView.ciderTextField.text = self.viewModel.challengeName
            }
            

            cell.contentTextView.textPublisher()
                .receive(on: DispatchQueue.main)
                .sink { [weak self] content  in
                    self?.viewModel.changechallengeContent(content)
                }
                .store(in: &self.cancellables)
            cell.contentTextView.textView.text = self.viewModel.challengeContent
            
            cell.challengeSelectionView.indexPublisher()
                .receive(on: DispatchQueue.main)
                .sink { [weak self] index  in
                    self?.viewModel.selectChallengeIndex(index)
                }
                .store(in: &self.cancellables)
            cell.challengeSelectionView.challengeList = self.viewModel.challengeList
            cell.challengeSelectionView.selectedIndex = self.viewModel.challengeIndex
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
            heightDimension: .estimated(600)
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
            viewModel.certifyImage = image
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
            CertifyViewController(viewModel: CertifyViewModel())
                .toPreview()
                .previewDevice(PreviewDevice(rawValue: deviceName))
                .previewDisplayName(deviceName)
        }
    }
}
#endif

