//
//  RedrawUsecase.swift
//  Cider
//
//  Created by 임영선 on 2023/08/25.
//

import Foundation

protocol RedrawUsecase {
    func redraw() async throws -> CiderResponse
}

final class DefaultRedrawUsecase: RedrawUsecase {
    
    let repository: RedrawRepository
    
    init(repository: RedrawRepository) {
        self.repository = repository
    }
    
    func redraw() async throws -> CiderResponse {
        let response = try await repository.redraw()
        return response
    }

}
