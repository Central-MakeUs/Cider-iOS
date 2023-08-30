//
//  MyChallengeUsecase.swift
//  Cider
//
//  Created by 임영선 on 2023/08/25.
//

import Foundation

protocol MyChallengeUsecase {
    func getMyChallenge() async throws -> MyChallengeResponse
    func deleteChallenge(challengeId: Int) async throws -> CiderResponse
}

final class DefaultMyChallengeUsecase: MyChallengeUsecase {
    
    let repository: MyChallengeRepository
    
    init(repository: MyChallengeRepository) {
        self.repository = repository
    }
  
    func getMyChallenge() async throws -> MyChallengeResponse {
        let response = try await repository.getMyChallenge()
        return response
    }
    
    func deleteChallenge(challengeId: Int) async throws -> CiderResponse {
        let response = try await repository.deleteChallenge(challengeId: challengeId)
        return response
    }
    
    

}
