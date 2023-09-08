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
        collectionView.register(MyCertifyEmptyCell.self, forCellWithReuseIdentifier: MyCertifyEmptyCell.identifier)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.keyboardDismissMode = .onDrag
        return collectionView
    }()
    
    private lazy var arrowTopButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "arrowTopButton"), for: .normal)
        button.addTarget(self, action: #selector(didTapArrowTop), for: .touchUpInside)
        return button
    }()
    
    private let challengeSelectionView = ChallengeSelectionView()
    
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
                    self?.setChallengeSelection()
                    self?.setFeedCount()
                }
            }
            .store(in: &cancellables)
    }
    
    func configure() {
        view.backgroundColor = .white
        view.addSubviews(collectionView, arrowTopButton, challengeSelectionView)
        NSLayoutConstraint.activate([
            challengeSelectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            challengeSelectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            challengeSelectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            challengeSelectionView.heightAnchor.constraint(equalToConstant: 49),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.topAnchor.constraint(equalTo: challengeSelectionView.bottomAnchor, constant: 6),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            arrowTopButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -25),
            arrowTopButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24)
        ])
    }
    
    func reloadHeader() {
        guard let snapshot = dataSource?.snapshot() else {
            return
        }
        dataSource?.applySnapshotUsingReloadData(snapshot)
    }
    
    func setChallengeSelection() {
        challengeSelectionView.setTextFieltText(viewModel.challengeTitle)
        challengeSelectionView.challengeList = viewModel.participateChallengeTitles
    }
    
    func setNavigationBar() {
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.navigationBar.topItem?.title = ""
        self.navigationItem.title = "나의 인증글"
        setNavigationBar(backgroundColor: .white, tintColor: .black, shadowColor: .clear)
        rightBarLabel.text = "총 0개"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: rightBarLabel)
    }
    
    func setFeedCount() {
        guard let response = viewModel.myCertifyResponse else {
            rightBarLabel.text = "총 0개"
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: rightBarLabel)
            return
        }
        rightBarLabel.text = "총 \(response.certifyResponseDtoList.count)개"
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
                if !self.viewModel.isCertifyEmpty() {
                    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FeedCell.identifier, for: indexPath) as? FeedCell else {
                        return UICollectionViewCell()
                    }
                    if let response = self.viewModel.myCertifyResponse {
                        let myCeritfy = response.certifyResponseDtoList[indexPath.row]
                        cell.setUp(
                            nickname: response.simpleMemberResponseDto.memberName,
                            level: response.simpleMemberResponseDto.memberLevelName,
                            date: myCeritfy.createdDate.formatYYYYMMDDHHMMDot(),
                            mainTitle: myCeritfy.certifyName,
                            subTitle: myCeritfy.certifyContent,
                            challengeType: response.simpleChallengeResponseDto.challengeBranch.convertChallengeType(),
                            challengeTitle: response.simpleChallengeResponseDto.challengeName,
                            people: String(response.simpleChallengeResponseDto.participateNum),
                            heart: String(myCeritfy.certifyLike),
                            profileImageURL: response.simpleMemberResponseDto.profilePath ?? "",
                            feedImageURL: myCeritfy.certifyImageUrl,
                            isLike: myCeritfy.isLike
                        )
                        cell.setHiddenMeatball()
                        cell.certifyId = myCeritfy.certifyId
                        cell.addHeartButtonAction(self, action: #selector(self.didTapFeedHeart))
                    }
                    
                    return cell
                } else {
                    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MyCertifyEmptyCell.identifier, for: indexPath) as? MyCertifyEmptyCell else {
                        return UICollectionViewCell()
                    }
                    cell.bottomButton.addTarget(self, action: #selector(self.didTapAllChallenge), for: .touchUpInside)
                    return cell
                }
                
                
            case .none:
                return UICollectionViewCell()
            }
        })
        
    }
    
    func applySnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
        snapshot.appendSections([.feed])
        snapshot.appendItems(viewModel.feedItems)
        dataSource?.apply(snapshot)
    }
    
    func createLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { [weak self] (sectionNumber, _) -> NSCollectionLayoutSection? in
            guard let self = self else {
                return nil
            }
            let section = Section(rawValue: sectionNumber)
            switch section {
            case .feed:
                return  !self.viewModel.isCertifyEmpty() ? self.feedSectionLayout() : self.emptyStateLayout()
                
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
        section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 24, bottom: 60, trailing: 24)
        return section
    }
    
    func emptyStateLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .fractionalHeight(1)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .fractionalHeight(1)
        )
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize,
                                                     subitems: [item])
        group.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 8, trailing: 0)
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 0, bottom: 0, trailing: 0)
        return section
    }
    
}

private extension MyCertifyViewController {
    
    func pushAllChallengeViewController() {
        let viewController = HomeDetailViewController(
            homeDetailType: .allChallenge,
            viewModel: HomeDetailViewModel(
                usecase: DefaultHomeDetailUsecase(
                    repository: DefaultHomeDetailRepository()
                ),
                homeDetailType: .allChallenge
            )
        )
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    @objc func didTapFeedHeart(_ sender: UIButton) {
        guard let cell = sender.superview as? UICollectionViewCell else {
            return
        }
        guard let indexPath = collectionView.indexPath(for: cell) else {
            return
        }
        guard let response = viewModel.myCertifyResponse else {
            return
        }
        viewModel.likeFeed(isLike: response.certifyResponseDtoList[indexPath.row].isLike, certifyId: response.certifyResponseDtoList[indexPath.row].certifyId)
        if response.certifyResponseDtoList[indexPath.row].isLike {
            viewModel.myCertifyResponse?.certifyResponseDtoList[indexPath.row].certifyLike -= 1
        } else {
            viewModel.myCertifyResponse?.certifyResponseDtoList[indexPath.row].certifyLike += 1
        }
        viewModel.myCertifyResponse?.certifyResponseDtoList[indexPath.row].isLike.toggle()
        reloadHeader()
    }
    
    @objc func didTapAllChallenge(_ sender: Any?) {
        pushAllChallengeViewController()
    }
    
    @objc func didTapArrowTop(_ sender: Any?) {
        collectionView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
    }
    
}
