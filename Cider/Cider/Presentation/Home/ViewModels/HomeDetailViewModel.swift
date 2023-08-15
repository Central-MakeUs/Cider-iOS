//
//  HomeDetailViewModel.swift
//  Cider
//
//  Created by 임영선 on 2023/08/05.
//

import Foundation
import Combine

final class HomeDetailViewModel: ViewModelType {
    
    enum ViewModelState {
        case applySnapshot(_ isSuccess: Bool)
    }
    
    private var usecase: HomeDetailUsecase
    private var homeDetailType: HomeDetailType
    private var cancellables: Set<AnyCancellable> = .init()
    
    var state: AnyPublisher<ViewModelState, Never> { currentState.compactMap { $0 }.eraseToAnyPublisher() }
    var currentState: CurrentValueSubject<ViewModelState?, Never> = .init(nil)
    var challenges: [ChallengeResponseDto] = []
    var items: [Item] = []
    var sortingType: SortingType = .latest {
        didSet {
            loadData()
        }
    }
    
    init(usecase: HomeDetailUsecase, homeDetailType: HomeDetailType) {
        self.usecase = usecase
        self.homeDetailType = homeDetailType
    }
    
    func viewDidload() {
        loadData()
    }
    
    func likeChallenge(isLike: Bool, challengeId: Int) {
        isLike ? deleteLikeChallenge(challengeId: challengeId) : postLikeChallenge(challengeId: challengeId)
    }
   
}

private extension HomeDetailViewModel {
    
    func loadData() {
        switch homeDetailType {
        case .popularChallenge:
            getPopularChallenges()
        case .publicChallenge:
            getPubicChallenges()
        case .allChallenge:
            getAllChallenges()
        }
    }
    
    func getPopularChallenges() {
        Task {
            let response = try await usecase.getPopularChallenge(filter: sortingType.english)
            items = []
            challenges = response
            for _ in 0..<challenges.count {
                items.append(Item())
            }
            currentState.send(.applySnapshot(true))
        }
    }
    
    func getPubicChallenges() {
        Task {
            let response = try await usecase.getPublicChallenge(filter: sortingType.english)
            challenges = response
            items = []
            for _ in 0..<challenges.count {
                items.append(Item())
            }
            currentState.send(.applySnapshot(true))
        }
    }
    
    func getAllChallenges() {
        Task {
            let response = try await usecase.getAllChallenge(filter: sortingType.english)
            challenges = response
            items = []
            for _ in 0..<challenges.count {
                items.append(Item())
            }
            currentState.send(.applySnapshot(true))
        }
    }
    
    func deleteLikeChallenge(challengeId: Int) {
        Task {
            let response = try await usecase.deleteLikeChallenge(chllangeId: challengeId)
            print(response)
        }
    }
    
    func postLikeChallenge(challengeId: Int) {
        Task {
            let response = try await usecase.postLikeChallenge(chllangeId: challengeId)
            print(response)
        }
    }
    
}
