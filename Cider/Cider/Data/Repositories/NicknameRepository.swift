//
//  NicknameRepository.swift
//  Cider
//
//  Created by 임영선 on 2023/07/14.
//

import Foundation

protocol NicknameRepository {
    func getDuplicateNickname(nickname: String) async throws -> DuplicateNicknameResponse
    func getRandomNickname() async throws -> RandomNicknameResponse
}

final class DefaultNicknameRepository: NicknameRepository {
    
    func getDuplicateNickname(nickname: String) async throws -> DuplicateNicknameResponse {
        return try await CiderAPI.request(target: .getDuplicateNickname(nickname: nickname), dataType: DuplicateNicknameResponse.self)
    }
    
    func getRandomNickname() async throws -> RandomNicknameResponse {
        return try await CiderAPI.request(target: .getRandomNickname, dataType: RandomNicknameResponse.self)
    }
    
}
