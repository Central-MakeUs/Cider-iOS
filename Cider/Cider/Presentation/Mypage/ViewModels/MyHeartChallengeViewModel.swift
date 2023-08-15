//
//  MyHeartChallengeViewModel.swift
//  Cider
//
//  Created by 임영선 on 2023/08/15.
//

import Foundation
import Combine

final class MyHeartChallengeViewModel: ViewModelType {
    
    enum ViewModelState {
        case applySnapshot(_ isSuccess: Bool)
    }
    
    private var usecase: MyHeartChallengeUsecase
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
    
    init(usecase: MyHeartChallengeUsecase) {
        self.usecase = usecase
    }
    
    func viewDidload() {
        loadData()
    }
    
    func likeChallenge(isLike: Bool, challengeId: Int) {
        isLike ? deleteLikeChallenge(challengeId: challengeId) : postLikeChallenge(challengeId: challengeId)
    }
   
}

private extension MyHeartChallengeViewModel {
    
    func loadData() {
       getMyHeartChallenges()
    }
    
    func getMyHeartChallenges() {
        Task {
            let response = try await usecase.getMyHeartChallenge()
            items = []
            challenges = response
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
