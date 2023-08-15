//
//  HomeDetailRepository.swift
//  Cider
//
//  Created by 임영선 on 2023/08/05.
//

import Foundation

protocol HomeDetailRepository {
    func getPopularChallenge(filter: String) async throws -> ChallengeResponse
    func getAllChallenge(filter: String) async throws -> ChallengeResponse
    func getPublicChallenge(filter: String) async throws -> ChallengeResponse
    func postLikeChallenge(chllangeId: Int) async throws -> LikeResponse
    func deleteLikeChallenge(chllangeId: Int) async throws -> LikeResponse
}


final class DefaultHomeDetailRepository: HomeDetailRepository {
    
    func getPopularChallenge(filter: String) async throws -> ChallengeResponse {
        return try await CiderAPI.request(target: .getPopularChallenge(filter: filter), dataType: ChallengeResponse.self)
    }
    
    func getAllChallenge(filter: String) async throws -> ChallengeResponse {
        return try await CiderAPI.request(target: .getAllChallenge(filter: filter), dataType: ChallengeResponse.self)
    }
    
    func getPublicChallenge(filter: String) async throws -> ChallengeResponse {
        return try await CiderAPI.request(target: .getPublicChallenge(filter: filter), dataType: ChallengeResponse.self)
    }
    
    func postLikeChallenge(chllangeId: Int) async throws -> LikeResponse {
        let request = ChallengeLikeRequest(challengeId: chllangeId)
        return try await CiderAPI.request(target: .postLikeChallenge(parameters: request.asDictionary()), dataType: LikeResponse.self)
    }
    
    func deleteLikeChallenge(chllangeId: Int) async throws -> LikeResponse {
        return try await CiderAPI.request(target: .deleteLikeChallenge(challengeId: String(chllangeId)), dataType: LikeResponse.self)
    }
    
}
