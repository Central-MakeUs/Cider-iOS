//
//  LoginViewModel.swift
//  Cider
//
//  Created by 임영선 on 2023/07/10.
//

import Foundation
import Combine

final class LoginViewModel: ViewModelType {
    
    enum ViewModelState {
        case login(_ isSuccess: Bool)
    }
    
    var useCase: LoginUsecase
    var state: AnyPublisher<ViewModelState, Never> { currentState.compactMap { $0 }.eraseToAnyPublisher() }
    var currentState: CurrentValueSubject<ViewModelState?, Never> = .init(nil)
    private var cancellables: Set<AnyCancellable> = .init()
    
    init(useCase: LoginUsecase) {
        self.useCase = useCase
    }
    
    func kakaoLogin(token: String) {
        Task {
            let isSuccess = try await useCase.kakaoLogin(token: token)
            currentState.send(.login(isSuccess))
        }
    }
    
    func appleLogin(token: String) {
        Task {
            let isSuccess = try await useCase.appleLogin(token: token)
            currentState.send(.login(isSuccess))
        }
    }
    
}
