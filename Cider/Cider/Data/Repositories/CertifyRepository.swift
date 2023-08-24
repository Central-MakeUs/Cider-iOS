//
//  CertifyRepository.swift
//  Cider
//
//  Created by 임영선 on 2023/08/24.
//

import Foundation
import UIKit

protocol CertifyRepository {
    func getMyParticipateChallenge() async throws -> ParticiapteChallengeResponse
    func postCertifyImage(image: UIImage, certifyId: Int) async throws -> CiderResponse
    func postCertify(parameters: CertifyRequest) async throws -> CertifyResponse
}

final class DefaultCertifyRepository: CertifyRepository {
    
    func getMyParticipateChallenge() async throws -> ParticiapteChallengeResponse {
        return try await CiderAPI.request(target: .getMyParticipateChallenge, dataType: ParticiapteChallengeResponse.self)
    }
    
    func postCertifyImage(image: UIImage, certifyId: Int) async throws -> CiderResponse {
        return try await CiderAPI.request(target: .postCertifyImage(image: image, certifyId: certifyId), dataType: CiderResponse.self)

    }
    
    func postCertify(parameters: CertifyRequest) async throws -> CertifyResponse {
        return try await CiderAPI.request(target: .postCertify(parameters: parameters.asDictionary()), dataType: CertifyResponse.self)
    }
    
}
