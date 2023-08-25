//
//  RedrawRepository.swift
//  Cider
//
//  Created by 임영선 on 2023/08/25.
//

import Foundation

protocol RedrawRepository {
    func redraw() async throws -> CiderResponse
}

final class DefaultRedrawRepository: RedrawRepository {
    
    func redraw() async throws -> CiderResponse {
        return try await CiderAPI.request(target: .signout, dataType: CiderResponse.self)
    }
    
}

