//
//  ChallengeDetailRepository.swift
//  Cider
//
//  Created by 임영선 on 2023/08/25.
//

import Foundation

protocol ChallengeDetailRepository {
    func getInfo(challengeId: Int) async throws -> ChallengeDetailInfoResponse
    func getFeed(challengeId: Int, filter: String) async throws -> ChallengeDetailFeedResponse
    func postChallengeParticipate(challengeId: Int) async throws -> CiderResponse
    func postLikeChallenge(chllangeId: Int) async throws -> LikeResponse
    func deleteLikeChallenge(chllangeId: Int) async throws -> LikeResponse
    func postLikeFeed(certifyId: Int) async throws -> LikeResponse
    func deleteLikeFeed(certifyId: Int) async throws -> LikeResponse
}


final class DefaultChallengeDetailRepository: ChallengeDetailRepository {
    
    func getInfo(challengeId: Int) async throws -> ChallengeDetailInfoResponse {
        print(challengeId)
        return try await CiderAPI.request(target: .getChallengeDetailInfo(challengeId: challengeId), dataType: ChallengeDetailInfoResponse.self)
    }
    
    func getFeed(challengeId: Int, filter: String) async throws -> ChallengeDetailFeedResponse {
        return try await CiderAPI.request(target: .getChallengeDetailFeed(challengeId: challengeId, filter: filter), dataType: ChallengeDetailFeedResponse.self)
    }
    
    func postChallengeParticipate(challengeId: Int) async throws -> CiderResponse {
        let request = ChallengeLikeRequest(challengeId: challengeId)
        return try await CiderAPI.request(target: .postChallengeParticipiate(parameters: request.asDictionary()), dataType: CiderResponse.self)
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
