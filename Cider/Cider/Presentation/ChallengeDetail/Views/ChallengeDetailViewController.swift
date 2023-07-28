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
        collectionView.register(ProgressBarCell.self, forCellWithReuseIdentifier: ProgressBarCell.identifier)
        collectionView.register(ChallengeIntroCell.self, forCellWithReuseIdentifier: ChallengeIntroCell.identifier)
        collectionView.register(ChallengeInfoCell.self, forCellWithReuseIdentifier: ChallengeInfoCell.identifier)
        collectionView.register(HomeHeaderView.self, forSupplementaryViewOfKind: HomeHeaderView.identifier, withReuseIdentifier: HomeHeaderView.identifier)
        collectionView.register(SeparatorFooterView.self, forSupplementaryViewOfKind: SeparatorFooterView.identifier, withReuseIdentifier: SeparatorFooterView.identifier)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.keyboardDismissMode = .onDrag
        return collectionView
    }()
    
    private enum Section: Int {
        case menu = 0
        case progress = 1
        case challengeIntro = 2
        case challengeInfo = 3
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
                
            case .challengeIntro:
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ChallengeIntroCell.identifier, for: indexPath) as? ChallengeIntroCell else {
                    return UICollectionViewCell()
                }
                cell.setUp(info: "하루 한번 아침에 일어나서 물이 담긴 컵사진 인증하루 만보 걷기 챌린지는 쉽고 재미있게 만보를 걸을 수있는 챌린지로, 제가 맨날 일하다가 한번 입원하고 나서 심각성을 느끼고 만들게 된 멋진 챌린지\n\n안녕하세요")
                return cell
                
            case .challengeInfo:
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ChallengeInfoCell.identifier, for: indexPath) as? ChallengeInfoCell else {
                    return UICollectionViewCell()
                }
                cell.setUp(
                    recruit: "06월 26일(월) - 06월 28일(수)",
                    date: "6월 30일(금) - 07월 7일(금)",
                    people: "30명",
                    missionCount: "총 14회",
                    missionTime: "매일 자정까지",
                    reward: "있음"
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
                
            case .challengeIntro:
                switch elementKind {
                case HomeHeaderView.identifier:
                    let headerView = collectionView.dequeueReusableSupplementaryView(
                        ofKind: elementKind,
                        withReuseIdentifier: HomeHeaderView.identifier,
                        for: indexPath
                    ) as? HomeHeaderView
                    headerView?.setUp(leftTitle: "챌린지 소개", rightTitle: "", isClicked: false)
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
                
            case .challengeInfo:
                switch elementKind {
                case HomeHeaderView.identifier:
                    let headerView = collectionView.dequeueReusableSupplementaryView(
                        ofKind: elementKind,
                        withReuseIdentifier: HomeHeaderView.identifier,
                        for: indexPath
                    ) as? HomeHeaderView
                    headerView?.setUp(leftTitle: "챌린지 정보", rightTitle: "", isClicked: false)
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
        snapshot.appendSections([.challengeIntro])
        snapshot.appendItems([Item()])
        snapshot.appendSections([.challengeInfo])
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
                
            case .challengeIntro:
                return self?.challengeIntroSectionLayout()
                
            case .challengeInfo:
                return self?.challengeInfoSectionLayout()
                
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
        section.contentInsets = .init(top: 0, leading: 0, bottom: 9, trailing: 0)
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
    
    func challengeIntroSectionLayout() -> NSCollectionLayoutSection {
        let layoutSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .estimated(65)
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
        
        let header =  NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: .init(
                widthDimension: .absolute(view.safeAreaLayoutGuide.layoutFrame.width),
                heightDimension: .absolute(5)
            ),
            elementKind: HomeHeaderView.identifier, alignment: .top
        )
        header.contentInsets = .init(top: 24, leading: 0, bottom: 8, trailing: 0)
        
        // TODO: header top에 패딩 주기
        section.boundarySupplementaryItems = [
            NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: .init(
                    widthDimension: .absolute(view.safeAreaLayoutGuide.layoutFrame.width),
                    heightDimension: .absolute(65)
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
    
    func challengeInfoSectionLayout() -> NSCollectionLayoutSection {
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
                    heightDimension: .absolute(65)
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
