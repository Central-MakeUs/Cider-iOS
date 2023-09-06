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
        collectionView.register(MyMissionCell.self, forCellWithReuseIdentifier: MyMissionCell.identifier)
        collectionView.register(HomeHeaderView.self, forSupplementaryViewOfKind: HomeHeaderView.identifier, withReuseIdentifier: HomeHeaderView.identifier)
        collectionView.register(SortingHeaderView.self, forSupplementaryViewOfKind: SortingHeaderView.identifier, withReuseIdentifier: SortingHeaderView.identifier)
        collectionView.register(SeparatorFooterView.self, forSupplementaryViewOfKind: SeparatorFooterView.identifier, withReuseIdentifier: SeparatorFooterView.identifier)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.keyboardDismissMode = .onDrag
        collectionView.delegate = self
        return collectionView
    }()
    
    private lazy var bottomView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.addShadow(location: .top, opacity: 0.2)
        return view
    }()
    
    private lazy var bottomButton: CiderBottomButton = {
        let button = CiderBottomButton(style: .enabled, title: "")
        button.setFont(CustomFont.PretendardBold(size: .xl).font)
        return button
    }()
    
    private lazy var heartButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(didTapChallengeHeart), for: .touchUpInside)
        return button
    }()
    
    private lazy var heartCountLabel: UILabel = {
        let label = UILabel()
        label.text = "2366"
        label.font = CustomFont.PretendardBold(size: .xs).font
        label.textColor = .custom.main
        return label
    }()
    
    // TODO: 그림자 제거용 뷰 수정하기
    private lazy var bottomShadowView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    private lazy var arrowTopButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "arrowTopButton"), for: .normal)
        button.addTarget(self, action: #selector(didTapArrowTop), for: .touchUpInside)
        return button
    }()
    
    private enum InfoSection: Int {
        case menu = 0
        case progress = 1
        case challengeIntro = 2
        case challengeInfo = 3
        case rule = 4
        case mission = 5
        case host = 6
    }
    
    private enum FeedSection: Int {
        case menu = 0
        case myCertify = 1
        case MissionPhoto = 2
        case feed = 3
    }
    
    private var cancellables: Set<AnyCancellable> = .init()
    private var infoDataSource: UICollectionViewDiffableDataSource<InfoSection, Item>?
    private var feedDataSource: UICollectionViewDiffableDataSource<FeedSection, Item>?

    private let challengeType: ChallengeType
    private let viewModel: ChallengeDetailViewModel
    private var menuType: ChallengeDetailMenuType = .info
    
    init(challengeType: ChallengeType, viewModel: ChallengeDetailViewModel) {
        self.challengeType = challengeType
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
        viewModel.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNavigationBar()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        setNavigationBar(backgroundColor: .white, tintColor: .black, shadowColor: .clear)
    }
}

private extension ChallengeDetailViewController {
    
    func setUp() {
        configure()
        setMenu(menuType)
        setNotificationCenter()
        bind()
    }
    
    func bind() {
        viewModel.state.receive(on: DispatchQueue.main)
            .sink { [weak self] state in
                guard let self = self else {
                    return
                }
                switch state {
                case .applysnapshot:
                    self.applySnapshot()
                    self.reloadHeader()
                case .setHeart(let isLike, let likeCount):
                    self.setHeart(isLike: isLike, likeCount: likeCount)
                case .challengeStatus(let status):
                    print("status \(status)")
                    self.setBottomButton(status)
                }
            }
            .store(in: &cancellables)
    }
    
    func configure() {
        view.backgroundColor = .white
        view.addSubviews(collectionView, bottomView, bottomButton, heartButton, heartCountLabel, bottomShadowView, arrowTopButton)
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: -100),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            bottomView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bottomView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bottomView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            bottomView.heightAnchor.constraint(equalToConstant: 56),
            bottomButton.centerYAnchor.constraint(equalTo: bottomView.centerYAnchor),
            bottomButton.leadingAnchor.constraint(equalTo: heartButton.trailingAnchor, constant: 16),
            bottomButton.widthAnchor.constraint(equalToConstant: 262),
            heartButton.heightAnchor.constraint(equalToConstant: 24),
            heartButton.widthAnchor.constraint(equalToConstant: 24),
            heartButton.topAnchor.constraint(equalTo: bottomView.topAnchor, constant: 10),
            heartButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: UIScreen.main.bounds.width*0.1),
            heartCountLabel.centerXAnchor.constraint(equalTo: heartButton.centerXAnchor),
            heartCountLabel.topAnchor.constraint(equalTo: heartButton.bottomAnchor),
            bottomShadowView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bottomShadowView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bottomShadowView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            bottomShadowView.topAnchor.constraint(equalTo: bottomView.bottomAnchor, constant: 0),
            arrowTopButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -82),
            arrowTopButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24)
        ])
    }
    
    func setMenu(_ type: ChallengeDetailMenuType) {
        setDataSource()
        applySnapshot()
    }
    
    func setHeart(isLike: Bool, likeCount: Int) {
        if isLike {
            heartButton.setImage(UIImage(named: "filled_like_24")?.withTintColor(.custom.main ?? .white), for: .normal)
        } else {
            heartButton.setImage(UIImage(named: "line_like_24"), for: .normal)
        }
        heartCountLabel.text = String(likeCount)
        heartCountLabel.textColor = isLike ? .custom.main : .custom.icon
    }
    
    func setBottomButton(_ status: String) {
        bottomButton.setTitle(status, for: .normal)
        switch status {
        case "오늘 참여 인증하기":
            bottomButton.isEnabled = true
            bottomButton.setStyle(.enabled)
            bottomButton.addTarget(self, action: #selector(didTapCertify), for: .touchUpInside)
            
        case "이 챌린지 참여하기":
            bottomButton.isEnabled = true
            bottomButton.setStyle(.enabled)
            bottomButton.addTarget(self, action: #selector(didTapParticipate), for: .touchUpInside)
            
        default:
            bottomButton.setStyle(.disabled)
        }
        if status.contains("챌린지 기다리기") {
            bottomButton.setStyle(.enabled)
            viewModel.didTapParticipateChallenge()
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
        self.navigationController?.navigationBar.topItem?.title = ""
    }
    
    func setDataSource() {
        switch menuType {
        case .feed:
            setUpFeedDataSource()
        case .info:
            setUpInfoDataSource()
        }
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
                if let infoResponse = self.viewModel.infoResponse {
                    cell.setUp(
                        challengeType: self.challengeType,
                        profileUrl: infoResponse.simpleMemberResponseDto.profilePath ?? "",
                        mainTitle: infoResponse.challengeName,
                        participant: "\(infoResponse.participateNum) / \(infoResponse.challengeCapacity)명",
                        status: infoResponse.challengeStatus.convertStatusKorean()
                    )
                } else {
                    cell.setUp(
                        challengeType: self.challengeType,
                        profileUrl: "",
                        mainTitle: "",
                        participant: "0 / 0명",
                        status: ""
                    )
                }
               
                cell.setUpMenu(self.menuType)
                return cell
                
            case .progress:
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProgressBarCell.identifier, for: indexPath) as? ProgressBarCell else {
                    return UICollectionViewCell()
                }
                if let infoResponse = self.viewModel.infoResponse {
                    cell.setUp(
                        averagePercent: Double(infoResponse.challengeConditionResponseDto.averageCondition)*0.01,
                        myPercent: Double(infoResponse.challengeConditionResponseDto.myCondition)*0.01
                    )
                }
               
                return cell
                
            case .challengeIntro:
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ChallengeIntroCell.identifier, for: indexPath) as? ChallengeIntroCell else {
                    return UICollectionViewCell()
                }
                if let infoResponse = self.viewModel.infoResponse {
                    cell.setUp(info: infoResponse.challengeIntro)
                }
               
                return cell
                
            case .challengeInfo:
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ChallengeInfoCell.identifier, for: indexPath) as? ChallengeInfoCell else {
                    return UICollectionViewCell()
                }
                if let infoResponse = self.viewModel.infoResponse {
                    cell.setUp(
                        recruit: infoResponse.challengeInfoResponseDto.recruitPeriod,
                        date: infoResponse.challengeInfoResponseDto.challengePeriod,
                        people: "\(infoResponse.challengeCapacity)명",
                        missionCount: "총 \(infoResponse.challengeInfoResponseDto.certifyNum)회",
                        missionTime: infoResponse.challengeInfoResponseDto.certifyTime,
                        reward: infoResponse.challengeInfoResponseDto.isReward ? "있음" : "없음"
                    )
                }
               
                return cell
                
            case .rule:
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RuleCell.identifier, for: indexPath) as? RuleCell else {
                    return UICollectionViewCell()
                }
                if let infoResponse = self.viewModel.infoResponse {
                    cell.setUp(failText: infoResponse.challengeRuleResponseDto.failureRule)
                }
                return cell
                
            case .mission:
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MissionCell.identifier, for: indexPath) as? MissionCell else {
                    return UICollectionViewCell()
                }
                if let infoResponse = self.viewModel.infoResponse {
                    cell.setUp(
                        mission: infoResponse.certifyMissionResponseDto.certifyMission,
                        successUrl: infoResponse.certifyMissionResponseDto.successExampleImage ?? "",
                        failUrl: infoResponse.certifyMissionResponseDto.failureExampleImage ?? ""
                    )
                }
                return cell
                
            case .host:
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HostCell.identifier, for: indexPath) as? HostCell else {
                    return UICollectionViewCell()
                }
                if let infoResponse = self.viewModel.infoResponse {
                    cell.setUp(
                        nickname: infoResponse.simpleMemberResponseDto.memberName,
                        levelInfo: infoResponse.simpleMemberResponseDto.memberLevelName,
                        hostCountInfo: "\(infoResponse.simpleMemberResponseDto.participateChallengeNum)번째 챌린지",
                        profileUrl: infoResponse.simpleMemberResponseDto.profilePath ?? ""
                    )
                }
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
                    // TODO: 30회 중 몇 회 구현하기
                    headerView?.setUp(leftTitle: "챌린지 현황", rightTitle: "", isClicked: false)
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
                
            case .mission:
                switch elementKind {
                case HomeHeaderView.identifier:
                    let headerView = collectionView.dequeueReusableSupplementaryView(
                        ofKind: elementKind,
                        withReuseIdentifier: HomeHeaderView.identifier,
                        for: indexPath
                    ) as? HomeHeaderView
                    headerView?.setUp(leftTitle: "인증 미션", rightTitle: "", isClicked: false)
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
                
            case .host:
                switch elementKind {
                case HomeHeaderView.identifier:
                    let headerView = collectionView.dequeueReusableSupplementaryView(
                        ofKind: elementKind,
                        withReuseIdentifier: HomeHeaderView.identifier,
                        for: indexPath
                    ) as? HomeHeaderView
                    headerView?.setUp(leftTitle: "챌린지 호스트", rightTitle: "", isClicked: false)
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
                if let infoResponse = self.viewModel.infoResponse {
                    cell.setUp(
                        challengeType: self.challengeType,
                        profileUrl: infoResponse.simpleMemberResponseDto.profilePath ?? "",
                        mainTitle: infoResponse.challengeName,
                        participant: "\(infoResponse.participateNum) / \(infoResponse.challengeCapacity)명",
                        status: infoResponse.challengeStatus.convertStatusKorean()
                    )
                } else {
                    cell.setUp(
                        challengeType: self.challengeType,
                        profileUrl: "",
                        mainTitle: "",
                        participant: "0 / 0명",
                        status: ""
                    )
                }
                cell.setUpMenu(self.menuType)
                return cell
                
            case .myCertify:
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MyMissionCell.identifier, for: indexPath) as? MyMissionCell else {
                    return UICollectionViewCell()
                }
                cell.setUp(count: "")
                return cell
                
            case .MissionPhoto:
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MissionPhotoCell.identifier, for: indexPath) as? MissionPhotoCell else {
                    return UICollectionViewCell()
                }
                if let feedResponse = self.viewModel.feedResponse {
                    cell.setUp(
                        photos: feedResponse.certifyImageUrlList
                    )
                }
                
                return cell
                
            case .feed:
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FeedCell.identifier, for: indexPath) as? FeedCell else {
                    return UICollectionViewCell()
                }
                if let feed = self.viewModel.feedResponse?.simpleCertifyResponseDtoList[indexPath.row],
                   let infoResponse = self.viewModel.infoResponse {
                    cell.setUp(
                        nickname: feed.simpleMemberResponseDto.memberName,
                        level: feed.simpleMemberResponseDto.memberLevelName,
                        date: feed.createdDate.formatYYYYMMDDHHMMDot(),
                        mainTitle: feed.certifyName,
                        subTitle: feed.certifyContent,
                        challengeType: infoResponse.challengeBranch.convertChallengeType(),
                        challengeTitle: infoResponse.challengeName,
                        people: String(infoResponse.participateNum),
                        heart: String(feed.certifyLike),
                        profileImageURL: feed.simpleMemberResponseDto.profilePath ?? "",
                        feedImageURL: feed.certifyImageUrl,
                        isLike: feed.isLike
                    )
                }
                cell.addHeartButtonAction(self, action: #selector(self.didTapFeedHeart))
                cell.meatballButton.addTarget(self, action: #selector(self.didTapFeedMeatball), for: .touchUpInside)
                return cell
                
            case .none:
                return UICollectionViewCell()
            
            }
        })
        
        feedDataSource?.supplementaryViewProvider = { [weak self] collectionView, elementKind, indexPath in
            guard let self = self else {
                return UICollectionReusableView()
            }
            
            let section = FeedSection(rawValue: indexPath.section)
            switch section {
            case .MissionPhoto:
                switch elementKind {
                case HomeHeaderView.identifier:
                    let headerView = collectionView.dequeueReusableSupplementaryView(
                        ofKind: elementKind,
                        withReuseIdentifier: HomeHeaderView.identifier,
                        for: indexPath
                    ) as? HomeHeaderView
                    headerView?.setUp(leftTitle: "활동 한눈에 보기", rightTitle: "", isClicked: false)
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
            case .feed:
                let headerView = collectionView.dequeueReusableSupplementaryView(
                    ofKind: elementKind,
                    withReuseIdentifier: SortingHeaderView.identifier,
                    for: indexPath
                ) as? SortingHeaderView
                headerView?.setUp(text: self.viewModel.filter.korean)
                headerView?.sortingView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.didTapSorting)))
                return headerView
               
            default:
                return nil
            }
        }
        
    }
    
    func reloadHeader() {
        switch menuType {
        case .feed:
            guard let feedSnapshot = feedDataSource?.snapshot() else {
                return
            }
            feedDataSource?.applySnapshotUsingReloadData(feedSnapshot)
        case .info:
            guard let infoSnapshot = infoDataSource?.snapshot() else {
                return
            }
            infoDataSource?.applySnapshotUsingReloadData(infoSnapshot)
        }
    }
    
    func applySnapshot() {
        switch menuType {
        case .info:
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
            snapshot.appendSections([.mission])
            snapshot.appendItems([Item()])
            snapshot.appendSections([.host])
            snapshot.appendItems([Item()])
            infoDataSource?.apply(snapshot, animatingDifferences: false)

        case .feed:
            var snapshot = NSDiffableDataSourceSnapshot<FeedSection, Item>()
            snapshot.appendSections([.menu])
            snapshot.appendItems([Item()])
            snapshot.appendSections([.myCertify])
            snapshot.appendItems([Item()])
            snapshot.appendSections([.MissionPhoto])
            snapshot.appendItems([Item()])
            snapshot.appendSections([.feed])
            snapshot.appendItems(viewModel.feedItems)
            feedDataSource?.apply(snapshot, animatingDifferences: false)
        }
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
                    
                case .mission:
                    return self.missionSectionLayout()
                    
                case .host:
                    return self.hostSectionLayout()
                    
                default:
                    return nil
                }
                
            case .feed:
                let section = FeedSection(rawValue: sectionNumber)
                switch section {
                case .menu:
                    return self.menuSectionLayout()
                    
                case .myCertify:
                    return self.myMissionSectionLayout()
                    
                case .MissionPhoto:
                    return self.missionPhotoSectionLayout()
                
                case .feed:
                    return self.feedSectionLayout()
                    
                default:
                    return nil
                }
            }
        }
    }
    
    func menuSectionLayout() -> NSCollectionLayoutSection {
        let layoutSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .estimated(350)
        )
        
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: .init(
                widthDimension: layoutSize.widthDimension,
                heightDimension: layoutSize.heightDimension
            ),
            subitems: [.init(layoutSize: layoutSize)]
        )
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = .init(top: -100, leading: 0, bottom: 9, trailing: 0)
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
    
    func missionSectionLayout() -> NSCollectionLayoutSection {
        let layoutSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .estimated(492)
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
    
    func hostSectionLayout() -> NSCollectionLayoutSection {
        let layoutSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .estimated(77)
        )
        
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: .init(
                widthDimension: layoutSize.widthDimension,
                heightDimension: layoutSize.heightDimension
            ),
            subitems: [.init(layoutSize: layoutSize)]
        )
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = .init(top: 0, leading: 0, bottom: 40, trailing: 0)
        
        section.boundarySupplementaryItems = [
            NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: .init(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .absolute(65)
                ),
                elementKind: HomeHeaderView.identifier, alignment: .top
            ),
            NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: .init(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .absolute(8)
                ),
                elementKind: SeparatorFooterView.identifier, alignment: .bottom
            )
        ]
        return section
    }
    
    func myMissionSectionLayout() -> NSCollectionLayoutSection {
        let layoutSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .absolute(56)
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
        return section
    }
    
    func missionPhotoSectionLayout() -> NSCollectionLayoutSection {
        let layoutSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .absolute(232)
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
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 24, bottom: 50, trailing: 24)
        
        section.boundarySupplementaryItems = [
            NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: .init(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .absolute(49)
                ),
                elementKind: SortingHeaderView.identifier, alignment: .top
            )
        ]
        return section
    }
    
    func pushMyCertifyViewController() {
        let viewController = MyCertifyViewController(
            viewModel: MyCertifyViewModel(
                usecase: DefaultMyCertifyUsecase(
                    repository: DefaultMyCertifyRepository()
                )
            )
        )
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
}

extension ChallengeDetailViewController: UICollectionViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        scrollView.bounces = scrollView.contentOffset.y > 100
        if scrollView.contentOffset.y > 145 {
            setNavigationBar(backgroundColor: .white, tintColor: .black, shadowColor: .clear)
        } else {
            setNavigationBar(backgroundColor: .clear, tintColor: .white, shadowColor: .clear)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if menuType == .feed {
            let section = FeedSection(rawValue: indexPath.section)
            if section == .myCertify {
                pushMyCertifyViewController()
            }
        }
    }
    
}

private extension ChallengeDetailViewController {
    
    func pushReportViewContoller(userId: Int, certifyId: Int) {
        let viewController = ReportViewController(userId: userId, certifyId: certifyId)
        if let sheet = viewController.sheetPresentationController {
            let identifier = UISheetPresentationController.Detent.Identifier("customMedium")
            let customDetent = UISheetPresentationController.Detent.custom(identifier: identifier) { context in
                return 248-34
            }
            sheet.detents = [customDetent]
            sheet.prefersScrollingExpandsWhenScrolledToEdge = false
            sheet.prefersGrabberVisible = true
        }
        self.present(viewController, animated: true)
    }
    
    func pushCertifyViewController() {
        let viewController = CertifyViewController(
            viewModel: CertifyViewModel(
                usecase: DefaultCertifyUsecase(
                    repository: DefaultCertifyRepository()
                )
            )
        )
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    @objc func didTapSorting(sender: Any?) {
        viewModel.didTapSorting()
    }
    
    @objc func didTapFeedHeart(_ sender: UIButton) {
        guard let cell = sender.superview as? UICollectionViewCell else {
            return
        }
        guard let indexPath = collectionView.indexPath(for: cell) else {
            return
        }
        if let feedResponse = viewModel.feedResponse {
            viewModel.likeFeed(isLike: feedResponse.simpleCertifyResponseDtoList[indexPath.row].isLike, certifyId: feedResponse.simpleCertifyResponseDtoList[indexPath.row].certifyId)
            if feedResponse.simpleCertifyResponseDtoList[indexPath.row].isLike {
                viewModel.feedResponse?.simpleCertifyResponseDtoList[indexPath.row].certifyLike -= 1
            } else {
                viewModel.feedResponse?.simpleCertifyResponseDtoList[indexPath.row].certifyLike += 1
            }
            viewModel.feedResponse?.simpleCertifyResponseDtoList[indexPath.row].isLike.toggle()
        }
        
        reloadHeader()
    }
    
    @objc func didTapFeedMeatball(_ sender: UIButton) {
        guard let cell = sender.superview as? UICollectionViewCell else {
            return
        }
        guard let indexPath = collectionView.indexPath(for: cell) else {
            return
        }
        guard let feed = viewModel.feedResponse?.simpleCertifyResponseDtoList[indexPath.row] else {
            return
        }
        pushReportViewContoller(userId: feed.simpleMemberResponseDto.memberId, certifyId: feed.certifyId)
    }
    
    @objc func didTapChallengeHeart(_ sender: Any?) {
        guard let response = viewModel.infoResponse else {
            return
        }
        viewModel.likeChallenge()
        if response.isLike {
            viewModel.infoResponse?.challengeLikeNum -= 1
            setHeart(isLike: false, likeCount: response.challengeLikeNum-1)
        } else {
            viewModel.infoResponse?.challengeLikeNum += 1
            setHeart(isLike: true, likeCount: response.challengeLikeNum+1)
        }
        viewModel.infoResponse?.isLike.toggle()
        
    }
    
    @objc func didTapParticipate(_ sender: Any?) {
        bottomButton.isEnabled = false
        viewModel.didTapParticipateChallenge()
        self.showToast(message: "챌린지 참여가 완료되었습니다")
    }
    
    @objc func didTapCertify(_ sender: Any?) {
        pushCertifyViewController()
    }
    
    @objc func didTapArrowTop(_ sender: Any?) {
        collectionView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
    }
    
}


#if DEBUG
import SwiftUI

@available(iOS 13.0, *)
struct ChallengeDetailViewController_Preview: PreviewProvider {
    static var devices = ["iPhone 12", "iPhone SE", "iPhone 11 Pro Max"]
    
    static var previews: some View {
        ForEach(devices, id: \.self) { deviceName in
            ChallengeDetailViewController(challengeType: .financialLearning, viewModel: ChallengeDetailViewModel(usecase: DefaultChallengeDetailUsecase(repository: DefaultChallengeDetailRepository()), challengeId: 5))
                .toPreview()
                .previewDevice(PreviewDevice(rawValue: deviceName))
                .previewDisplayName(deviceName)
        }
    }
}
#endif
