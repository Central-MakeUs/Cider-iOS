//
//  HomeViewController.swift
//  Cider
//
//  Created by 임영선 on 2023/07/21.
//

import UIKit
import Combine

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
    
    private let viewModel: HomeViewModel
    private var cancellables = Set<AnyCancellable>()
    
    init(viewModel: HomeViewModel) {
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

private extension HomeViewController {
    
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
                case .applySnapshot(let isSuccess):
                    guard isSuccess else {
                        return
                    }
                    self?.applySnapshot()
                }
            }
            .store(in: &cancellables)
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
    
    func reloadHeader() {
        guard var snapshot = dataSource?.snapshot() else {
            return
        }
        dataSource?.applySnapshotUsingReloadData(snapshot)
    }
    
    func setNavigationBar() {
        let leftView = HomeNavigationView()
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: leftView)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: rightBarButton)
    }
    
    func setUpDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, Item>(collectionView: collectionView, cellProvider: { [weak self] collectionView, indexPath, itemIdentifier in
            guard let self = self else {
                return UICollectionViewCell()
            }
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
                if let challenge = self.viewModel.popularChallanges?[indexPath.row] {
                    cell.setUp(
                        type: challenge.interestField.convertChallengeType(),
                        isReward: challenge.isReward,
                        date: "\(challenge.challengePeriod)주",
                        ranking: "\(indexPath.row+1)위",
                        title: challenge.challengeName,
                        status: challenge.challengeStatus.convertStatusKorean(),
                        people: "\(challenge.participateNum)명 모집중",
                        isPublic: challenge.isOfficial,
                        dDay: "D-\(challenge.recruitLeft)"
                    )
                }
                
                return cell
                
            case .publicChallenge:
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ChallengeHomeCell.identifier, for: indexPath) as? ChallengeHomeCell else {
                    return UICollectionViewCell()
                }
                if let challenge = self.viewModel.publicChallanges?[indexPath.row] {
                    cell.setUp(
                        type: challenge.interestField.convertChallengeType(),
                        isReward: challenge.isReward,
                        date: "\(challenge.challengePeriod)주",
                        ranking: nil,
                        title: challenge.challengeName,
                        status: challenge.challengeStatus.convertStatusKorean(),
                        people: "\(challenge.participateNum)명 모집중",
                        isPublic: challenge.isOfficial,
                        dDay: "D-\(challenge.recruitLeft)"
                    )
                }
                return cell
                
            case .category:
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ChallengeHomeCell.identifier, for: indexPath) as? ChallengeHomeCell else {
                    return UICollectionViewCell()
                }
                let challenge = self.viewModel.categoryChallenges[indexPath.row]
                cell.setUp(
                    type: challenge.interestField.convertChallengeType(),
                    isReward: challenge.isReward,
                    date: "\(challenge.challengePeriod)주",
                    ranking: nil,
                    title: challenge.challengeName,
                    status: challenge.challengeStatus.convertStatusKorean(),
                    people: "\(challenge.participateNum)명 모집중",
                    isPublic: challenge.isOfficial,
                    dDay: "D-\(challenge.recruitLeft)"
                )
                
                return cell
                
            case .feed:
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FeedCell.identifier, for: indexPath) as? FeedCell else {
                    return UICollectionViewCell()
                }
                let feed = self.viewModel.feeds[indexPath.row]
                cell.setUp(
                    nickname: feed.simpleMemberResponseDto.memberName,
                    level: feed.simpleMemberResponseDto.memberLevelName,
                    date: feed.createdDate.formatYYYYMMDDHHMMDot(),
                    mainTitle: feed.certifyName,
                    subTitle: feed.certifyContent,
                    challengeType: feed.simpleChallengeResponseDto.challengeBranch.convertChallengeType(),
                    challengeTitle: feed.simpleChallengeResponseDto.challengeName,
                    people: String(feed.simpleChallengeResponseDto.participateNum),
                    heart: String(feed.certifyLike),
                    profileImageURL: feed.simpleMemberResponseDto.profilePath,
                    feedImageURL: feed.certifyImageUrl
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
                headerView?.setUp(leftTitle: "카테고리", rightTitle: "전체 챌린지 보기", selectedType: self.viewModel.categoryType)
                headerView?.addActionRightTitle(self, action: #selector(self.didTapAllChallenge))
                headerView?.financialLearningView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.didTapFinancialLearning)))
                headerView?.financialTechView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.didTapFinancialTech)))
                headerView?.moneySavingView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.didTapMoneySaving)))
                headerView?.moneyManagementView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.didTapMoneyManagement)))
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
        snapshot.appendItems(viewModel.popularItems)
        
        snapshot.appendSections([.publicChallenge])
        snapshot.appendItems(viewModel.publicItems)

        snapshot.appendSections([.category])
        snapshot.appendItems(viewModel.categoryItems)
        
        snapshot.appendSections([.feed])
        snapshot.appendItems(viewModel.feedItems)
        
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
    
    @objc func didTapFinancialTech(_ sender: Any?) {
        viewModel.categoryType = .financialTech
        viewModel.getCategory(viewModel.categoryType.alphabet)
        reloadHeader()
    }
    
    @objc func didTapFinancialLearning(_ sender: Any?) {
        viewModel.categoryType = .financialLearning
        viewModel.getCategory(viewModel.categoryType.alphabet)
        reloadHeader()
    }
    
    @objc func didTapMoneySaving(_ sender: Any?) {
        viewModel.categoryType = .moneySaving
        viewModel.getCategory(viewModel.categoryType.alphabet)
        reloadHeader()
    }
    
    @objc func didTapMoneyManagement(_ sender: Any?) {
        viewModel.categoryType = .moneyManagement
        viewModel.getCategory(viewModel.categoryType.alphabet)
        reloadHeader()
    }
    
}

private extension HomeViewController {
    
    func pushHomeDetailViewController(_ type: HomeDetailType) {
        let viewController = HomeDetailViewController(
            homeDetailType: type,
            viewModel: HomeDetailViewModel(
                usecase: DefaultHomeDetailUsecase(
                    repository: DefaultHomeDetailRepository()
                )
            )
        )
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
