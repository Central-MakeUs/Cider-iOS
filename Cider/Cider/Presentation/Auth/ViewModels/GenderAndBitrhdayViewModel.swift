//
//  OnboardingViewModel.swift
//  Cider
//
//  Created by 임영선 on 2023/07/07.
//

import Combine

final class GenderAndBitrhdayViewModel: ViewModelType {
    
    public enum ViewModelState {
        case changeNextButtonState(isEnabled: Bool)
    }
    
    public var state: AnyPublisher<ViewModelState, Never> { currentState.compactMap { $0 }.eraseToAnyPublisher() }
    public var currentState: CurrentValueSubject<ViewModelState?, Never> = .init(nil)
    private var cancellables: Set<AnyCancellable> = .init()
    @Published var maleButtonIsPressed = false
    @Published var femaleButtonIsPressed = false
    
    func didTapMaleButton() {
        maleButtonIsPressed = true
        femaleButtonIsPressed = false
        
        currentState.send(.changeNextButtonState(isEnabled: true))
    }
    
    func didTapFemaleButton() {
        femaleButtonIsPressed = true
        maleButtonIsPressed = false
        
        currentState.send(.changeNextButtonState(isEnabled: true))
    }
    
}
