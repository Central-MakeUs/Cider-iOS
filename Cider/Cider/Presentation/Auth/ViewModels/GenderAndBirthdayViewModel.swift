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
    }
    
    func didTapFemaleButton() {
        femaleButtonIsPressed = true
        maleButtonIsPressed = false
    }
    
    func selectBirthday(date: Date) {
        birthday = date
        let birthday = date.formatYYYYMMDDKorean()
        currentState.send(.selectBitrhday(birthday: birthday))
    }
    
    func didTapNext() {
        guard let birthday else {
            Onboarding.shared.memberBirth = "0000-00-00"
            Onboarding.shared.memberGender = getGender()
            return
        }
        Onboarding.shared.memberBirth = birthday.formatYYYYMMDDDash()
        Onboarding.shared.memberGender = getGender()
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
    
    private func getGender() -> String {
        if maleButtonIsPressed {
            return "M"
        } else if femaleButtonIsPressed {
            return "F"
        } else {
            return "N"
        }
    }
    
}
