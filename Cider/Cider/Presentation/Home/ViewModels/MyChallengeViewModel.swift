//
//  MyChallengeViewModel.swift
//  Cider
//
//  Created by 임영선 on 2023/08/25.
//

import Foundation
import Combine

final class MyChallengeViewModel: ViewModelType {
    
    enum ViewModelState {
        case applySnapshot(_ isSuccess: Bool)
        case sendMessage(_ message: String?)
    }
    
    private var usecase: MyChallengeUsecase
    private var cancellables: Set<AnyCancellable> = .init()
    
    var state: AnyPublisher<ViewModelState, Never> { currentState.compactMap { $0 }.eraseToAnyPublisher() }
    var currentState: CurrentValueSubject<ViewModelState?, Never> = .init(nil)
    var judgingChallenges: [JudgingChallengeResponseDtoList] = []
    var ongoingChallenges: [OngoingChallengeResponseDtoList] = []
    var passedChallenges: [PassedChallengeResponseDtoList] = []
    var judgingChallengeListResponseDto: JudgingChallengeListResponseDto?
    var ongoingChallengeListResponseDto: OngoingChallengeListResponseDto?
    var passedChallengeListResponseDto: PassedChallengeListResponseDto?
    
    var judgingItems: [Item] = []
    var ongoingItems: [Item] = []
    var passedItems: [Item] = []
    
    init(usecase: MyChallengeUsecase) {
        self.usecase = usecase
    }
    
    func viewDidload() {
        getMyChallenges()
    }
    
    func didTapDeleteChallenge(challengeId: Int) {
        deleteChallenge(challengeId: challengeId)
    }
   
}

private extension MyChallengeViewModel {
    
    func getMyChallenges() {
        Task {
            let response = try await usecase.getMyChallenge()
            guard let judgingChallengeListResponseDto = response.judgingChallengeListResponseDto,
                  let ongoingChallengeListResponseDto = response.ongoingChallengeListResponseDto,
                  let passedChallengeListResponseDto = response.passedChallengeListResponseDto else {
                currentState.send(.sendMessage(CiderError.serverError.errorDescription))
                return
            }
            self.judgingChallengeListResponseDto = judgingChallengeListResponseDto
            self.ongoingChallengeListResponseDto = ongoingChallengeListResponseDto
            self.passedChallengeListResponseDto = passedChallengeListResponseDto
            judgingChallenges = judgingChallengeListResponseDto.judgingChallengeResponseDtoList
            ongoingChallenges = ongoingChallengeListResponseDto.ongoingChallengeResponseDtoList
            passedChallenges = passedChallengeListResponseDto.passedChallengeResponseDtoList
            
            judgingItems = []
            ongoingItems = []
            passedItems = []
            
            for _ in 0..<judgingChallenges.count {
                judgingItems.append(Item())
            }
            for _ in 0..<ongoingChallenges.count {
                ongoingItems.append(Item())
            }
            for _ in 0..<passedChallenges.count {
                passedItems.append(Item())
            }
            setEmptyState()
            currentState.send(.applySnapshot(true))
        }
    }
    
    func deleteChallenge(challengeId: Int) {
        Task {
            let response = try await usecase.deleteChallenge(challengeId: challengeId)
            print(response)
            if response.status == nil {
                getMyChallenges()
            } else {
                currentState.send(.sendMessage(CiderError.serverError.errorDescription))
            }
        }
    }
    
    func setEmptyState() {
        if judgingItems.count == 0 {
            judgingItems = [Item()]
        }
        if ongoingItems.count == 0 {
            ongoingItems = [Item()]
        }
        if passedItems.count == 0 {
            passedItems = [Item()]
        }
    }
    
}
