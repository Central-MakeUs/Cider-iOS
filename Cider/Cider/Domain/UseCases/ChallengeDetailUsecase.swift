//
//  ChallengeDetailUsecase.swift
//  Cider
//
//  Created by 임영선 on 2023/08/25.
//

import Foundation

protocol ChallengeDetailUsecase {
    func getInfo(challengeId: Int) async throws -> ChallengeDetailInfoResponse
    func getFeed(challengeId: Int, filter: String) async throws -> ChallengeDetailFeedResponse
    func postChallengeParticipate(challengeId: Int) async throws -> CiderResponse
    func postLikeChallenge(chllangeId: Int) async throws -> LikeResponse
    func deleteLikeChallenge(chllangeId: Int) async throws -> LikeResponse
    func postLikeFeed(certifyId: Int) async throws -> LikeResponse
    func deleteLikeFeed(certifyId: Int) async throws -> LikeResponse
}

final class DefaultChallengeDetailUsecase: ChallengeDetailUsecase {
    
    let repository: ChallengeDetailRepository
    
    init(repository: ChallengeDetailRepository) {
        self.repository = repository
    }
    
    func getInfo(challengeId: Int) async throws -> ChallengeDetailInfoResponse {
        let response = try await repository.getInfo(challengeId: challengeId)
        return response
    }
    
    func getFeed(challengeId: Int, filter: String) async throws -> ChallengeDetailFeedResponse {
        let response = try await repository.getFeed(challengeId: challengeId, filter: filter)
        return response
    }
    
    func postChallengeParticipate(challengeId: Int) async throws -> CiderResponse {
        let response = try await repository.postChallengeParticipate(challengeId: challengeId)
        return response
    }
    
    func postLikeChallenge(chllangeId: Int) async throws -> LikeResponse {
        let response = try await repository.postLikeChallenge(chllangeId: chllangeId)
        return response
    }
    
    func deleteLikeChallenge(chllangeId: Int) async throws -> LikeResponse {
        let response = try await repository.deleteLikeChallenge(chllangeId: chllangeId)
        return response
    }
    
    func postLikeFeed(certifyId: Int) async throws -> LikeResponse {
        let response = try await repository.postLikeFeed(certifyId: certifyId)
        return response
    }
    
    func deleteLikeFeed(certifyId: Int) async throws -> LikeResponse {
        let response = try await repository.deleteLikeFeed(certifyId: certifyId)
        return response
    }
    
}
