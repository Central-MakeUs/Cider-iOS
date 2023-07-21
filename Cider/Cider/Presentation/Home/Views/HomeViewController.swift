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
        collectionView.register(HomeHeaderView.self, forSupplementaryViewOfKind: HomeHeaderView.identifier, withReuseIdentifier: HomeHeaderView.identifier)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.keyboardDismissMode = .onDrag
        return collectionView
    }()
    
    private enum Section: Int {
        case popluarChallenge = 0
        case publicChallenge = 1
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
        self.navigationItem.title = "챌린지"
    }
    
    func setUpDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, Item>(collectionView: collectionView, cellProvider: { [weak self] collectionView, indexPath, itemIdentifier in
            
            switch Section(rawValue: indexPath.section)  {
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
                headerView?.setUp(leftTitle: "인기 챌린지", rightTitle: "더보기 >")
                return headerView
                
            case .publicChallenge:
                let headerView = collectionView.dequeueReusableSupplementaryView(
                    ofKind: elementKind,
                    withReuseIdentifier: HomeHeaderView.identifier,
                    for: indexPath
                ) as? HomeHeaderView
                headerView?.setUp(leftTitle: "바로 참여 가능! 공식 챌린지", rightTitle: "더보기 >")
                return headerView
                
            case .none:
                return nil
            }
        }
    }
    
    func applySnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
        snapshot.appendSections([.popluarChallenge])
        snapshot.appendItems([Item(),Item(),Item(),Item(),Item(),Item()])
        snapshot.appendSections([.publicChallenge])
        snapshot.appendItems([Item(),Item(),Item(),Item(),Item(),Item()])
        dataSource?.apply(snapshot)
    }
    
    func createLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { [weak self] (sectionNumber, _) -> NSCollectionLayoutSection? in
            let section = Section(rawValue: sectionNumber)
            switch section {
            case .publicChallenge:
                return self?.challengeSectionLayout()
                
            case .popluarChallenge:
                return self?.challengeSectionLayout()
                
            default:
                return nil
            }
            
        }
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
        section.contentInsets = .init(top: 20, leading: 20, bottom: 80, trailing: 20)
        
        section.interGroupSpacing = 12
        section.orthogonalScrollingBehavior = .continuous
        
        section.boundarySupplementaryItems = [
            NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: .init(
                    widthDimension: .absolute(view.safeAreaLayoutGuide.layoutFrame.width),
                    heightDimension: .estimated(49)
                ),
                elementKind: HomeHeaderView.identifier, alignment: .top)
        ]
        return section
    }
    
}
