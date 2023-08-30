//
//  MyCertifyRepository.swift
//  Cider
//
//  Created by 임영선 on 2023/08/23.
//

import Foundation

protocol MyCertifyRepository {
    func getMyParticipateChallenge() async throws -> ParticiapteChallengeResponse
    func getMyCertify(challengeId: Int) async throws -> MyCertifyResponse
    func postLikeFeed(certifyId: Int) async throws -> LikeResponse
    func deleteLikeFeed(certifyId: Int) async throws -> LikeResponse
}

final class DefaultMyCertifyRepository: MyCertifyRepository {
    
    func getMyParticipateChallenge() async throws -> ParticiapteChallengeResponse {
        return try await CiderAPI.request(target: .getMyParticipateChallenge, dataType: ParticiapteChallengeResponse.self)
    }
    
    func getMyCertify(challengeId: Int) async throws -> MyCertifyResponse {
        return try await CiderAPI.request(target: .getMyCerify(challengeId: challengeId), dataType: MyCertifyResponse.self)
    }
    
    func postLikeFeed(certifyId: Int) async throws -> LikeResponse {
        let request = FeedLikeRequest(certifyId: certifyId)
        return try await CiderAPI.request(target: .postLikeFeed(parameters: request.asDictionary()), dataType: LikeResponse.self)
    }
    
    func deleteLikeFeed(certifyId: Int) async throws -> LikeResponse {
        return try await CiderAPI.request(target: .deleteLikeFeed(certifyId: String(certifyId)), dataType: LikeResponse.self)
    }
    
}
