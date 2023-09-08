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
    var participateChallengeIds: [Int] = []
    var participateChallengeTitles: [String] = []
    var feedItems: [Item] = []
    var challengeTitle: String = ""
    var selectedChallengeId: Int?
    
    init(usecase: MyCertifyUsecase, selectedChallengeId: Int?) {
        self.usecase = usecase
        self.selectedChallengeId = selectedChallengeId
        setNotificationCenter()
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
        getMyCertify()
    }
    
    func getMyCertify() {
        Task {
            let participateChallengeResponse = try await usecase.getMyParticipateChallenge()
            
            if participateChallengeResponse.isEmpty {
                myCertifyResponse = nil
                challengeTitle = ""
                participateChallengeIds = []
                participateChallengeTitles = []
                setEmptyState()
                currentState.send(.applySnapshot(true))
            } else {
                
                for challenge in participateChallengeResponse {
                    participateChallengeIds.append(challenge.challengeId)
                    participateChallengeTitles.append(challenge.challengeName)
                }
                if let selectedChallengeId {
                    var index = 0
                    for i in 0..<participateChallengeIds.count {
                        if participateChallengeIds[i] == selectedChallengeId {
                            index = i
                            break
                        }
                    }
                    try await getMyCertify(challengeId: participateChallengeIds[index])
                } else {
                    try await getMyCertify(challengeId: participateChallengeIds[0])
                }
               
            }
        }
    }
    
    func getMyCertify(challengeId: Int) async throws {
        let myCerifyResponse = try await usecase.getMyCertify(challengeId: challengeId)
        self.myCertifyResponse = myCerifyResponse
        feedItems = []
        if let myCertifyResponse {
            for _ in 0..<myCertifyResponse.certifyResponseDtoList.count {
                feedItems.append(Item())
            }
            challengeTitle = myCertifyResponse.simpleChallengeResponseDto.challengeName
        }
        setEmptyState()
        currentState.send(.applySnapshot(true))
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
    
    func setNotificationCenter() {
        NotificationCenter.default.publisher(for: .selectParticipateChallenge)
            .receive(on: DispatchQueue.main)
            .sink { notification in
                guard let selectedIndex = notification.object as? Int else {
                    return
                }
                Task {
                    try await self.getMyCertify(challengeId: self.participateChallengeIds[selectedIndex])
                }
            }
            .store(in: &cancellables)
    }
    
}
