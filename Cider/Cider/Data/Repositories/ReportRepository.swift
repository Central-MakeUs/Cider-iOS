//
//  ReportRepository.swift
//  Cider
//
//  Created by 임영선 on 2023/08/25.
//

import Foundation

protocol ReportRepository {
    func reportUser(parameters: ReportRequest) async throws -> CiderResponse
    func reportFeed(parameters: ReportRequest) async throws -> CiderResponse
    func blockUser(parameters: ReportRequest) async throws -> CiderResponse
    func blockFeed(parameters: ReportRequest) async throws -> CiderResponse
}

final class DefaultReportRepository: ReportRepository {
    
    func reportUser(parameters: ReportRequest) async throws -> CiderResponse {
        return try await CiderAPI.request(target: .reportUser(parameters: parameters.asDictionary()), dataType: CiderResponse.self)
    }
    
    func reportFeed(parameters: ReportRequest) async throws -> CiderResponse {
        return try await CiderAPI.request(target: .reportFeed(parameters: parameters.asDictionary()), dataType: CiderResponse.self)
    }
    
    func blockUser(parameters: ReportRequest) async throws -> CiderResponse {
        return try await CiderAPI.request(target: .blockUser(parameters: parameters.asDictionary()), dataType: CiderResponse.self)
    }
    
    func blockFeed(parameters: ReportRequest) async throws -> CiderResponse {
        return try await CiderAPI.request(target: .blockFeed(parameters: parameters.asDictionary()), dataType: CiderResponse.self)
    }
    
    
   
    
}
