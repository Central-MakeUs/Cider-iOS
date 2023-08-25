//
//  ChallengeOpenUsecase.swift
//  Cider
//
//  Created by 임영선 on 2023/08/24.
//

import Foundation
import UIKit

protocol ChallengeOpenUsecase {
    func postChallenge(parameters: ChallengeOpenRequest) async throws -> ChallengeOpenResponse
    func postChallengeImage(challengeId: Int, successData: Data, failData: Data) async throws -> CiderResponse
}

final class DefaultChallengeOpenUsecase: ChallengeOpenUsecase {
    
    let repository: ChallengeOpenRepository
    
    init(repository: ChallengeOpenRepository) {
        self.repository = repository
    }
    
    func postChallenge(parameters: ChallengeOpenRequest) async throws -> ChallengeOpenResponse {
        let response = try await repository.postChallenge(parameters: parameters)
        return response
    }
    
    func postChallengeImage(challengeId: Int, successData: Data, failData: Data) async throws -> CiderResponse {
        let response = try await repository.postChallengeImage(challengeId: challengeId, successData: successData, failData: failData)
        return response
    }

}
