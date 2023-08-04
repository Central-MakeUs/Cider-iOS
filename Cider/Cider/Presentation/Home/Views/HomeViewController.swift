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
        collectionView.register(FeedCell.self, forCellWithReuseIdentifier: FeedCell.identifier)
        collectionView.register(HomeHeaderView.self, forSupplementaryViewOfKind: HomeHeaderView.identifier, withReuseIdentifier: HomeHeaderView.identifier)
        collectionView.register(CategoryHeaderView.self, forSupplementaryViewOfKind: CategoryHeaderView.identifier, withReuseIdentifier: CategoryHeaderView.identifier)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.keyboardDismissMode = .onDrag
        collectionView.delegate = self
        return collectionView
    }()
    
    private lazy var rightBarButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "line_mychallenge_24"), for: .normal)
        button.addTarget(self, action: #selector(didTapMyChallenge), for: .touchUpInside)
        return button
    }()
    
    private lazy var arrowTopButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "arrowTopButton"), for: .normal)
        button.addTarget(self, action: #selector(didTapArrowTop), for: .touchUpInside)
        return button
    }()
    
    private enum Section: Int {
        case banner = 0
        case popluarChallenge = 1
        case publicChallenge = 2
        case category = 3
        case feed = 4
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
                    isPublic: true,
                    dDay: "D-12"
                )
                return cell
                
            case .feed:
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FeedCell.identifier, for: indexPath) as? FeedCell else {
                    return UICollectionViewCell()
                }
                cell.setUp(
                    nickname: "화이팅",
                    level: "LV 1",
                    date: "23.05.15 15:45",
                    mainTitle: "오늘 챌린지 인증하는데",
                    subTitle: "챌린지 하면 할수록 너무 힘들구 어쩌고 저쩌고 근데 할 수 있다 챌린지 하면 할수록 챌린지 하면 할수록\n챌린지 하면 할수록 너무 힘들구 어쩌고 저쩌고 근데 할 수 있다\n챌린지 하면 할수록 너무 힘들구 어쩌고 저쩌고 근데 할 수 있다",
                    challengeType: .financialTech,
                    challengeTitle: "하루에 만보 걷기 챌린지 하루를 열심히 살아보아요!!!",
                    people: "231",
                    heart: "1111"
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
            case .popluarChallenge:
                let headerView = collectionView.dequeueReusableSupplementaryView(
                    ofKind: elementKind,
                    withReuseIdentifier: HomeHeaderView.identifier,
                    for: indexPath
                ) as? HomeHeaderView
                headerView?.setUp(leftTitle: "인기 챌린지", rightTitle: "더보기", isClicked: true)
                headerView?.addActionRightTitle(self, action: #selector(self.didTapPopularChallenge))
                return headerView ?? UICollectionReusableView()
                
            case .publicChallenge:
                let headerView = collectionView.dequeueReusableSupplementaryView(
                    ofKind: elementKind,
                    withReuseIdentifier: HomeHeaderView.identifier,
                    for: indexPath
                ) as? HomeHeaderView
                headerView?.setUp(leftTitle: "바로 참여 가능! 공식 챌린지", rightTitle: "더보기", isClicked: true)
                headerView?.addActionRightTitle(self, action: #selector(self.didTapPublicChallenge))
                return headerView ?? UICollectionReusableView()
                
            case .category:
                let headerView = collectionView.dequeueReusableSupplementaryView(
                    ofKind: elementKind,
                    withReuseIdentifier: CategoryHeaderView.identifier,
                    for: indexPath
                ) as? CategoryHeaderView
                headerView?.setUp(leftTitle: "카테고리", rightTitle: "전체 챌린지 보기", selectedType: .financialTech)
                headerView?.addActionRightTitle(self, action: #selector(self.didTapAllChallenge))
                return headerView ?? UICollectionReusableView()
                
            case .feed:
                let headerView = collectionView.dequeueReusableSupplementaryView(
                    ofKind: elementKind,
                    withReuseIdentifier: HomeHeaderView.identifier,
                    for: indexPath
                ) as? HomeHeaderView
                headerView?.setUp(leftTitle: "추천 피드", rightTitle: "오늘의 활동 추천 피드", isClicked: false)
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
        snapshot.appendSections([.feed])
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
                
            case .feed:
                return self?.feedSectionLayout()
                
            default:
                return nil
            }
        }
    }
    
    func bannerSectionLayout() -> NSCollectionLayoutSection {
        let layoutSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .fractionalWidth(0.72)
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
        section.contentInsets = .init(top: 0, leading: 24, bottom: 32, trailing: 24)
        
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
        section.contentInsets = .init(top: 0, leading: 24, bottom: 32, trailing: 24)
        
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
    
    func feedSectionLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .estimated(149+UIScreen.main.bounds.width+41+41-16-16)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .estimated(149+UIScreen.main.bounds.width+41+41-16-16)
        )
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize,
                                                     subitems: [item])
        group.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 8, trailing: 0)
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 24, bottom: 0, trailing: 24)
        
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
    
}

private extension HomeViewController {
    
    @objc func didTapPopularChallenge(_ sender: Any?) {
        pushHomeDetailViewController(.popularChallenge)
    }
    
    @objc func didTapPublicChallenge(_ sender: Any?) {
        pushHomeDetailViewController(.publicChallenge)
    }
    
    @objc func didTapAllChallenge(_ sender: Any?) {
        pushHomeDetailViewController(.allChallenge)
    }
    
    @objc func didTapArrowTop(_ sender: Any?) {
        collectionView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
    }
    
    @objc func didTapMyChallenge(_ sender: Any?) {
        pushMyChallengeViewController()
    }
    
}

private extension HomeViewController {
    
    func pushHomeDetailViewController(_ type: HomeDetailType) {
        let viewController = HomeDetailViewController(homeDetailType: type)
        viewController.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    func pushMyChallengeViewController() {
        let viewController = MyChallengeViewController()
        viewController.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    func pushChallengeDetailViewController(_ type: ChallengeType) {
        let viewController = ChallengeDetailViewController(challengeType: type)
        viewController.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
}


extension HomeViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let section = Section(rawValue: indexPath.section)
        switch section {
        case .popluarChallenge:
            pushChallengeDetailViewController(.financialLearning)
            
        case .publicChallenge:
            pushChallengeDetailViewController(.moneyManagement)
            
        case .category:
            pushChallengeDetailViewController(.financialTech)
            
        default:
            break
        }
    }
    
}
