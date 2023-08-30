//
//  CertifyUsecase.swift
//  Cider
//
//  Created by 임영선 on 2023/08/24.
//

import Foundation

import Foundation
import UIKit

protocol CertifyUsecase {
    func getMyParticipateChallenge() async throws -> ParticiapteChallengeResponse
    func postCertifyImage(image: UIImage, certifyId: Int) async throws -> CiderResponse
    func postCertify(parameters: CertifyRequest) async throws -> CertifyResponse
}

final class DefaultCertifyUsecase: CertifyUsecase {
    
    let repository: CertifyRepository
    
    init(repository: CertifyRepository) {
        self.repository = repository
    }
    
    func getMyParticipateChallenge() async throws -> ParticiapteChallengeResponse {
        let response = try await repository.getMyParticipateChallenge()
        return response
    }
    
    func postCertifyImage(image: UIImage, certifyId: Int) async throws -> CiderResponse {
        let response = try await repository.postCertifyImage(image: image, certifyId: certifyId)
        return response
    }
    
    func postCertify(parameters: CertifyRequest) async throws -> CertifyResponse {
        let response = try await repository.postCertify(parameters: parameters)
        return response
    }
    
}
