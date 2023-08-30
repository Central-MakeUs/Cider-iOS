//
//  MyCertifyUsecase.swift
//  Cider
//
//  Created by 임영선 on 2023/08/23.
//

import Foundation

protocol MyCertifyUsecase {
    func getMyParticipateChallenge() async throws -> ParticiapteChallengeResponse
    func getMyCertify(challengeId: Int) async throws -> MyCertifyResponse
    func postLikeFeed(certifyId: Int) async throws -> LikeResponse
    func deleteLikeFeed(certifyId: Int) async throws -> LikeResponse
}

final class DefaultMyCertifyUsecase: MyCertifyUsecase {
    
    let repository: MyCertifyRepository
    
    init(repository: MyCertifyRepository) {
        self.repository = repository
    }
    
    func getMyParticipateChallenge() async throws -> ParticiapteChallengeResponse {
        let response = try await repository.getMyParticipateChallenge()
        return response
    }
    
    func getMyCertify(challengeId: Int) async throws -> MyCertifyResponse {
        let response = try await repository.getMyCertify(challengeId: challengeId)
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
