//
//  NicknameViewModel.swift
//  Cider
//
//  Created by 임영선 on 2023/07/14.
//

import Foundation
import Combine

final class NicknameViewModel: ViewModelType {
    
    enum ViewModelState {
        case changeNextButtonState(isEnabled: Bool)
        case isEnabledNickname(_ isEnalbed: Bool, message: String)
        case getRandomNickname(_ nickname: String)
    }
    
    var state: AnyPublisher<ViewModelState, Never> { currentState.compactMap { $0 }.eraseToAnyPublisher() }
    var currentState: CurrentValueSubject<ViewModelState?, Never> = .init(nil)
    private var cancellables: Set<AnyCancellable> = .init()
    var useCase: NicknameUsecase
    
    init(useCase: NicknameUsecase) {
        self.useCase = useCase
    }
  
    func didTapRandomNickname() {
        Task {
            let nickname = try await useCase.getRandomNickname()
            guard let nickname else {
                return
            }
            currentState.send(.getRandomNickname(nickname))
            currentState.send(.changeNextButtonState(isEnabled: true))
        }
    }
    
    func endEditingNickname(_ nickname: String) {
        Task {
            let (message, isEnabled) = try await useCase.isEnabledNickname(nickname: nickname)
            currentState.send(.isEnabledNickname(isEnabled, message: message))
            currentState.send(.changeNextButtonState(isEnabled: isEnabled))
        }
    }
    
}
