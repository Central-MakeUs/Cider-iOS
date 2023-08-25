//
//  MyChallengeRepository.swift
//  Cider
//
//  Created by 임영선 on 2023/08/25.
//

import Foundation

protocol MyChallengeRepository {
    func getMyChallenge() async throws -> MyChallengeResponse
    func deleteChallenge(challengeId: Int) async throws -> CiderResponse
}

final class DefaultMyChallengeRepository: MyChallengeRepository {
    
    func getMyChallenge() async throws -> MyChallengeResponse {
        return try await CiderAPI.request(target: .getMyChallenge, dataType: MyChallengeResponse.self)
    }
    
    func deleteChallenge(challengeId: Int) async throws -> CiderResponse {
        return try await CiderAPI.request(target: .deleteChallenge(challengeId: challengeId), dataType: CiderResponse.self)
    }
    
}
