//
//  MyHeartChallengeUsecase.swift
//  Cider
//
//  Created by 임영선 on 2023/08/15.
//

import Foundation

protocol MyHeartChallengeUsecase {
    func getMyHeartChallenge() async throws -> ChallengeResponse
    func postLikeChallenge(chllangeId: Int) async throws -> LikeResponse
    func deleteLikeChallenge(chllangeId: Int) async throws -> LikeResponse
}

final class DefaultMyHeartChallengeUsecase: MyHeartChallengeUsecase {
    
    let repository: MyHeartChallengeRepository
    
    init(repository: MyHeartChallengeRepository) {
        self.repository = repository
    }
    
    func getMyHeartChallenge() async throws -> ChallengeResponse {
        let response = try await repository.getMyHeartChallenge()
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
    
}
