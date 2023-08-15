//
//  MypageRepository.swift
//  Cider
//
//  Created by 임영선 on 2023/08/12.
//

import Foundation

protocol MypageRepository {
    func getMypage() async throws -> MypageResponse
}


final class DefaultMypageRepository: MypageRepository {
    
    func getMypage() async throws -> MypageResponse {
        return try await CiderAPI.request(target: .getMypage, dataType: MypageResponse.self)
    }
    
}
