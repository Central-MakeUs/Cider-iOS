//
//  ProfileModifyRepository.swift
//  Cider
//
//  Created by 임영선 on 2023/08/17.
//

import Foundation
import UIKit

protocol ProfileModifyRepository {
    func patchProfile(image: UIImage) async throws -> FileResponse
}

final class DefaultProfileModifyRepository: ProfileModifyRepository {
    
    func patchProfile(image: UIImage) async throws -> FileResponse {
        return try await CiderAPI.request(target: .patchProfileImage(image: image), dataType: FileResponse.self)
    }
    
}
