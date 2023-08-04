//
//  HomeRepository.swift
//  Cider
//
//  Created by 임영선 on 2023/08/04.
//

import Foundation

protocol HomeRepository {
    func getHomeChallenge() async throws -> HomeResponse
}


final class DefaultHomeRepository: HomeRepository {
    
    func getHomeChallenge() async throws -> HomeResponse {
        return try await CiderAPI.request(target: .getHomeChallenge, dataType: HomeResponse.self)
    }
    
}
