//
//  HomeDetailViewController.swift
//  Cider
//
//  Created by 임영선 on 2023/07/24.
//

import UIKit
import Combine

final class HomeDetailViewController: UIViewController {
    
    private let homeDetailType: HomeDetailType
    
    private let infoHeight = UIScreen.main.bounds.width*0.516
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        collectionView.register(HomeDetailInfoCell.self, forCellWithReuseIdentifier: HomeDetailInfoCell.identifier)
        collectionView.register(ChallengeHomeCell.self, forCellWithReuseIdentifier: ChallengeHomeCell.identifier)
        collectionView.register(SortingHeaderView.self, forSupplementaryViewOfKind: SortingHeaderView.identifier, withReuseIdentifier: SortingHeaderView.identifier)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.keyboardDismissMode = .onDrag
        collectionView.delegate = self
        return collectionView
    }()
    
    private lazy var arrowTopButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "arrowTopButton"), for: .normal)
        button.addTarget(self, action: #selector(didTapArrowTop), for: .touchUpInside)
        return button
    }()
    
    private enum Section: Int {
        case homeDetailInfo = 0
        case challenge = 1
    }
    
    private var dataSource: UICollectionViewDiffableDataSource<Section, Item>?
    
    private let viewModel: HomeDetailViewModel
    private var cancellables = Set<AnyCancellable>()
    
    
    init(homeDetailType: HomeDetailType, viewModel: HomeDetailViewModel) {
        self.homeDetailType = homeDetailType
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
        viewModel.viewDidload()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNavigationBar()
    }

}

private extension HomeDetailViewController {
    
    func setUp() {
        configure()
        setUpDataSource()
        applySnapshot()
        bind()
        setNotificationCenter()
        setNavigationBar()
    }
    
    func bind() {
        viewModel.state.receive(on: DispatchQueue.main)
            .sink { [weak self] state in
                switch state {
                case .applySnapshot(let isSuccess):
                    guard isSuccess else {
                        return
                    }
                    self?.applySnapshot()
                }
            }
            .store(in: &cancellables)
    }
    
    func setNavigationBar() {
        self.navigationController?.navigationBar.topItem?.title = ""
        self.navigationItem.title = homeDetailType.navigationBarTitle
        self.navigationController?.navigationBar.scrollEdgeAppearance?.shadowColor = .clear
        self.navigationController?.navigationBar.standardAppearance.shadowColor = .clear
        setNavigationBar(
            backgroundColor: homeDetailType == .allChallenge ? .white : homeDetailType.mainColor,
            tintColor: homeDetailType == .allChallenge ? .black : .white
        )
    }
    
    func configure() {
        view.backgroundColor = .white
        view.addSubviews(collectionView, arrowTopButton)
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            arrowTopButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -25),
            arrowTopButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24)
        ])
    }
    
    func setNotificationCenter() {
        NotificationCenter.default.publisher(for: .tapSorting)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] notification in
                guard let self = self else {
                    return
                }
                guard let sortingType = notification.object as? SortingType else {
                    return
                }
                self.viewModel.sortingType = sortingType
                self.reloadHeader()
            }
            .store(in: &cancellables)
    }
    
    func setUpDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, Item>(collectionView: collectionView, cellProvider: { [weak self] collectionView, indexPath, itemIdentifier in
            guard let self = self else {
                return UICollectionViewCell()
            }
            
            let section = Section(rawValue: indexPath.section)
            switch section {
            case .homeDetailInfo:
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeDetailInfoCell.identifier, for: indexPath) as? HomeDetailInfoCell else {
                    return UICollectionViewCell()
                }
                cell.setUp(self.homeDetailType)
                return cell
                
            case .challenge:
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ChallengeHomeCell.identifier, for: indexPath) as? ChallengeHomeCell else {
                    return UICollectionViewCell()
                }
                let challenge = self.viewModel.challenges[indexPath.row]
                cell.setUp(
                    type: challenge.interestField.convertChallengeType(),
                    isReward: challenge.isReward,
                    date: "\(challenge.challengePeriod)주",
                    ranking: self.homeDetailType == .popularChallenge ? "\(indexPath.row+1)위" : nil,
                    title: challenge.challengeName,
                    status: challenge.challengeStatus.convertStatusKorean(),
                    people: "\(challenge.participateNum)명 모집중",
                    isPublic: challenge.isOfficial,
                    dDay: "D-\(challenge.recruitLeft)",
                    isLike: challenge.isLike
                )
                return cell
                
                
            case .none:
                return UICollectionViewCell()
            }
        })
        
        dataSource?.supplementaryViewProvider = { [weak self] collectionView, elementKind, indexPath in
            guard let self = self else {
                return UICollectionReusableView()
            }
            let section = Section(rawValue: indexPath.section)
            switch section {
            case .challenge:
                guard let headerView = collectionView.dequeueReusableSupplementaryView(
                    ofKind: elementKind,
                    withReuseIdentifier: SortingHeaderView.identifier,
                    for: indexPath
                ) as? SortingHeaderView else {
                    return UICollectionReusableView()
                }
                headerView.setSoringViewGesture(self, action: #selector(self.didTapSorting))
                headerView.setUp(text: self.viewModel.sortingType.korean)
                return headerView

            default:
                return nil
            }
        }
    }
    
    func applySnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
        snapshot.appendSections([.homeDetailInfo])
        snapshot.appendItems([Item()])
        snapshot.appendSections([.challenge])
        snapshot.appendItems(viewModel.items)
        dataSource?.apply(snapshot)
    }
    
    func reloadHeader() {
        guard let snapshot = dataSource?.snapshot() else {
            return
        }
        dataSource?.applySnapshotUsingReloadData(snapshot)
    }
    
    func createLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { [weak self] (sectionNumber, _) -> NSCollectionLayoutSection? in
            let section = Section(rawValue: sectionNumber)
            switch section {
            case .homeDetailInfo:
                return self?.infoSectionLayout()
            case .challenge:
                return self?.challengeSectionLayout()
            case .none:
                return nil
            }
        }
    }
    
    func infoSectionLayout() -> NSCollectionLayoutSection {
        let layoutSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(homeDetailType == .allChallenge ? 0 : 1),
            heightDimension: .absolute(homeDetailType == .allChallenge ? 0 : infoHeight)
        )
        
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: .init(
                widthDimension: layoutSize.widthDimension,
                heightDimension: layoutSize.heightDimension
            ),
            subitems: [.init(layoutSize: layoutSize)]
        )
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = .init(top: 0, leading: 0, bottom: 0, trailing: 0)
        
        section.interGroupSpacing = 0
        section.orthogonalScrollingBehavior = .paging
        return section
    }
    
    func challengeSectionLayout() -> NSCollectionLayoutSection {
        let width = (UIScreen.main.bounds.width-48-12)/2
        
        let height: CGFloat
        switch homeDetailType {
        case .popularChallenge:
            height = width*1.82+15
        case .publicChallenge, .allChallenge:
            height = width*1.72+13
        }
        
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .absolute(width),
            heightDimension: .fractionalWidth(1)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .absolute(height)
        )
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitems: [item, item]
        )
        group.interItemSpacing = .fixed(12)
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = .init(top: 0, leading: 24, bottom: 24, trailing: 24)
        section.interGroupSpacing = 0
        
        section.boundarySupplementaryItems = [
            NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: .init(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .absolute(49)
                ),
                elementKind: SortingHeaderView.identifier, alignment: .top)
        ]
        return section
    }
    
}

private extension HomeDetailViewController {
    
    @objc func didTapArrowTop(_ sender: Any?) {
        collectionView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
    }
    
    @objc func didTapSorting(_ sender: Any?) {
        presentSortingViewController()
    }
    
    func presentSortingViewController() {
        let viewController = SortingViewController()
        if let sheet = viewController.sheetPresentationController {
            let identifier = UISheetPresentationController.Detent.Identifier("customMedium")
            let customDetent = UISheetPresentationController.Detent.custom(identifier: identifier) { context in
                return 200-34
            }
            sheet.detents = [customDetent]
            sheet.prefersScrollingExpandsWhenScrolledToEdge = false
            sheet.prefersGrabberVisible = true
        }
        self.present(viewController, animated: true)
    }
    
}

extension HomeDetailViewController: UICollectionViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        scrollView.bounces = scrollView.contentOffset.y > 100
        switch homeDetailType {
        case .publicChallenge,
             .popularChallenge:
            if scrollView.contentOffset.y > infoHeight {
                setNavigationBar(backgroundColor: .white, tintColor: .black)
            } else {
                setNavigationBar(backgroundColor: homeDetailType.mainColor, tintColor: .white)
            }
            
        case .allChallenge:
            break
            
        }
    }
    
}
