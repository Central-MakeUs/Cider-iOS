//
//  KeywordViewModel.swift
//  Cider
//
//  Created by 임영선 on 2023/07/08.
//

import Combine

final class ChallengeSelectionViewModel: ViewModelType {
    
    enum ViewModelState {
        case changeChallengeState(type: ChallengeType, isSelected: Bool)
    }
    
    var state: AnyPublisher<ViewModelState, Never> { currentState.compactMap { $0 }.eraseToAnyPublisher() }
    var currentState: CurrentValueSubject<ViewModelState?, Never> = .init(nil)
    private var cancellables: Set<AnyCancellable> = .init()
    var challenges: [ChallengeType: Bool] = [
        .moneyManagement: true,
        .moneySaving: true,
        .financialLearning: true,
        .financialTech: true
    ]
    
    func didSelectChallenge(_ type: ChallengeType) {
        challenges[type]?.toggle()
        currentState.send(.changeChallengeState(type: type, isSelected: challenges[type] ?? false))
    }
    
}
