//
//  MyCertifyViewController.swift
//  Cider
//
//  Created by 임영선 on 2023/08/15.
//

import UIKit
import Combine

final class MyCertifyViewController: UIViewController {
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        collectionView.register(FeedCell.self, forCellWithReuseIdentifier: FeedCell.identifier)
        collectionView.register(MyCertifyHeaderView.self, forSupplementaryViewOfKind: MyCertifyHeaderView.identifier, withReuseIdentifier: MyCertifyHeaderView.identifier)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.keyboardDismissMode = .onDrag
        return collectionView
    }()
    
    let rightBarLabel: UILabel = {
        let label = UILabel()
        label.font = CustomFont.PretendardBold(size: .lg).font
        label.textColor = .custom.gray5
        return label
    }()
    
    private enum Section: Int {
        case feed = 0
    }
    
    private var dataSource: UICollectionViewDiffableDataSource<Section, Item>?

    private let viewModel: MyCertifyViewModel
    private var cancellables = Set<AnyCancellable>()
    
    init(viewModel: MyCertifyViewModel) {
        self.viewModel = viewModel
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
        viewModel.viewWillAppear()
    }

}

private extension MyCertifyViewController {
    
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
        view.addSubviews(collectionView)
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
    
    func reloadHeader() {
        guard let snapshot = dataSource?.snapshot() else {
            return
        }
        dataSource?.applySnapshotUsingReloadData(snapshot)
    }
    
    func setNavigationBar() {
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.navigationBar.topItem?.title = ""
        self.navigationItem.title = "나의 인증글"
        setNavigationBar(backgroundColor: .white, tintColor: .black, shadowColor: .clear)
        rightBarLabel.text = "총 11개"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: rightBarLabel)
    }
    
    func setUpDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, Item>(collectionView: collectionView, cellProvider: { [weak self] collectionView, indexPath, itemIdentifier in
            guard let self = self else {
                return UICollectionViewCell()
            }
            let section = Section(rawValue: indexPath.section)
            switch section {
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
                    feedImageURL: feed.certifyImageUrl,
                    isLike: feed.isLike
                )
                cell.certifyId = feed.certifyId
                cell.addHeartButtonAction(self, action: #selector(self.didTapFeedHeart))
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
            case .feed:
                let headerView = collectionView.dequeueReusableSupplementaryView(
                    ofKind: elementKind,
                    withReuseIdentifier: MyCertifyHeaderView.identifier,
                    for: indexPath
                ) as? MyCertifyHeaderView
                headerView?.challengeSelectionView.setTextFieltText("만보 걷기")
                return headerView
                
            default:
                return nil
            }
        }
    }
    
    func applySnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
        snapshot.appendSections([.feed])
        snapshot.appendItems(viewModel.feedItems)
        dataSource?.apply(snapshot)
    }
    
    func createLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { [weak self] (sectionNumber, _) -> NSCollectionLayoutSection? in
            let section = Section(rawValue: sectionNumber)
            switch section {
            case .feed:
                return self?.feedSectionLayout()
                
            default:
                return nil
            }
        }
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
        section.contentInsets = NSDirectionalEdgeInsets(top: 16, leading: 24, bottom: 0, trailing: 24)
        
        section.boundarySupplementaryItems = [
            NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: .init(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .absolute(49)
                ),
                elementKind: MyCertifyHeaderView.identifier, alignment: .top)
        ]
        return section
    }
    
}

private extension MyCertifyViewController {
    
    @objc func didTapFeedHeart(_ sender: UIButton) {
        guard let cell = sender.superview as? UICollectionViewCell else {
            return
        }
        guard let indexPath = collectionView.indexPath(for: cell) else {
            return
        }
        viewModel.likeFeed(isLike: viewModel.feeds[indexPath.row].isLike, certifyId: viewModel.feeds[indexPath.row].certifyId)
        if viewModel.feeds[indexPath.row].isLike {
            viewModel.feeds[indexPath.row].certifyLike -= 1
        } else {
            viewModel.feeds[indexPath.row].certifyLike += 1
        }
        viewModel.feeds[indexPath.row].isLike.toggle()
        reloadHeader()
    }
    
}
