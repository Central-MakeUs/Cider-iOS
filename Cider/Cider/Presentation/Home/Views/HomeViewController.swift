//
//  HomeViewController.swift
//  Cider
//
//  Created by 임영선 on 2023/07/21.
//

import UIKit

final class HomeViewController: UIViewController {
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        collectionView.register(ChallengeHomeCell.self, forCellWithReuseIdentifier: ChallengeHomeCell.identifier)
        collectionView.register(BannerCell.self, forCellWithReuseIdentifier: BannerCell.identifier)
        collectionView.register(HomeHeaderView.self, forSupplementaryViewOfKind: HomeHeaderView.identifier, withReuseIdentifier: HomeHeaderView.identifier)
        collectionView.register(CategoryHeaderView.self, forSupplementaryViewOfKind: CategoryHeaderView.identifier, withReuseIdentifier: CategoryHeaderView.identifier)

        collectionView.showsVerticalScrollIndicator = false
        collectionView.keyboardDismissMode = .onDrag
        return collectionView
    }()
    
    private lazy var rightBarButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "line_mychallenge_24"), for: .normal)
        return button
    }()
    
    private enum Section: Int {
        case banner = 0
        case popluarChallenge = 1
        case publicChallenge = 2
        case category = 3
    }
    
    private var dataSource: UICollectionViewDiffableDataSource<Section, Item>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNavigationBar()
    }
    
}

private extension HomeViewController {
    
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
        let leftView = HomeNavigationView()
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: leftView)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: rightBarButton)
    }
    
    func setUpDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, Item>(collectionView: collectionView, cellProvider: { [weak self] collectionView, indexPath, itemIdentifier in
            let section = Section(rawValue: indexPath.section)
            switch section {
            case .banner:
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BannerCell.identifier, for: indexPath) as? BannerCell else {
                    return UICollectionViewCell()
                }
                cell.setUp(0)
                return cell
                
            case .popluarChallenge:
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ChallengeHomeCell.identifier, for: indexPath) as? ChallengeHomeCell else {
                    return UICollectionViewCell()
                }
                cell.setUp(
                    type: .financialTech,
                    isReward: true,
                    date: "1주",
                    ranking: "1위",
                    title: "만보걷기",
                    status: "종료",
                    people: "5명 모집중",
                    isPublic: true,
                    dDay: "D-12"
                )
                return cell
                
            case .publicChallenge:
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ChallengeHomeCell.identifier, for: indexPath) as? ChallengeHomeCell else {
                    return UICollectionViewCell()
                }
                cell.setUp(
                    type: .moneySaving,
                    isReward: true,
                    date: "1주",
                    ranking: nil,
                    title: "만보걷기",
                    status: "종료",
                    people: "5명 모집중",
                    isPublic: true,
                    dDay: "D-12"
                )
                return cell
                
            case .category:
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ChallengeHomeCell.identifier, for: indexPath) as? ChallengeHomeCell else {
                    return UICollectionViewCell()
                }
                cell.setUp(
                    type: .moneyManagement,
                    isReward: true,
                    date: "1주",
                    ranking: nil,
                    title: "만보걷기",
                    status: "종료",
                    people: "5명 모집중",
                    isPublic: false,
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
            case .popluarChallenge:
                let headerView = collectionView.dequeueReusableSupplementaryView(
                    ofKind: elementKind,
                    withReuseIdentifier: HomeHeaderView.identifier,
                    for: indexPath
                ) as? HomeHeaderView
                headerView?.setUp(leftTitle: "인기 챌린지", rightTitle: "더보기  >")
                return headerView
                
            case .publicChallenge:
                let headerView = collectionView.dequeueReusableSupplementaryView(
                    ofKind: elementKind,
                    withReuseIdentifier: HomeHeaderView.identifier,
                    for: indexPath
                ) as? HomeHeaderView
                headerView?.setUp(leftTitle: "바로 참여 가능! 공식 챌린지", rightTitle: "더보기 >")
                return headerView
                
            case .category:
                let headerView = collectionView.dequeueReusableSupplementaryView(
                    ofKind: elementKind,
                    withReuseIdentifier: CategoryHeaderView.identifier,
                    for: indexPath
                ) as? CategoryHeaderView
                headerView?.setUp(leftTitle: "카테고리", rightTitle: "전체 챌린지 보기", selectedType: .financialTech)
                return headerView
                
            default:
                return nil
            }
        }
    }
    
    func applySnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
        snapshot.appendSections([.banner])
        snapshot.appendItems([Item(),Item(),Item(),Item(),Item(),Item()])
        snapshot.appendSections([.popluarChallenge])
        snapshot.appendItems([Item(),Item(),Item(),Item(),Item(),Item()])
        snapshot.appendSections([.publicChallenge])
        snapshot.appendItems([Item(),Item(),Item(),Item(),Item(),Item()])
        snapshot.appendSections([.category])
        snapshot.appendItems([Item(),Item(),Item(),Item(),Item(),Item()])
        dataSource?.apply(snapshot)
    }
    
    func createLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { [weak self] (sectionNumber, _) -> NSCollectionLayoutSection? in
            let section = Section(rawValue: sectionNumber)
            switch section {
            case .banner:
                return self?.bannerSectionLayout()
                
            case .publicChallenge:
                return self?.challengeSectionLayout()
                
            case .popluarChallenge:
                return self?.challengeSectionLayout()
                
            case .category:
                return self?.categorySectionLayout()
            default:
                return nil
            }
        }
    }
    
    func bannerSectionLayout() -> NSCollectionLayoutSection {
        let layoutSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .absolute(260)
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
        let layoutSize = NSCollectionLayoutSize(
            widthDimension: .absolute(150),
            heightDimension: .absolute(273)
        )
        
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: .init(
                widthDimension: layoutSize.widthDimension,
                heightDimension: layoutSize.heightDimension
            ),
            subitems: [.init(layoutSize: layoutSize)]
        )
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = .init(top: 0, leading: 24, bottom: 32, trailing: 32)
        
        section.interGroupSpacing = 12
        section.orthogonalScrollingBehavior = .continuous
        
        section.boundarySupplementaryItems = [
            NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: .init(
                    widthDimension: .absolute(view.safeAreaLayoutGuide.layoutFrame.width),
                    heightDimension: .absolute(49)
                ),
                elementKind: HomeHeaderView.identifier, alignment: .top)
        ]
        return section
    }
    
    func categorySectionLayout() -> NSCollectionLayoutSection {
        let layoutSize = NSCollectionLayoutSize(
            widthDimension: .absolute(150),
            heightDimension: .absolute(273)
        )
        
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: .init(
                widthDimension: layoutSize.widthDimension,
                heightDimension: layoutSize.heightDimension
            ),
            subitems: [.init(layoutSize: layoutSize)]
        )
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = .init(top: 0, leading: 24, bottom: 32, trailing: 32)
        
        section.interGroupSpacing = 12
        section.orthogonalScrollingBehavior = .continuous
        
        section.boundarySupplementaryItems = [
            NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: .init(
                    widthDimension: .absolute(view.safeAreaLayoutGuide.layoutFrame.width),
                    heightDimension: .absolute(182)
                ),
                elementKind: CategoryHeaderView.identifier, alignment: .top)
        ]
        return section
    }
    
}
