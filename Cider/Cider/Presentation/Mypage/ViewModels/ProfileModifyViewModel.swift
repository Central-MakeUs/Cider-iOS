//
//  ProfileModifyViewModel.swift
//  Cider
//
//  Created by 임영선 on 2023/08/17.
//

import Foundation
import UIKit
import Combine

final class ProfileModifyViewModel: ViewModelType {
    
    enum ViewModelState {
        case changeNextButtonState(isEnabled: Bool)
    }
    
    var state: AnyPublisher<ViewModelState, Never> { currentState.compactMap { $0 }.eraseToAnyPublisher() }
    var currentState: CurrentValueSubject<ViewModelState?, Never> = .init(nil)
    private var cancellables: Set<AnyCancellable> = .init()
    
    var useCase: NicknameUsecase
    var nickname: String
    var profileImage: UIImage
    
    init(useCase: NicknameUsecase, nickname: String, profileImage: UIImage) {
        self.useCase = useCase
        self.nickname = nickname
        self.profileImage = profileImage
    }
    
    func changeNickname(_ nickname: String) {
        self.nickname = nickname
        currentState.send(.changeNextButtonState(isEnabled: nickname.count >= 2))
    }
    
    func didTapModify() {
        
    }
  
}
