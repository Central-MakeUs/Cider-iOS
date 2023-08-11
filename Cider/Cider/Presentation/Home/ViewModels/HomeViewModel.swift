//
//  HomeViewModel.swift
//  Cider
//
//  Created by 임영선 on 2023/08/04.
//

import Foundation
import Combine

final class HomeViewModel: ViewModelType {
    
    enum ViewModelState {
        case applySnapshot(_ isSuccess: Bool)
    }
    
    private var usecase: HomeUsecase
    var state: AnyPublisher<ViewModelState, Never> { currentState.compactMap { $0 }.eraseToAnyPublisher() }
    var currentState: CurrentValueSubject<ViewModelState?, Never> = .init(nil)
    private var cancellables: Set<AnyCancellable> = .init()
    var popularChallanges: [ChallengeResponseDto]?
    var publicChallanges: [ChallengeResponseDto]?
    var categoryChallenges: [ChallengeResponseDto] = []
    var feeds: FeedResponse = []
    var popularItems: [Item] = []
    var publicItems: [Item] = []
    var categoryItems: [Item] = []
    var feedItems: [Item] = []
    var categoryType: ChallengeType = .financialTech
    
    init(usecase: HomeUsecase) {
        self.usecase = usecase
    }
    
    func viewWillAppear() {
        reload()
    }
    
    func getCategory(_ category: String) {
        getCategoryChallenge(category)
    }
    
    func likeChallenge(isLike: Bool, challengeId: Int) {
        isLike ? deleteLikeChallenge(challengeId: challengeId) : postLikeChallenge(challengeId: challengeId)
    }
    
    func likeFeed(isLike: Bool, certifyId: Int) {
        isLike ? deleteLikeFeed(certifyId: certifyId): postLikeFeed(certifyId: certifyId)
    }
    
}

private extension HomeViewModel {
    
    func reload() {
        getHomeChallenge()
        getCategory(categoryType.alphabet)
        getHomeFeed()
    }
    
    func getHomeChallenge() {
        Task {
            let response = try await usecase.getHomeChallenge()
            popularChallanges = response.popularChallengeResponseDto
            publicChallanges = response.officialChallengeResponseDto
            
            guard let popularChallanges,
                  let publicChallanges else {
                return
            }
            for _ in 0..<popularChallanges.count {
                popularItems.append(Item())
            }
            for _ in 0..<publicChallanges.count {
                publicItems.append(Item())
            }
            currentState.send(.applySnapshot(true))
        }
    }
    
    func getCategoryChallenge(_ category: String) {
        Task {
            let response = try await usecase.getCategory(category: category)
            categoryChallenges = response
            categoryItems = []
            for _ in 0..<categoryChallenges.count {
                categoryItems.append(Item())
            }
            currentState.send(.applySnapshot(true))
        }
    }
    
    func getHomeFeed() {
        Task {
            let response = try await usecase.getHomeFeed()
            feeds = response
            feedItems = []
            for _ in 0..<feeds.count {
                feedItems.append(Item())
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
    
    func deleteLikeFeed(certifyId: Int) {
        Task {
            let response = try await usecase.deleteLikeFeed(certifyId: certifyId)
            print(response)
        }
    }
    
    func postLikeFeed(certifyId: Int) {
        Task {
            let response = try await usecase.postLikeFeed(certifyId: certifyId)
            print(response)
        }
    }
    
}
