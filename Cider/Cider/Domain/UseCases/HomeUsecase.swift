//
//  HomeUsecase.swift
//  Cider
//
//  Created by 임영선 on 2023/08/04.
//

import Foundation

protocol HomeUsecase {
    func getHomeChallenge() async throws -> HomeResponse
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
    
}
