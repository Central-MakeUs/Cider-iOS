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
    
}

private extension ChallengeDetailViewModel {
    
    func getChallengeDetail() {
        Task {
            do {
                let infoResponse = try await usecase.getInfo(challengeId: challengeId)
                print(infoResponse)
                self.infoResponse = infoResponse
                getChallengeFeed()
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
    
}
