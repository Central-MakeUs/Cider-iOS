//
//  MyChallengeViewController.swift
//  Cider
//
//  Created by 임영선 on 2023/07/25.
//

import UIKit

class MyChallengeViewController: UIViewController {
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        collectionView.register(ClosedChallengeCell.self, forCellWithReuseIdentifier: ClosedChallengeCell.identifier)
        collectionView.register(OngoingCell.self, forCellWithReuseIdentifier: OngoingCell.identifier)
        collectionView.register(ReviewCell.self, forCellWithReuseIdentifier: ReviewCell.identifier)
        collectionView.register(HomeHeaderView.self, forSupplementaryViewOfKind: HomeHeaderView.identifier, withReuseIdentifier: HomeHeaderView.identifier)
        collectionView.register(SeparatorFooterView.self, forSupplementaryViewOfKind: SeparatorFooterView.identifier, withReuseIdentifier: SeparatorFooterView.identifier)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.keyboardDismissMode = .onDrag
        return collectionView
    }()
    
    private lazy var rightBarButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "line_profile_24"), for: .normal)
        button.heightAnchor.constraint(equalToConstant: 24).isActive = true
        button.widthAnchor.constraint(equalToConstant: 24).isActive = true
        button.addTarget(self, action: #selector(didTapRightBarButton), for: .touchUpInside)
        return button
    }()
    
    private enum Section: Int {
        case onGoingChallenge = 0
        case closedChallenge = 1
        case reviewChallenge = 2
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

private extension MyChallengeViewController {
    
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
        self.navigationItem.title = "내 챌린지"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: rightBarButton)
    }
    
    func setUpDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, Item>(collectionView: collectionView, cellProvider: { [weak self] collectionView, indexPath, itemIdentifier in
            let section = Section(rawValue: indexPath.section)
            switch section {
            case .onGoingChallenge:
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: OngoingCell.identifier, for: indexPath) as? OngoingCell else {
                    return UICollectionViewCell()
                }
                cell.setUp(
                    mainTitle: "소비습관 고치기",
                    challengeType: .financialLearning,
                    onGoing: "챌린지 진행 +10일",
                    countText: "30회 중 24회 달성"
                )
                return cell
                
            case .closedChallenge:
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ClosedChallengeCell.identifier, for: indexPath) as? ClosedChallengeCell else {
                    return UICollectionViewCell()
                }
                cell.setUp(
                    type: .financialTech,
                    isReward: true,
                    date: "1주",
                    title: "만보걷기",
                    status: "종료",
                    people: "5명 모집중",
                    isPublic: true
                )
                cell.challengeHomeView.setClosedChallenge(.fail)
                return cell
                
            case .reviewChallenge:
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ReviewCell.identifier, for: indexPath) as? ReviewCell else {
                    return UICollectionViewCell()
                }
                cell.setUp(
                    title: "만보 걷기",
                    challengeType: .moneySaving,
                    reviewType: .successReview,
                    challengeSuccessMessage: "2023.07.11 챌린지 모집 시작"
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
            case .onGoingChallenge:
                switch elementKind {
                case HomeHeaderView.identifier:
                    let headerView = collectionView.dequeueReusableSupplementaryView(
                        ofKind: elementKind,
                        withReuseIdentifier: HomeHeaderView.identifier,
                        for: indexPath
                    ) as? HomeHeaderView
                    headerView?.setUp(leftTitle: "진행중인 챌린지", rightTitle: "2개", isClicked: false)
                    headerView?.setRightLabelColor(.custom.main)
                    return headerView ?? UICollectionReusableView()
                    
                case SeparatorFooterView.identifier:
                    let footerView = collectionView.dequeueReusableSupplementaryView(
                        ofKind: elementKind,
                        withReuseIdentifier: SeparatorFooterView.identifier,
                        for: indexPath
                    ) as? SeparatorFooterView
                    return footerView ?? UICollectionReusableView()
                    
                default:
                    return nil
                }
                
            case .closedChallenge:
                switch elementKind {
                case HomeHeaderView.identifier:
                    let headerView = collectionView.dequeueReusableSupplementaryView(
                        ofKind: elementKind,
                        withReuseIdentifier: HomeHeaderView.identifier,
                        for: indexPath
                    ) as? HomeHeaderView
                    headerView?.setUp(leftTitle: "최근 종료된 챌린지", rightTitle: "8개", isClicked: false)
                    return headerView ?? UICollectionReusableView()
                    
                case SeparatorFooterView.identifier:
                    let footerView = collectionView.dequeueReusableSupplementaryView(
                        ofKind: elementKind,
                        withReuseIdentifier: SeparatorFooterView.identifier,
                        for: indexPath
                    ) as? SeparatorFooterView
                    return footerView ?? UICollectionReusableView()
                    
                default:
                    return nil
                }
                
            case .reviewChallenge:
                let headerView = collectionView.dequeueReusableSupplementaryView(
                    ofKind: elementKind,
                    withReuseIdentifier: HomeHeaderView.identifier,
                    for: indexPath
                ) as? HomeHeaderView
                headerView?.setUp(leftTitle: "심사중인 챌린지", rightTitle: "2개", isClicked: false)
                return headerView ?? UICollectionReusableView()
                
            default:
                return nil
            }
        }
    }
    
    
    func applySnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
        snapshot.appendSections([.onGoingChallenge])
        snapshot.appendItems([Item(), Item(), Item(), Item(), Item(), Item()])
        snapshot.appendSections([.closedChallenge])
        snapshot.appendItems([Item(), Item(), Item(), Item(), Item(), Item()])
        snapshot.appendSections([.reviewChallenge])
        snapshot.appendItems([Item(), Item(), Item(), Item(), Item(), Item()])
        dataSource?.apply(snapshot)
    }
    
    func createLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { [weak self] (sectionNumber, _) -> NSCollectionLayoutSection? in
            let section = Section(rawValue: sectionNumber)
            switch section {
            case .onGoingChallenge:
                return self?.onGoingSectionLayout()
                
            case .closedChallenge:
                return self?.challengeSectionLayout()
                
            case .reviewChallenge:
                return self?.reviewSectionLayout()
                
            case .none:
                return nil
            }
        }
    }
    
    func onGoingSectionLayout() -> NSCollectionLayoutSection {
        let layoutSize = NSCollectionLayoutSize(
            widthDimension: .absolute(225.24),
            heightDimension: .absolute(70)
        )
        
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: .init(
                widthDimension: layoutSize.widthDimension,
                heightDimension: layoutSize.heightDimension
            ),
            subitems: [.init(layoutSize: layoutSize)]
        )
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = .init(top: 0, leading: 24, bottom: 16, trailing: 24)
        
        section.interGroupSpacing = 12
        section.orthogonalScrollingBehavior = .continuous
        
        section.boundarySupplementaryItems = [
            NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: .init(
                    widthDimension: .absolute(UIScreen.main.bounds.width),
                    heightDimension: .absolute(49)
                ),
                elementKind: HomeHeaderView.identifier, alignment: .top
            ),
            NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: .init(
                    widthDimension: .absolute(UIScreen.main.bounds.width),
                    heightDimension: .absolute(8)
                ),
                elementKind: SeparatorFooterView.identifier, alignment: .bottom
            )
        ]
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
        section.contentInsets = .init(top: 0, leading: 24, bottom: 16, trailing: 24)
        
        section.interGroupSpacing = 12
        section.orthogonalScrollingBehavior = .continuous
        
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
                    widthDimension: .absolute(UIScreen.main.bounds.width),
                    heightDimension: .absolute(8)
                ),
                elementKind: SeparatorFooterView.identifier, alignment: .bottom
            )
        ]
        return section
    }
    
    func reviewSectionLayout() -> NSCollectionLayoutSection {
        let layoutSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .absolute(115.8)
        )
        
        let group = NSCollectionLayoutGroup.vertical(
            layoutSize: .init(
                widthDimension: layoutSize.widthDimension,
                heightDimension: layoutSize.heightDimension
            ),
            subitems: [.init(layoutSize: layoutSize)]
        )
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = .init(top: 0, leading: 24, bottom: 16, trailing: 24)
        
        section.interGroupSpacing = 16
       
        section.boundarySupplementaryItems = [
            NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: .init(
                    widthDimension: .absolute(UIScreen.main.bounds.width),
                    heightDimension: .absolute(49)
                ),
                elementKind: HomeHeaderView.identifier, alignment: .top
            )
        ]
        return section
    }

}

private extension MyChallengeViewController {

    @objc func didTapRightBarButton(_ sender: Any?) {
       print("didTapRightBarButton")
    }
    
}
