//
//  HomeUsecase.swift
//  Cider
//
//  Created by 임영선 on 2023/08/04.
//

import Foundation

protocol HomeUsecase {
    func getHomeChallenge() async throws -> HomeResponse
    func getCategory(category: String) async throws -> ChallengeResponse
    func getHomeFeed() async throws -> FeedResponse
    func postLikeChallenge(chllangeId: Int) async throws -> LikeResponse
    func deleteLikeChallenge(chllangeId: Int) async throws -> LikeResponse
    func postLikeFeed(certifyId: Int) async throws -> LikeResponse
    func deleteLikeFeed(certifyId: Int) async throws -> LikeResponse
}

final class DefaultHomeUsecase: HomeUsecase {
    
    let repository: HomeRepository
    
    init(repository: HomeRepository) {
        self.repository = repository
    }
    
    func getHomeChallenge() async throws -> HomeResponse {
        let response = try await repository.getHomeChallenge()
        return response
    }
    
    func getCategory(category: String) async throws -> ChallengeResponse {
        let response = try await repository.getCategory(category: category)
        return response
    }
    
    func getHomeFeed() async throws -> FeedResponse {
        let response = try await repository.getHomeFeed()
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
