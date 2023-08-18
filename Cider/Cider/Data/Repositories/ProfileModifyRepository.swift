//
//  ProfileModifyRepository.swift
//  Cider
//
//  Created by 임영선 on 2023/08/17.
//

import Foundation
import UIKit

protocol ProfileModifyRepository {
    func patchProfile(image: UIImage) async throws -> CiderResponse
    func patchProfile(parameters: ProfileModifyRequest) async throws -> CiderResponse
}

final class DefaultProfileModifyRepository: ProfileModifyRepository {
    
    func patchProfile(image: UIImage) async throws -> CiderResponse {
        return try await CiderAPI.request(target: .patchProfileImage(image: image), dataType: CiderResponse.self)
    }
    
    func patchProfile(parameters: ProfileModifyRequest) async throws -> CiderResponse {
        return try await CiderAPI.request(target: .patchProfile(parameters: parameters.asDictionary()), dataType: CiderResponse.self)
    }
    
}
