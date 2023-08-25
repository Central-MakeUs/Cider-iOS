//
//  ChallengeOpenRepository.swift
//  Cider
//
//  Created by 임영선 on 2023/08/24.
//

import Foundation

protocol ChallengeOpenRepository {
    func postChallenge(parameters: ChallengeOpenRequest) async throws -> ChallengeOpenResponse
    func postChallengeImage(challengeId: Int, successData: Data, failData: Data) async throws -> CiderResponse
}

final class DefaultChallengeOpenRepository: ChallengeOpenRepository {
    
    func postChallengeImage(challengeId: Int, successData: Data, failData: Data) async throws -> CiderResponse {
        return try await CiderAPI.request(target: .postChallengeImage(challengeId: challengeId, successData: successData, failData: failData), dataType: CiderResponse.self)
    }
    
    func postChallenge(parameters: ChallengeOpenRequest) async throws -> ChallengeOpenResponse {
        return try await CiderAPI.request(target: .postChallenge(parameters: parameters.asDictionary()), dataType: ChallengeOpenResponse.self)
    }
    
}
