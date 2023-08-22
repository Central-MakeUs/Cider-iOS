//
//  MyCertifyViewModel.swift
//  Cider
//
//  Created by 임영선 on 2023/08/15.
//

import Foundation
import Combine

final class MyCertifyViewModel: ViewModelType {
    
    enum ViewModelState {
        case applySnapshot(_ isSuccess: Bool)
    }
    
    private var usecase: HomeUsecase
    var state: AnyPublisher<ViewModelState, Never> { currentState.compactMap { $0 }.eraseToAnyPublisher() }
    var currentState: CurrentValueSubject<ViewModelState?, Never> = .init(nil)
    private var cancellables: Set<AnyCancellable> = .init()
    var feeds: FeedResponse = []
    var feedItems: [Item] = []
    
    init(usecase: HomeUsecase) {
        self.usecase = usecase
    }
    
    func viewWillAppear() {
        reload()
    }
    
    func likeFeed(isLike: Bool, certifyId: Int) {
        isLike ? deleteLikeFeed(certifyId: certifyId): postLikeFeed(certifyId: certifyId)
    }
    
}

private extension MyCertifyViewModel {
    
    func reload() {
        getHomeFeed()
    }
    
    func getHomeFeed() {
        Task {
            let response = try await usecase.getHomeFeed()
            print(response)
            feeds = response
            feedItems = []
            for _ in 0..<feeds.count {
                feedItems.append(Item())
            }
            setEmptyState()
            currentState.send(.applySnapshot(true))
        }
    }
    
    func deleteLikeFeed(certifyId: Int) {
        Task {
            let response = try await usecase.deleteLikeFeed(certifyId: certifyId)
            print(response)
        }
    }
    
    func postLikeFeed(certifyId: Int) {
        Task {
            let response = try await usecase.postLikeFeed(certifyId: certifyId)
            print(response)
        }
    }
    
    func setEmptyState() {
        if feeds.count <= 0 {
            feedItems = [Item()]
        }
    }
    
}
