//
//  HomeRepository.swift
//  Cider
//
//  Created by 임영선 on 2023/08/04.
//

import Foundation

protocol HomeRepository {
    func getHomeChallenge() async throws -> HomeResponse
    func getCategory(category: String) async throws -> ChallengeResponse
    func getHomeFeed() async throws -> FeedResponse
    func postLikeChallenge(chllangeId: Int) async throws -> LikeResponse
    func deleteLikeChallenge(chllangeId: Int) async throws -> LikeResponse
    func postLikeFeed(certifyId: Int) async throws -> LikeResponse
    func deleteLikeFeed(certifyId: Int) async throws -> LikeResponse
}


final class DefaultHomeRepository: HomeRepository {
    
    func getHomeChallenge() async throws -> HomeResponse {
        return try await CiderAPI.request(target: .getHomeChallenge, dataType: HomeResponse.self)
    }
    
    func getCategory(category: String) async throws -> ChallengeResponse {
        return try await CiderAPI.request(target: .getHomeCategory(category: category), dataType: ChallengeResponse.self)
    }
    
    func getHomeFeed() async throws -> FeedResponse {
        return try await CiderAPI.request(target: .getHomeFeed, dataType: FeedResponse.self)
    }
    
    func postLikeChallenge(chllangeId: Int) async throws -> LikeResponse {
        let request = ChallengeLikeRequest(challengeId: chllangeId)
        return try await CiderAPI.request(target: .postLikeChallenge(parameters: request.asDictionary()), dataType: LikeResponse.self)
    }
    
    func deleteLikeChallenge(chllangeId: Int) async throws -> LikeResponse {
        return try await CiderAPI.request(target: .deleteLikeChallenge(challengeId: String(chllangeId)), dataType: LikeResponse.self)
    }
    
    func postLikeFeed(certifyId: Int) async throws -> LikeResponse {
        let request = FeedLikeRequest(certifyId: certifyId)
        return try await CiderAPI.request(target: .postLikeFeed(parameters: request.asDictionary()), dataType: LikeResponse.self)
    }
    
    func deleteLikeFeed(certifyId: Int) async throws -> LikeResponse {
        return try await CiderAPI.request(target: .deleteLikeFeed(certifyId: String(certifyId)), dataType: LikeResponse.self)
    }
    
}
