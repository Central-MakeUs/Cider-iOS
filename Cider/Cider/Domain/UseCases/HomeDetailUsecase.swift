//
//  HomeDetailUsecase.swift
//  Cider
//
//  Created by 임영선 on 2023/08/05.
//

import Foundation

protocol HomeDetailUsecase {
    func getPopularChallenge(filter: String) async throws -> ChallengeResponse
    func getAllChallenge(filter: String) async throws -> ChallengeResponse
    func getPublicChallenge(filter: String) async throws -> ChallengeResponse
}

final class DefaultHomeDetailUsecase: HomeDetailUsecase {
    
    let repository: HomeDetailRepository
    
    init(repository: HomeDetailRepository) {
        self.repository = repository
    }
    
    func getPopularChallenge(filter: String) async throws -> ChallengeResponse {
        let response = try await repository.getPopularChallenge(filter: filter)
        return response
    }
    
    func getAllChallenge(filter: String) async throws -> ChallengeResponse {
        let response = try await repository.getAllChallenge(filter: filter)
        return response
    }
    
    func getPublicChallenge(filter: String) async throws -> ChallengeResponse {
        let response = try await repository.getPublicChallenge(filter: filter)
        return response
    }
    
}
