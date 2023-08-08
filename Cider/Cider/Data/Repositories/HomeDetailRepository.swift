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
    
}
