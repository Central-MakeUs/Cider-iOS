//
//  ChallengeDetailViewController.swift
//  Cider
//
//  Created by 임영선 on 2023/07/28.
//

import UIKit
import Combine

enum ChallengeDetailMenuType {
    case info
    case feed
}

class ChallengeDetailViewController: UIViewController {
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        collectionView.register(ChallengeDetailMenuCell.self, forCellWithReuseIdentifier: ChallengeDetailMenuCell.identifier)
        collectionView.register(ProgressBarCell.self, forCellWithReuseIdentifier: ProgressBarCell.identifier)
        collectionView.register(ChallengeIntroCell.self, forCellWithReuseIdentifier: ChallengeIntroCell.identifier)
        collectionView.register(ChallengeInfoCell.self, forCellWithReuseIdentifier: ChallengeInfoCell.identifier)
        collectionView.register(RuleCell.self, forCellWithReuseIdentifier: RuleCell.identifier)
        collectionView.register(MissionCell.self, forCellWithReuseIdentifier: MissionCell.identifier)
        collectionView.register(MissionPhotoCell.self, forCellWithReuseIdentifier: MissionPhotoCell.identifier)
        collectionView.register(HostCell.self, forCellWithReuseIdentifier: HostCell.identifier)
        collectionView.register(FeedCell.self, forCellWithReuseIdentifier: FeedCell.identifier)
        collectionView.register(HomeHeaderView.self, forSupplementaryViewOfKind: HomeHeaderView.identifier, withReuseIdentifier: HomeHeaderView.identifier)
        collectionView.register(SeparatorFooterView.self, forSupplementaryViewOfKind: SeparatorFooterView.identifier, withReuseIdentifier: SeparatorFooterView.identifier)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.keyboardDismissMode = .onDrag
        collectionView.delegate = self
        return collectionView
    }()
    
    private enum InfoSection: Int {
        case menu = 0
        case progress = 1
        case challengeIntro = 2
        case challengeInfo = 3
        case rule = 4
    }
    
    private enum FeedSection: Int {
        case menu = 0
        case myMission = 1
        case MissionPhoto = 2
        case feed = 3
    }
    
    private var cancellables: Set<AnyCancellable> = .init()
    private var infoDataSource: UICollectionViewDiffableDataSource<InfoSection, Item>?
    private var feedDataSource: UICollectionViewDiffableDataSource<FeedSection, Item>?

    private let challengeType: ChallengeType
    private var menuType: ChallengeDetailMenuType = .info
    
    init(challengeType: ChallengeType) {
        self.challengeType = challengeType
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
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        setNavigationBar(backgroundColor: .white, tintColor: .black)
    }
}

private extension ChallengeDetailViewController {
    
    func setUp() {
        configure()
        setMenu(menuType)
        setNotificationCenter()
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
    
    func setMenu(_ type: ChallengeDetailMenuType) {
        switch type {
        case .info:
            setUpInfoDataSource()
            applyInfoSnapshot()
        case .feed:
            setUpFeedDataSource()
            applyFeedSnapshot()
        }
    }
    
    func setNotificationCenter() {
        NotificationCenter.default.publisher(for: .tapChallengeDetailMenu)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] notification in
                guard let self = self else {
                    return
                }
                guard let menuType = notification.object as? ChallengeDetailMenuType else {
                    return
                }
                self.menuType = menuType
                self.setMenu(menuType)
            }
            .store(in: &cancellables)
    }
    
    func setNavigationBar() {
        self.navigationController?.navigationBar.scrollEdgeAppearance?.shadowColor = .clear
        self.navigationController?.navigationBar.standardAppearance.shadowColor = .clear
        setNavigationBar(backgroundColor: challengeType.color, tintColor: .white)
    }
    
    func setNavigationBar(backgroundColor: UIColor?, tintColor: UIColor) {
        self.navigationController?.navigationBar.scrollEdgeAppearance?.backgroundColor = backgroundColor
        self.navigationController?.navigationBar.scrollEdgeAppearance?.titleTextAttributes = [.foregroundColor: tintColor]
        self.navigationController?.navigationBar.standardAppearance.backgroundColor = backgroundColor
        self.navigationController?.navigationBar.standardAppearance.titleTextAttributes = [.foregroundColor: tintColor]
    }
    
    func setUpInfoDataSource() {
        infoDataSource = UICollectionViewDiffableDataSource<InfoSection, Item>(collectionView: collectionView, cellProvider: { [weak self] collectionView, indexPath, itemIdentifier in
            guard let self = self else {
                return UICollectionViewCell()
            }
            let section = InfoSection(rawValue: indexPath.section)
            switch section {
            case .menu:
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ChallengeDetailMenuCell.identifier, for: indexPath) as? ChallengeDetailMenuCell else {
                    return UICollectionViewCell()
                }
                cell.setUp(
                    challengeType: self.challengeType,
                    profileImage: UIImage(named: "sample"),
                    mainTitle: "만보 걷기~~~~~~",
                    participant: "29 / 30명",
                    status: "진행중 D-6"
                )
                cell.setUpMenu(self.menuType)
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
                
            case .rule:
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RuleCell.identifier, for: indexPath) as? RuleCell else {
                    return UICollectionViewCell()
                }
                cell.setUp(failText: "30회 미만 인증")
                return cell
                
            case .none:
                return UICollectionViewCell()
            }
        })
        
        
        infoDataSource?.supplementaryViewProvider = { [weak self] collectionView, elementKind, indexPath in
            guard let self = self else {
                return UICollectionReusableView()
            }
            
            let section = InfoSection(rawValue: indexPath.section)
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
                
            case .rule:
                switch elementKind {
                case HomeHeaderView.identifier:
                    let headerView = collectionView.dequeueReusableSupplementaryView(
                        ofKind: elementKind,
                        withReuseIdentifier: HomeHeaderView.identifier,
                        for: indexPath
                    ) as? HomeHeaderView
                    headerView?.setUp(leftTitle: "챌린지 규칙", rightTitle: "", isClicked: false)
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
    
    func setUpFeedDataSource() {
        feedDataSource = UICollectionViewDiffableDataSource<FeedSection, Item>(collectionView: collectionView, cellProvider: { [weak self] collectionView, indexPath, itemIdentifier in
            guard let self = self else {
                return UICollectionViewCell()
            }
            let section = FeedSection(rawValue: indexPath.section)
            switch section {
            case .menu:
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ChallengeDetailMenuCell.identifier, for: indexPath) as? ChallengeDetailMenuCell else {
                    return UICollectionViewCell()
                }
                cell.setUp(
                    challengeType: self.challengeType,
                    profileImage: UIImage(named: "sample"),
                    mainTitle: "만보 걷기~~~~~~",
                    participant: "29 / 30명",
                    status: "진행중 D-6"
                )
                cell.setUpMenu(self.menuType)
                return cell
                
            case .myMission:
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ChallengeDetailMenuCell.identifier, for: indexPath) as? ChallengeDetailMenuCell else {
                    return UICollectionViewCell()
                }
                cell.setUp(
                    challengeType: self.challengeType,
                    profileImage: UIImage(named: "sample"),
                    mainTitle: "만보 걷기~~~~~~",
                    participant: "29 / 30명",
                    status: "진행중 D-6"
                )
                return cell
                
            default:
                return UICollectionViewCell()
            }
        })
        
        
        feedDataSource?.supplementaryViewProvider = { [weak self] collectionView, elementKind, indexPath in
            guard let self = self else {
                return UICollectionReusableView()
            }
            
            let section = FeedSection(rawValue: indexPath.section)
            switch section {
            case .myMission:
                let headerView = collectionView.dequeueReusableSupplementaryView(
                    ofKind: elementKind,
                    withReuseIdentifier: HomeHeaderView.identifier,
                    for: indexPath
                ) as? HomeHeaderView
                headerView?.setUp(leftTitle: "나의 인증글", rightTitle: "", isClicked: true)
                return headerView ?? UICollectionReusableView()
                
            default:
                return nil
            }
        }
        
    }
    
    func applyInfoSnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<InfoSection, Item>()
        snapshot.appendSections([.menu])
        snapshot.appendItems([Item()])
        snapshot.appendSections([.progress])
        snapshot.appendItems([Item()])
        snapshot.appendSections([.challengeIntro])
        snapshot.appendItems([Item()])
        snapshot.appendSections([.challengeInfo])
        snapshot.appendItems([Item()])
        snapshot.appendSections([.rule])
        snapshot.appendItems([Item()])
        infoDataSource?.apply(snapshot)
    }
    
    func applyFeedSnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<FeedSection, Item>()
        snapshot.appendSections([.menu])
        snapshot.appendItems([Item()])
        snapshot.appendSections([.myMission])
        snapshot.appendItems([Item()])
        feedDataSource?.apply(snapshot)
    }
    
    func createLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { [weak self] (sectionNumber, _) -> NSCollectionLayoutSection? in
            guard let self = self else {
                return nil
            }
            switch self.menuType {
            case .info:
                let section = InfoSection(rawValue: sectionNumber)
                switch section {
                case .menu:
                    return self.menuSectionLayout()
                    
                case .progress:
                    return self.progressSectionLayout()
                    
                case .challengeIntro:
                    return self.challengeIntroSectionLayout()
                    
                case .challengeInfo:
                    return self.challengeInfoSectionLayout()
                    
                case .rule:
                    return self.ruleSectionLayout()
                    
                default:
                    return nil
                }
                
            case .feed:
                let section = FeedSection(rawValue: sectionNumber)
                switch section {
                case .menu:
                    return self.menuSectionLayout()
                    
                case .myMission:
                    return self.myMissionSectionLayout()
                    
                default:
                    return nil
                }
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
    
    func ruleSectionLayout() -> NSCollectionLayoutSection {
        let layoutSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .estimated(100)
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
    
    func myMissionSectionLayout() -> NSCollectionLayoutSection {
        let layoutSize = NSCollectionLayoutSize(
            widthDimension: .absolute(100),
            heightDimension: .absolute(100)
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
            )
        ]
        return section
    }
    
}

extension ChallengeDetailViewController: UICollectionViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y > 145 {
            setNavigationBar(backgroundColor: .white, tintColor: .black)
        } else {
            setNavigationBar(backgroundColor: challengeType.color, tintColor: .white)
        }
    }
    
}


#if DEBUG
import SwiftUI

@available(iOS 13.0, *)
struct ChallengeDetailViewController_Preview: PreviewProvider {
    static var devices = ["iPhone 12", "iPhone SE", "iPhone 11 Pro Max"]
    
    static var previews: some View {
        ForEach(devices, id: \.self) { deviceName in
            ChallengeDetailViewController(challengeType: .financialLearning)
                .toPreview()
                .previewDevice(PreviewDevice(rawValue: deviceName))
                .previewDisplayName(deviceName)
        }
    }
}
#endif
