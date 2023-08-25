//
//  ReportUsecase.swift
//  Cider
//
//  Created by 임영선 on 2023/08/25.
//

import Foundation

protocol ReportUsecase {
    func reportUser(parameters: ReportRequest) async throws -> CiderResponse
    func reportFeed(parameters: ReportRequest) async throws -> CiderResponse
    func blockUser(parameters: ReportRequest) async throws -> CiderResponse
    func blockFeed(parameters: ReportRequest) async throws -> CiderResponse
}

final class DefaultReportUsecase: ReportUsecase {
    
    let repository: ReportRepository
    
    init(repository: ReportRepository) {
        self.repository = repository
    }
    
    func reportUser(parameters: ReportRequest) async throws -> CiderResponse {
        return try await repository.reportUser(parameters: parameters)
    }
    
    func reportFeed(parameters: ReportRequest) async throws -> CiderResponse {
        return try await repository.reportFeed(parameters: parameters)
    }
    
    func blockUser(parameters: ReportRequest) async throws -> CiderResponse {
        return try await repository.blockUser(parameters: parameters)
    }
    
    func blockFeed(parameters: ReportRequest) async throws -> CiderResponse {
        return try await repository.blockFeed(parameters: parameters)
    }
    
    
}
