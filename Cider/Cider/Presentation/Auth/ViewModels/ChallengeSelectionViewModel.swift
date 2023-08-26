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
        case isSuccessOnboarding(_ isSuccess: Bool)
    }
    let useCase: OnboardingUsecase
    var state: AnyPublisher<ViewModelState, Never> { currentState.compactMap { $0 }.eraseToAnyPublisher() }
    var currentState: CurrentValueSubject<ViewModelState?, Never> = .init(nil)
    private var cancellables: Set<AnyCancellable> = .init()
    
    var challenges: [ChallengeType: Bool] = [
        .moneyManagement: true,
        .moneySaving: true,
        .financialLearning: true,
        .financialTech: true
    ]
    
    init(useCase: OnboardingUsecase) {
        self.useCase = useCase
    }
    
    func didSelectChallenge(_ type: ChallengeType) {
        challenges[type]?.toggle()
        currentState.send(.changeChallengeState(type: type, isSelected: challenges[type] ?? false))
    }
    
    func didTapComplete() {
        Onboarding.shared.interestChallenge = getInterestChallenge()
        guard let request = getOnboardingRequest() else {
            return
        }
        
        Task {
            print(request)
            let isSuccess = try await useCase.patchOnBoarding(parameters: request)
            currentState.send(.isSuccessOnboarding(isSuccess))
        }
    }
    
    private func getInterestChallenge() -> String {
        var interestChallenge = ""
       
        for (type, isSelected) in challenges {
            if isSelected {
                switch type {
                case .financialTech:
                    interestChallenge += "T, "
                case .moneySaving:
                    interestChallenge += "C, "
                case .moneyManagement:
                    interestChallenge += "M, "
                case .financialLearning:
                    interestChallenge += "L, "
                }
            }
        }
        interestChallenge = interestChallenge.substring(
            start: 0,
            end: interestChallenge.count == 0 ? 0 : interestChallenge.count-2
        )
        return interestChallenge
    }
    
    private func getOnboardingRequest() -> OnboardingRequest? {
        guard let memberName = Onboarding.shared.memberName,
              let memberBirth = Onboarding.shared.memberBirth,
              let memberGender = Onboarding.shared.memberGender,
              let interestChallenge = Onboarding.shared.interestChallenge else {
            return nil
        }
        let request = OnboardingRequest(
            memberName: memberName,
            memberBirth: memberBirth,
            memberGender: memberGender,
            interestChallenge: interestChallenge
        )
        return request
    }
    
}
