//
//  MypageUsecase.swift
//  Cider
//
//  Created by 임영선 on 2023/08/12.
//

import Foundation

protocol MypageUsecase {
    func getMypage(filter: String) async throws -> MypageResponse
}

final class DefaultMypageUsecase: MypageUsecase {
    
    let repository: MypageRepository
    
    init(repository: MypageRepository) {
        self.repository = repository
    }
    
    func getMypage(filter: String) async throws -> MypageResponse {
        let response = try await repository.getMypage()
        return response
    }

}
