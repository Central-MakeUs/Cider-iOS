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
}


final class DefaultHomeRepository: HomeRepository {
    
    func getHomeChallenge() async throws -> HomeResponse {
        return try await CiderAPI.request(target: .getHomeChallenge, dataType: HomeResponse.self)
    }
    
    func getCategory(category: String) async throws -> ChallengeResponse {
        return try await CiderAPI.request(target: .getHomeCategory(category: category), dataType: ChallengeResponse.self)
    }
    
}
