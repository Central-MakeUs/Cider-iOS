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
        case login(isSuccess: Bool, isNewUser: Bool)
        case showEnabledLogin
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
            if let isRedraw = UserDefaults.standard.read(key: .isRedrawKakao) as? Bool,
               isRedraw == true {
                currentState.send(.showEnabledLogin)
                return
            }
            let response = try await useCase.kakaoLogin(token: token)
            print(response)
            guard let response,
            let isNewUser = response.isNewMember else {
                return
            }
            currentState.send(.login(isSuccess: response.status==nil, isNewUser: isNewUser))
        }
    }
    
    func appleLogin(token: String) {
        Task {
            if let isRedraw = UserDefaults.standard.read(key: .isRedrawApple) as? Bool,
               isRedraw == true {
                currentState.send(.showEnabledLogin)
                return
            }
            let response = try await useCase.appleLogin(token: token)
            print(response)
            guard let response,
            let isNewUser = response.isNewMember else {
                return
            }
            currentState.send(.login(isSuccess: response.status==nil, isNewUser: isNewUser))
        }
    }
    
}
