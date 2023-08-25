//
//  MyChallengeViewController.swift
//  Cider
//
//  Created by 임영선 on 2023/07/25.
//

import UIKit
import Combine

final class MyChallengeViewController: UIViewController {
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        collectionView.register(ClosedChallengeCell.self, forCellWithReuseIdentifier: ClosedChallengeCell.identifier)
        collectionView.register(OngoingCell.self, forCellWithReuseIdentifier: OngoingCell.identifier)
        collectionView.register(ReviewCell.self, forCellWithReuseIdentifier: ReviewCell.identifier)
        collectionView.register(MyChallengeEmptyCell.self, forCellWithReuseIdentifier: MyChallengeEmptyCell.identifier)
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
    private let viewModel: MyChallengeViewModel
    private var cancellables = Set<AnyCancellable>()
    
    init(viewModel: MyChallengeViewModel) {
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

private extension MyChallengeViewController {
    
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
                    self?.reloadHeader()
                    
                case .sendMessage(let message):
                    self?.showAlert(message: message)
                }
            }
            .store(in: &cancellables)
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
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.navigationBar.topItem?.title = ""
        self.navigationItem.title = "내 챌린지"
        setNavigationBar(backgroundColor: .white, tintColor: .black, shadowColor: .clear)
    }
    
    func setUpDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, Item>(collectionView: collectionView, cellProvider: { [weak self] collectionView, indexPath, itemIdentifier in
            guard let self = self else {
                return UICollectionViewCell()
            }
            let section = Section(rawValue: indexPath.section)
            switch section {
            case .onGoingChallenge:
                if self.viewModel.ongoingChallenges.count > 0 {
                    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: OngoingCell.identifier, for: indexPath) as? OngoingCell else {
                        return UICollectionViewCell()
                    }
                    let challenge = self.viewModel.ongoingChallenges[indexPath.row]
                    cell.setUp(
                        mainTitle: challenge.challengeName,
                        challengeType: challenge.challengeBranch.convertChallengeType(),
                        onGoing: "챌린지 진행 +\(challenge.ongoingDate)일",
                        countText: "\(challenge.challengePeriod)회 중 \(challenge.certifyNum)회 달성"
                    )
                    return cell
                } else {
                    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MyChallengeEmptyCell.identifier, for: indexPath) as? MyChallengeEmptyCell else {
                        return UICollectionViewCell()
                    }
                    cell.setUp(title: "진행중인 챌린지가 없습니다")
                    return cell
                }
                
                
            case .closedChallenge:
                if self.viewModel.passedChallenges.count > 0 {
                    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ClosedChallengeCell.identifier, for: indexPath) as? ClosedChallengeCell else {
                        return UICollectionViewCell()
                    }
                    let challenge = self.viewModel.passedChallenges[indexPath.row]
                    cell.setUp(
                        type: challenge.challengeBranch.convertChallengeType(),
                        isReward: challenge.isReward,
                        date: "\(challenge.challengePeriod)주",
                        title: challenge.challengeName,
                        status: challenge.isSuccess,
                        people: "\(challenge.successNum)명 챌린지 성공",
                        isPublic: challenge.isOfficial
                    )
                    cell.challengeHomeView.setClosedChallenge(.fail)
                    cell.setUp(challengeId: challenge.challengeId)
                    cell.challengeHomeView.addActionHeart(self, action: #selector(self.didTapDeleteClosedChallenge))
                    return cell
                } else {
                    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MyChallengeEmptyCell.identifier, for: indexPath) as? MyChallengeEmptyCell else {
                        return UICollectionViewCell()
                    }
                    cell.setUp(title: "최근 종료된 챌린지가 없습니다")
                    return cell
                }
                
                
            case .reviewChallenge:
                if self.viewModel.judgingChallenges.count > 0 {
                    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ReviewCell.identifier, for: indexPath) as? ReviewCell else {
                        return UICollectionViewCell()
                    }
                   
                    let challenge = self.viewModel.judgingChallenges[indexPath.row]
                    if let reviewType = challenge.judgingStatus.convertReviewType() {
                        cell.setUp(
                            title: challenge.challengeName,
                            challengeType: challenge.challengeBranch.convertChallengeType(),
                            reviewType: reviewType,
                            challengeSuccessMessage: "2023.00.00 챌린지 모집 시작"
                        )
                        cell.setUp(challengeId: challenge.challengeId)
                        cell.addDeleteViewGesture(self, action: #selector(self.didTapDeleteReviewChallenge))
                    }
                   
                    return cell
                } else {
                    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MyChallengeEmptyCell.identifier, for: indexPath) as? MyChallengeEmptyCell else {
                        return UICollectionViewCell()
                    }
                    cell.setUp(title: "심사중인 챌린지가 없습니다")
                    return cell
                }
                
                
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
                    if let ongoingChallengeListResponseDto = self.viewModel.ongoingChallengeListResponseDto {
                        headerView?.setUp(
                            leftTitle: "진행중인 챌린지",
                            rightTitle: "\(ongoingChallengeListResponseDto.ongoingChallengeNum)개",
                            isClicked: false
                        )
                    } else {
                        headerView?.setUp(
                            leftTitle: "진행중인 챌린지",
                            rightTitle: "0개",
                            isClicked: false
                        )
                    }
                    
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
                    if let passedChallengeListResponseDto = self.viewModel.passedChallengeListResponseDto {
                        headerView?.setUp(
                            leftTitle: "최근 종료된 챌린지",
                            rightTitle: "\(passedChallengeListResponseDto.passedChallengeNum)개",
                            isClicked: false
                        )
                    } else {
                        headerView?.setUp(
                            leftTitle: "최근 종료된 챌린지",
                            rightTitle: "0개",
                            isClicked: false
                        )
                    }
                   
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
                if let judgingChallengeListResponseDto = self.viewModel.judgingChallengeListResponseDto {
                    headerView?.setUp(
                        leftTitle: "심사중인 챌린지",
                        rightTitle: "\(judgingChallengeListResponseDto.judgingChallengeNum)개",
                        isClicked: false
                    )
                    headerView?.setReviewSuccessLabel(successCount: judgingChallengeListResponseDto.completeNum)
                } else {
                    headerView?.setUp(
                        leftTitle: "심사중인 챌린지",
                        rightTitle: "0개",
                        isClicked: false
                    )
                    headerView?.setReviewSuccessLabel(successCount: 0)
                }
                
                return headerView ?? UICollectionReusableView()
                
            default:
                return nil
            }
        }
    }
    
    
    func applySnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
        snapshot.appendSections([.onGoingChallenge])
        snapshot.appendItems(viewModel.ongoingItems)
        snapshot.appendSections([.closedChallenge])
        snapshot.appendItems(viewModel.passedItems)
        snapshot.appendSections([.reviewChallenge])
        snapshot.appendItems(viewModel.judgingItems)
        dataSource?.apply(snapshot)
    }
    
    func reloadHeader() {
        guard let snapshot = dataSource?.snapshot() else {
            return
        }
        dataSource?.applySnapshotUsingReloadData(snapshot)
    }
    
    func createLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { [weak self] (sectionNumber, _) -> NSCollectionLayoutSection? in
            guard let self = self else {
                return nil
            }
            let section = Section(rawValue: sectionNumber)
            switch section {
            case .onGoingChallenge:
                return self.viewModel.ongoingChallenges.count > 0 ? self.onGoingSectionLayout() : self.emptyLayout()
                
            case .closedChallenge:
                return self.viewModel.passedChallenges.count > 0 ? self.challengeSectionLayout() : self.emptyLayout()
                
            case .reviewChallenge:
                return self.viewModel.judgingChallenges.count > 0 ? self.reviewSectionLayout() : self.emptyLayout()
                
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
    
    func emptyLayout() -> NSCollectionLayoutSection {
        let layoutSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .absolute(163)
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
    
    @objc func didTapDeleteClosedChallenge(_ sender: UIButton) {
        let contentView = sender.superview?.superview
       
        guard let cell = contentView?.superview as? UICollectionViewCell else {
            return
        }
        
        guard let indexPath = collectionView.indexPath(for: cell) else {
            return
        }
        let challengeId = viewModel.passedChallenges[indexPath.row].challengeId
        print(challengeId)
        viewModel.didTapDeleteChallenge(challengeId: challengeId)
    }
    
    @objc func didTapDeleteReviewChallenge(_ sender: UITapGestureRecognizer) {
        guard let view = sender.view else {
            return
        }
       
        guard let cell = view.superview as? UICollectionViewCell else {
            return
        }
        
        guard let indexPath = collectionView.indexPath(for: cell) else {
            return
        }
        let challengeId = viewModel.judgingChallenges[indexPath.row].challengeId
        viewModel.didTapDeleteChallenge(challengeId: challengeId)
    }
    
}
