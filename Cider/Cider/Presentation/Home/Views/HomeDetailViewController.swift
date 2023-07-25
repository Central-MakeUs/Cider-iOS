//
//  HomeDetailViewController.swift
//  Cider
//
//  Created by 임영선 on 2023/07/24.
//

import UIKit

class HomeDetailViewController: UIViewController {
    
    private let homeDetailType: HomeDetailType
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        collectionView.register(HomeDetailInfoCell.self, forCellWithReuseIdentifier: HomeDetailInfoCell.identifier)
        collectionView.register(ChallengeHomeCell.self, forCellWithReuseIdentifier: ChallengeHomeCell.identifier)
        collectionView.register(SortingHeaderView.self, forSupplementaryViewOfKind: SortingHeaderView.identifier, withReuseIdentifier: SortingHeaderView.identifier)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.keyboardDismissMode = .onDrag
        return collectionView
    }()
    
    private enum Section: Int {
        case homeDetailInfo = 0
        case challenge = 1
    }
    
    private var dataSource: UICollectionViewDiffableDataSource<Section, Item>?
    
    init(homeDetailType: HomeDetailType) {
        self.homeDetailType = homeDetailType
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

private extension HomeDetailViewController {
    
    func setUp() {
        configure()
        setUpDataSource()
        applySnapshot()
    }
    
    func configure() {
        view.backgroundColor = .white
        view.addSubviews(collectionView)
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    func setNavigationBar() {
        self.navigationController?.navigationBar.topItem?.title = ""
        self.navigationItem.title = homeDetailType.navigationBarTitle
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
                cell.setUp(
                    type: .financialTech,
                    isReward: true,
                    date: "1주",
                    ranking: self.homeDetailType == .popularChallenge ? "1위" : nil,
                    title: "만보걷기",
                    status: "종료",
                    people: "5명 모집중",
                    isPublic: true,
                    dDay: "D-12"
                )
                return cell
                
                
            case .none:
                return UICollectionViewCell()
            }
        })
        
        dataSource?.supplementaryViewProvider = { collectionView, elementKind, indexPath in
            let section = Section(rawValue: indexPath.section)
            switch section {
            case .challenge:
                let headerView = collectionView.dequeueReusableSupplementaryView(
                    ofKind: elementKind,
                    withReuseIdentifier: SortingHeaderView.identifier,
                    for: indexPath
                ) as? SortingHeaderView
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
        snapshot.appendItems([Item(),Item(),Item(),Item(),Item(),Item()])
        dataSource?.apply(snapshot)
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
            heightDimension: .fractionalWidth(homeDetailType == .allChallenge ? 0 : 0.72)
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
