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

    init(usecase: ChallengeDetailUsecase, challengeId: Int) {
        self.usecase = usecase
        self.challengeId = challengeId
    }
    
    func viewDidLoad() {
        getChallengeDetail()
    }
    
}

private extension ChallengeDetailViewModel {
    
    func getChallengeDetail() {
        Task {
            do {
                let infoResponse = try await usecase.getInfo(challengeId: challengeId)
                self.infoResponse = infoResponse
                let feedResponse = try await usecase.getFeed(challengeId: challengeId, filter: filter.english)
                self.feedResponse = feedResponse
                currentState.send(.applysnapshot)
            }
        }
    }
    
}
