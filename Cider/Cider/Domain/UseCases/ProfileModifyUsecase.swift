//
//  ProfileModifyUsecase.swift
//  Cider
//
//  Created by 임영선 on 2023/08/17.
//

import Foundation
import UIKit

protocol ProfileModifyUsecase {
    func patchProfile(image: UIImage) async throws -> CiderResponse
    func patchProfile(parameters: ProfileModifyRequest) async throws -> CiderResponse
}

final class DefaultProfileModifyUsecase: ProfileModifyUsecase {
    
    let repository: ProfileModifyRepository
    
    init(repository: ProfileModifyRepository) {
        self.repository = repository
    }
    
    func patchProfile(image: UIImage) async throws -> CiderResponse {
        let response = try await repository.patchProfile(image: image)
        return response
    }
    
    func patchProfile(parameters: ProfileModifyRequest) async throws -> CiderResponse {
        let response = try await repository.patchProfile(parameters: parameters)
        return response
    }
    
}
