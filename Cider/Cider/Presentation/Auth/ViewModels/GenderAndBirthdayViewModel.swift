//
//  OnboardingViewModel.swift
//  Cider
//
//  Created by 임영선 on 2023/07/07.
//
import Foundation
import Combine

final class GenderAndBirthdayViewModel: ViewModelType {
    
    enum ViewModelState {
        case changeNextButtonState(isEnabled: Bool)
        case checkAge(isEnabled: Bool)
        case selectBitrhday(birthday: String)
    }
    
    var state: AnyPublisher<ViewModelState, Never> { currentState.compactMap { $0 }.eraseToAnyPublisher() }
    var currentState: CurrentValueSubject<ViewModelState?, Never> = .init(nil)
    private var cancellables: Set<AnyCancellable> = .init()
    @Published var maleButtonIsPressed = false
    @Published var femaleButtonIsPressed = false
    var birthday: Date?
    
    func didTapMaleButton() {
        maleButtonIsPressed = true
        femaleButtonIsPressed = false
        
        currentState.send(.changeNextButtonState(isEnabled: isEnableNextButton()))
    }
    
    func didTapFemaleButton() {
        femaleButtonIsPressed = true
        maleButtonIsPressed = false
        
        currentState.send(.changeNextButtonState(isEnabled: isEnableNextButton()))
    }
    
    func selectBirthday(date: Date) {
        birthday = date
        let birthday = date.formatYYYYMMDDKorean()
        currentState.send(.selectBitrhday(birthday: birthday))
        currentState.send(.checkAge(isEnabled: isAvaliableAge(date)))
        currentState.send(.changeNextButtonState(isEnabled: isEnableNextButton()))
    }
    
    func didTapNext() {
        guard let birthday else {
            return
        }
        Onboarding.shared.memberBirth = birthday.formatYYYYMMDDDash()
        Onboarding.shared.memberGender = maleButtonIsPressed ? "M" : "F"
    }
   
    private func isAvaliableAge(_ date: Date) -> Bool {
        let currentDate = Date()
        let calendar = Calendar.current
        let currentComponents = calendar.dateComponents([.year, .month, .day], from: currentDate)
        let birthComponents = calendar.dateComponents([.year, .month, .day], from: date)
        let yearOfCurrent = currentComponents.year ?? 0
        let yearOfBirth = birthComponents.year ?? 0
        return yearOfCurrent-yearOfBirth+1 >= 14
    }
    
    private func isEnableNextButton() -> Bool {
        guard let birthday else {
            return false
        }
        return (maleButtonIsPressed || femaleButtonIsPressed) && isAvaliableAge(birthday)
    }
    
}
