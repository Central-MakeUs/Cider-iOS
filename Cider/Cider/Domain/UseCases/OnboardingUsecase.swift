//
//  OnboardingUsecase.swift
//  Cider
//
//  Created by 임영선 on 2023/07/16.
//

import Foundation

protocol OnboardingUsecase {
    func patchOnBoarding(parameters: OnboardingRequest) async throws -> Bool
}

final class DefaultOnboardingUsecase: OnboardingUsecase {
    
    let repository: OnboardingRepository
    
    init(repository: OnboardingRepository) {
        self.repository = repository
    }
    
    func patchOnBoarding(parameters: OnboardingRequest) async throws -> Bool {
        let response = try await repository.patchOnboarding(parameters: parameters)
        print(response)
        return response.status == nil
    }
    
}
