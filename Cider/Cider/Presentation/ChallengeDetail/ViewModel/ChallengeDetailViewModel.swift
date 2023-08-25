//
//  ChallengeDetailViewModel.swift
//  Cider
//
//  Created by 임영선 on 2023/08/03.
//

import Foundation
import Combine

final class ChallengeDetailViewModel: ViewModelType {
    
    enum ViewModelState {
        case applysnapshot
        case setHeart(isLike: Bool, likeCount: Int)
        case challengeStatus(_ status: String)
    }
    
    private var usecase: ChallengeDetailUsecase
    private let challengeId: Int
    
    var state: AnyPublisher<ViewModelState, Never> { currentState.compactMap { $0 }.eraseToAnyPublisher() }
    var currentState: CurrentValueSubject<ViewModelState?, Never> = .init(nil)
    private var cancellables: Set<AnyCancellable> = .init()
    
    var infoResponse: ChallengeDetailInfoResponse?
    var feedResponse: ChallengeDetailFeedResponse?
    var filter: SortingType = .latest
    var feedItems: [Item] = []

    init(usecase: ChallengeDetailUsecase, challengeId: Int) {
        self.usecase = usecase
        self.challengeId = challengeId
    }
    
    func viewDidLoad() {
        getChallengeDetail()
    }
    
    func didTapSorting() {
        if filter == .latest {
            filter = .like
        } else if filter == .like {
            filter = .latest
        }
        getChallengeFeed()
    }
    
    func likeChallenge() {
        guard let response = infoResponse else {
            return
        }
        response.isLike ? deleteLikeChallenge(challengeId: challengeId) : postLikeChallenge(challengeId: challengeId)
    }
    
    func likeFeed(isLike: Bool, certifyId: Int) {
        isLike ? deleteLikeFeed(certifyId: certifyId): postLikeFeed(certifyId: certifyId)
    }
    
    func didTapParticipateChallenge() {
        postParticipateChallenge()
    }
    
}

private extension ChallengeDetailViewModel {
    
    func getChallengeDetail() {
        Task {
            do {
                let infoResponse = try await usecase.getInfo(challengeId: challengeId)
                print(infoResponse)
                self.infoResponse = infoResponse
                getChallengeFeed()
                currentState.send(.setHeart(isLike: infoResponse.isLike, likeCount: infoResponse.challengeLikeNum))
                currentState.send(.challengeStatus(infoResponse.myChallengeStatus))
            }
        }
    }
    
    func postParticipateChallenge() {
        Task {
            do {
                let response = try await usecase.postChallengeParticipate(challengeId: challengeId)
                print(response)
                getChallengeDetail()
            }
        }
    }
    
    func getChallengeFeed() {
        Task {
            let feedResponse = try await usecase.getFeed(challengeId: challengeId, filter: filter.english)
            print(feedResponse)
            feedItems = []
            for _ in feedResponse.simpleCertifyResponseDtoList {
                feedItems.append(Item())
            }
            self.feedResponse = feedResponse
            currentState.send(.applysnapshot)
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
