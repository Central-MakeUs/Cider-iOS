//
//  PrecautionViewModel.swift
//  Cider
//
//  Created by 임영선 on 2023/07/20.
//

import Foundation
import Combine
import UIKit

final class PrecautionViewModel: ViewModelType {
    
    enum ViewModelState {
        case changeNextButtonState(_ isEnabled: Bool)
    }
    
    var state: AnyPublisher<ViewModelState, Never> { currentState.compactMap { $0 }.eraseToAnyPublisher() }
    var currentState: CurrentValueSubject<ViewModelState?, Never> = .init(nil)
    private var cancellables: Set<AnyCancellable> = .init()
    
    private let usecase: ChallengeOpenUsecase
    private let challengeOpenRequest: ChallengeOpenRequest
    private let failData: Data
    private let successData: Data
    
    private var isSelectedList = [false, false, false, false]
    
    init(
        usecase: ChallengeOpenUsecase,
        challengeOpenRequest: ChallengeOpenRequest,
        failData: Data,
        successData: Data
    ) {
        self.usecase = usecase
        self.challengeOpenRequest = challengeOpenRequest
        self.failData = failData
        self.successData = successData
    }
    
    func didTapCheckbox(index: Int) {
        isSelectedList[index].toggle()
        currentState.send(.changeNextButtonState(isAvailableNextButton()))
    }
    
}

private extension PrecautionViewModel {
    
    func isAvailableNextButton() -> Bool {
        return isSelectedList.filter {$0==true}.count == 4
    }
    
}
