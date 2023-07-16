//
//  OnboardingRepository.swift
//  Cider
//
//  Created by 임영선 on 2023/07/16.
//

import Foundation

protocol OnboardingRepository {
    func patchOnboarding(parameters: OnboardingRequest) async throws ->  OnboardingResponse
}

final class DefaultOnboardingRepository: OnboardingRepository {
    
    func patchOnboarding(parameters: OnboardingRequest) async throws -> OnboardingResponse {
        return try await CiderAPI.request(target: .patchOnboarding(paramters: parameters.asDictionary()), dataType: OnboardingResponse.self)
    }
    
}
