//
//  MyHeartChallengeViewController.swift
//  Cider
//
//  Created by 임영선 on 2023/08/15.
//

import UIKit
import Combine

class MyHeartChallengeViewController: UIViewController {
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        collectionView.register(ChallengeHomeCell.self, forCellWithReuseIdentifier: ChallengeHomeCell.identifier)
        collectionView.register(MyHeartEmptyCell.self, forCellWithReuseIdentifier: MyHeartEmptyCell.identifier)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.keyboardDismissMode = .onDrag
        collectionView.delegate = self
        return collectionView
    }()
    
    let rightBarLabel: UILabel = {
        let label = UILabel()
        label.font = CustomFont.PretendardBold(size: .lg).font
        label.textColor = .custom.gray5
        return label
    }()
    
    private enum Section: Int {
        case challenge = 0
    }
    
    private let viewModel: MyHeartChallengeViewModel
    private var dataSource: UICollectionViewDiffableDataSource<Section, Item>?
    private var cancellables = Set<AnyCancellable>()
    
    init(viewModel: MyHeartChallengeViewModel, count: Int) {
        self.viewModel = viewModel
        rightBarLabel.text = "총 \(count)개"
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

private extension MyHeartChallengeViewController {
    
    func setUp() {
        configure()
        setUpDataSource()
        applySnapshot()
        bind()
    }
    
    func bind() {
        viewModel.state.receive(on: DispatchQueue.main)
            .sink { [weak self] state in
                guard let self = self else {
                    return
                }
                switch state {
                case .applySnapshot(let isSuccess):
                    guard isSuccess else {
                        return
                    }
                    self.applySnapshot()
                    self.setTotalCount()
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
    
    func reloadHeader() {
        guard let snapshot = dataSource?.snapshot() else {
            return
        }
        dataSource?.applySnapshotUsingReloadData(snapshot)
    }

    func setNavigationBar() {
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.navigationBar.topItem?.title = ""
        self.navigationItem.title = "관심 챌린지"
        setNavigationBar(backgroundColor: .white, tintColor: .black, shadowColor: .clear)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: rightBarLabel)
    }
    
    func setTotalCount() {
        rightBarLabel.text = "총 \(viewModel.challenges.count)개"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: rightBarLabel)
    }
    
    func setUpDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, Item>(collectionView: collectionView, cellProvider: { [weak self] collectionView, indexPath, itemIdentifier in
            guard let self = self else {
                return UICollectionViewCell()
            }
            let section = Section(rawValue: indexPath.section)
            switch section {
            case .challenge:
                if self.viewModel.challenges.count > 0 {
                    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ChallengeHomeCell.identifier, for: indexPath) as? ChallengeHomeCell else {
                        return UICollectionViewCell()
                    }
                    let challenge = self.viewModel.challenges[indexPath.row]
                    let dDay = challenge.recruitLeft<=0 ? "D+\(challenge.recruitLeft * -1)" : "D-\(challenge.recruitLeft)"
                    cell.setUp(
                        type: challenge.interestField.convertChallengeType(),
                        isReward: challenge.isReward,
                        date: "\(challenge.challengePeriod)주",
                        ranking: nil,
                        title: challenge.challengeName,
                        status: challenge.challengeStatus.convertStatusKorean(),
                        people: "\(challenge.participateNum)명 모집중",
                        isPublic: challenge.isOfficial,
                        dDay: dDay,
                        isLike: challenge.isLike
                    )
                    cell.challengeId = challenge.challengeId
                    cell.addActionHeart(self, action: #selector(self.didTapChallengeHeart))
                    
                    return cell
                } else {
                    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MyHeartEmptyCell.identifier, for: indexPath) as? MyHeartEmptyCell else {
                        return UICollectionViewCell()
                    }
                    cell.bottomButton.addTarget(self, action: #selector(self.didTapChallengeOpen), for: .touchUpInside)
                    return cell
                }
                
            case .none:
                return UICollectionViewCell()
            }
        })
    }
    
    func applySnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
        snapshot.appendSections([.challenge])
        snapshot.appendItems(viewModel.items)
        dataSource?.apply(snapshot)
    }
    
    func createLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { [weak self] (sectionNumber, _) ->
            NSCollectionLayoutSection? in
            guard let self = self else {
                return nil
            }
            let section = Section(rawValue: sectionNumber)
            switch section {
            case .challenge:
                return self.viewModel.challenges.count > 0 ? self.challengeSectionLayout() : self.emptyStateLayout()
                
            default:
                return nil
            }
        }
    }
    
    func challengeSectionLayout() -> NSCollectionLayoutSection {
        let width = (UIScreen.main.bounds.width-48-12)/2
        
        let height = width*1.72+13
      
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .absolute(width),
            heightDimension: .fractionalWidth(1)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .absolute(height)
        )
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitems: [item, item]
        )
        group.interItemSpacing = .fixed(12)
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = .init(top: 12, leading: 24, bottom: 24, trailing: 24)
        section.interGroupSpacing = 0
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
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
        return section
    }
    
}

private extension MyHeartChallengeViewController {
    
    func pushChallengeOpenViewController() {
        let viewController = ChallengeTypeViewController()
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    func pushChallengeDetailViewController(index: Int) {
        let challengeType = viewModel.challenges[index].interestField.convertChallengeType()
        let challengeId = viewModel.challenges[index].challengeId
        let viewController = ChallengeDetailViewController(
            challengeType: challengeType,
            viewModel: ChallengeDetailViewModel(
                usecase: DefaultChallengeDetailUsecase(
                    repository: DefaultChallengeDetailRepository()
                ),
                challengeId: challengeId
            )
        )
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    @objc func didTapChallengeHeart(_ sender: UIButton) {
        let contentView = sender.superview?.superview
        var challengeId: Int?
        var isLike: Bool?
        
        guard let cell = contentView?.superview as? UICollectionViewCell else {
            return
        }
        
        guard let indexPath = collectionView.indexPath(for: cell) else {
            return
        }
        let challenge = viewModel.challenges[indexPath.row]
        challengeId = challenge.challengeId
        isLike = challenge.isLike
        viewModel.challenges[indexPath.row].isLike.toggle()
        guard let challengeId,
              let isLike else {
            return
        }
        viewModel.likeChallenge(isLike: isLike, challengeId: challengeId)
        reloadHeader()
    }
    
    @objc func didTapChallengeOpen(_ sender: Any?) {
        pushChallengeOpenViewController()
    }
    
}

extension MyHeartChallengeViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        pushChallengeDetailViewController(index: indexPath.row)
    }
    
}
