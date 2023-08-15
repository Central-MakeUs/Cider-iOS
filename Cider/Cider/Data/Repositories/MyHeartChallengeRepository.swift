//
//  MyHeartChallengeRepository.swift
//  Cider
//
//  Created by 임영선 on 2023/08/15.
//

import Foundation

protocol MyHeartChallengeRepository {
    func getMyHeartChallenge() async throws -> ChallengeResponse
    func postLikeChallenge(chllangeId: Int) async throws -> LikeResponse
    func deleteLikeChallenge(chllangeId: Int) async throws -> LikeResponse
}

final class DefaultMyHeartChallengeRepository: MyHeartChallengeRepository {
    
    func getMyHeartChallenge() async throws -> ChallengeResponse {
        return try await CiderAPI.request(target: .getMyLikeChallenge, dataType: ChallengeResponse.self)
    }
    
    func postLikeChallenge(chllangeId: Int) async throws -> LikeResponse {
        let request = ChallengeLikeRequest(challengeId: chllangeId)
        return try await CiderAPI.request(target: .postLikeChallenge(parameters: request.asDictionary()), dataType: LikeResponse.self)
    }
    
    func deleteLikeChallenge(chllangeId: Int) async throws -> LikeResponse {
        return try await CiderAPI.request(target: .deleteLikeChallenge(challengeId: String(chllangeId)), dataType: LikeResponse.self)
    }
    
}
