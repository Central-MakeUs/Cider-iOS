//
//  MyCertifyViewModel.swift
//  Cider
//
//  Created by 임영선 on 2023/08/15.
//

import Foundation
import Combine

final class MyCertifyViewModel: ViewModelType {
    
    enum ViewModelState {
        case applySnapshot(_ isSuccess: Bool)
    }
    
    private var usecase: MyCertifyUsecase
    var state: AnyPublisher<ViewModelState, Never> { currentState.compactMap { $0 }.eraseToAnyPublisher() }
    var currentState: CurrentValueSubject<ViewModelState?, Never> = .init(nil)
    private var cancellables: Set<AnyCancellable> = .init()
    var myCertifyResponse: MyCertifyResponse?
    var feedItems: [Item] = []
    
    init(usecase: MyCertifyUsecase) {
        self.usecase = usecase
    }
    
    func viewWillAppear() {
        reload()
    }
    
    func likeFeed(isLike: Bool, certifyId: Int) {
        isLike ? deleteLikeFeed(certifyId: certifyId): postLikeFeed(certifyId: certifyId)
    }
    
    func isCertifyEmpty() -> Bool {
        guard let myCertifyResponse else {
            return true
        }
        return myCertifyResponse.certifyResponseDtoList.count < 1
    }
    
}

private extension MyCertifyViewModel {
    
    func reload() {
        getHomeFeed()
    }
    
    func getHomeFeed() {
        Task {
            let participateChallengeResponse = try await usecase.getMyParticipateChallenge()
            
            if participateChallengeResponse.isEmpty {
                myCertifyResponse = nil
            } else {
                let challengeId = participateChallengeResponse[0].challengeId
                let myCerifyResponse = try await usecase.getMyCertify(challengeId: challengeId)
                self.myCertifyResponse = myCerifyResponse
                feedItems = []
                if let myCertifyResponse {
                    for _ in 0..<myCertifyResponse.certifyResponseDtoList.count {
                        feedItems.append(Item())
                    }
                }
            }
            setEmptyState()
            currentState.send(.applySnapshot(true))
            
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
    
    func setEmptyState() {
        guard let myCertifyResponse else {
            feedItems = [Item()]
            return
        }
        if myCertifyResponse.certifyResponseDtoList.count <= 0 {
            feedItems = [Item()]
        }
    }
    
}
