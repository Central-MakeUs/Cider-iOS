//
//  ChallengeDetailViewController.swift
//  Cider
//
//  Created by 임영선 on 2023/07/28.
//

import UIKit

class ChallengeDetailViewController: UIViewController {
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        collectionView.register(ChallengeDetailMenuCell.self, forCellWithReuseIdentifier: ChallengeDetailMenuCell.identifier)
        collectionView.register(ProgressBarCell.self, forCellWithReuseIdentifier: ProgressBarCell.identifier)
        collectionView.register(HomeHeaderView.self, forSupplementaryViewOfKind: HomeHeaderView.identifier, withReuseIdentifier: HomeHeaderView.identifier)
        collectionView.register(SeparatorFooterView.self, forSupplementaryViewOfKind: SeparatorFooterView.identifier, withReuseIdentifier: SeparatorFooterView.identifier)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.keyboardDismissMode = .onDrag
        return collectionView
    }()
    
    private enum Section: Int {
        case menu = 0
        case progress = 1
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

private extension ChallengeDetailViewController {
    
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
       
    }
    
    func setUpDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, Item>(collectionView: collectionView, cellProvider: { [weak self] collectionView, indexPath, itemIdentifier in
            let section = Section(rawValue: indexPath.section)
            switch section {
            case .menu:
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ChallengeDetailMenuCell.identifier, for: indexPath) as? ChallengeDetailMenuCell else {
                    return UICollectionViewCell()
                }
                cell.setUp(
                    challengeType: .moneySaving,
                    profileImage: UIImage(named: "sample"),
                    mainTitle: "만보 걷기~~~~~~",
                    participant: "29 / 30명",
                    status: "진행중 D-6"
                )
                return cell
                
            case .progress:
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProgressBarCell.identifier, for: indexPath) as? ProgressBarCell else {
                    return UICollectionViewCell()
                }
                cell.setUp(
                    averagePercent: 0.97,
                    myPercent: 0.5
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
            case .progress:
                switch elementKind {
                case HomeHeaderView.identifier:
                    let headerView = collectionView.dequeueReusableSupplementaryView(
                        ofKind: elementKind,
                        withReuseIdentifier: HomeHeaderView.identifier,
                        for: indexPath
                    ) as? HomeHeaderView
                    headerView?.setUp(leftTitle: "챌린지 현황", rightTitle: "30회 중 6회 진행", isClicked: false)
                    return headerView ?? UICollectionReusableView()
                    
                case SeparatorFooterView.identifier:
                    let headerView = collectionView.dequeueReusableSupplementaryView(
                        ofKind: elementKind,
                        withReuseIdentifier: SeparatorFooterView.identifier,
                        for: indexPath
                    ) as? SeparatorFooterView
                    return headerView ?? UICollectionReusableView()
                    
                default:
                    return nil
                    
                }
               
                
            default:
                return nil
            }
        }
        
    }
    
    func applySnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
        snapshot.appendSections([.menu])
        snapshot.appendItems([Item()])
        snapshot.appendSections([.progress])
        snapshot.appendItems([Item()])
        dataSource?.apply(snapshot)
    }
    
    func createLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { [weak self] (sectionNumber, _) -> NSCollectionLayoutSection? in
            let section = Section(rawValue: sectionNumber)
            switch section {
            case .menu:
                return self?.menuSectionLayout()
                
            case .progress:
                return self?.progressSectionLayout()
                
            default:
                return nil
            }
        }
    }
    
    func menuSectionLayout() -> NSCollectionLayoutSection {
        let layoutSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .estimated(279)
        )
        
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: .init(
                widthDimension: layoutSize.widthDimension,
                heightDimension: layoutSize.heightDimension
            ),
            subitems: [.init(layoutSize: layoutSize)]
        )
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = .init(top: 0, leading: 0, bottom: 10, trailing: 0)
        return section
    }
    
    func progressSectionLayout() -> NSCollectionLayoutSection {
        let layoutSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .estimated(53)
        )
        
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: .init(
                widthDimension: layoutSize.widthDimension,
                heightDimension: layoutSize.heightDimension
            ),
            subitems: [.init(layoutSize: layoutSize)]
        )
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = .init(top: 0, leading: 24, bottom: 0, trailing: 24)
        
        section.boundarySupplementaryItems = [
            NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: .init(
                    widthDimension: .absolute(view.safeAreaLayoutGuide.layoutFrame.width),
                    heightDimension: .absolute(49)
                ),
                elementKind: HomeHeaderView.identifier, alignment: .top
            ),
            NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: .init(
                    widthDimension: .absolute(view.safeAreaLayoutGuide.layoutFrame.width),
                    heightDimension: .absolute(8)
                ),
                elementKind: SeparatorFooterView.identifier, alignment: .bottom
            )
        ]
        return section
    }
    
}
