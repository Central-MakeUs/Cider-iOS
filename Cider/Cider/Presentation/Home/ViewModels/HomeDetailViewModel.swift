//
//  HomeDetailViewModel.swift
//  Cider
//
//  Created by 임영선 on 2023/08/05.
//

import Foundation
import Combine

final class HomeDetailViewModel: ViewModelType {
    
    enum ViewModelState {
        case applySnapshot(_ isSuccess: Bool)
    }
    
    private var usecase: HomeDetailUsecase
    var state: AnyPublisher<ViewModelState, Never> { currentState.compactMap { $0 }.eraseToAnyPublisher() }
    var currentState: CurrentValueSubject<ViewModelState?, Never> = .init(nil)
    private var cancellables: Set<AnyCancellable> = .init()
    var challenges: [ChallengeElement] = []
    var items: [Item] = []
   
    init(usecase: HomeDetailUsecase) {
        self.usecase = usecase
    }
    
    func viewDidload(type: HomeDetailType, filter: String) {
        switch type {
        case .popularChallenge:
            getPopularChallenges(filter: filter)
        case .publicChallenge:
            getPubicChallenges(filter: filter)
        case .allChallenge:
            getAllChallenges(filter: filter)
        }
    }
   
}

private extension HomeDetailViewModel {
    
    func getPopularChallenges(filter: String) {
        Task {
            let response = try await usecase.getPopularChallenge(filter: filter)
            print(response)
            items = []
            for _ in 0..<challenges.count {
                items.append(Item())
            }
            currentState.send(.applySnapshot(true))
        }
    }
    
    func getPubicChallenges(filter: String) {
        Task {
            let response = try await usecase.getPublicChallenge(filter: filter)
            print(response)
            items = []
            for _ in 0..<challenges.count {
                items.append(Item())
            }
            currentState.send(.applySnapshot(true))
        }
    }
    
    func getAllChallenges(filter: String) {
        Task {
            let response = try await usecase.getAllChallenge(filter: filter)
            print(response)
            items = []
            for _ in 0..<challenges.count {
                items.append(Item())
            }
            currentState.send(.applySnapshot(true))
        }
    }
    
}
