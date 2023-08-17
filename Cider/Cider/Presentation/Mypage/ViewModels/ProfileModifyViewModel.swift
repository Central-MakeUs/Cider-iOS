//
//  ProfileModifyViewModel.swift
//  Cider
//
//  Created by 임영선 on 2023/08/17.
//

import Foundation
import Combine

final class ProfileModifyViewModel: ViewModelType {
    
    enum ViewModelState {
        case changeNextButtonState(isEnabled: Bool)
    }
    
    var state: AnyPublisher<ViewModelState, Never> { currentState.compactMap { $0 }.eraseToAnyPublisher() }
    var currentState: CurrentValueSubject<ViewModelState?, Never> = .init(nil)
    private var cancellables: Set<AnyCancellable> = .init()
    var useCase: NicknameUsecase
    
    init(useCase: NicknameUsecase) {
        self.useCase = useCase
    }
  
//    func didTapRandomNickname() {
//        Task {
//            let nickname = try await useCase.getRandomNickname()
//            guard let nickname else {
//                return
//            }
//            currentState.send(.changeNextButtonState(isEnabled: true))
//        }
//    }
//
//    func endEditingNickname(_ nickname: String) {
//        Task {
//            let (message, isEnabled) = try await useCase.isEnabledNickname(nickname: nickname)
//            currentState.send(.changeNextButtonState(isEnabled: isEnabled))
//        }
//    }
//
}
