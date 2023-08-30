//
//  ReportViewModel.swift
//  Cider
//
//  Created by 임영선 on 2023/08/25.
//

import Foundation
import Combine

final class ReportViewModel: ViewModelType {
    
    enum ViewModelState {
        case sendData(_ data: MypageResponse)
    }
    
    private let usecase: ReportUsecase
    private let userId: Int
    private let certifyId: Int
    private let reason: String?
    
    var state: AnyPublisher<ViewModelState, Never> { currentState.compactMap { $0 }.eraseToAnyPublisher() }
    
    var currentState: CurrentValueSubject<ViewModelState?, Never> = .init(nil)
    private var cancellables: Set<AnyCancellable> = .init()
    var data: MypageResponse?

    init(usecase: ReportUsecase, userId: Int, certifyId: Int, reason: String?) {
        self.usecase = usecase
        self.userId = userId
        self.certifyId = certifyId
        self.reason = reason
    }
    
    func report(_ reportType: ReportType) {
        switch reportType {
        case .userReport:
            reportUser()
        case .postReport:
            reportFeed()
        case .userBlock:
            blockUser()
        case .postBlock:
            blockFeed()
        }
    }
    
}

private extension ReportViewModel {
    
    func reportUser() {
        Task {
            do {
                let request = ReportRequest(contentId: userId, reason: reason ?? "")
                let response = try await usecase.reportUser(parameters: request)
                print(response)
            }
        }
    }
    
    func reportFeed() {
        Task {
            do {
                let request = ReportRequest(contentId: certifyId, reason: reason ?? "")
                let response = try await usecase.reportFeed(parameters: request)
                print(response)
            }
        }
    }
    
    func blockUser() {
        Task {
            do {
                let request = ReportRequest(contentId: userId, reason: reason ?? "")
                let response = try await usecase.blockUser(parameters: request)
                print(response)
                NotificationCenter.default.post(name: .reloadFeed, object: nil)
            }
        }
    }
    
    func blockFeed() {
        Task {
            do {
                let request = ReportRequest(contentId: certifyId, reason: reason ?? "")
                let response = try await usecase.blockFeed(parameters: request)
                print(response)
                NotificationCenter.default.post(name: .reloadFeed, object: nil)
            }
        }
    }

    
}
