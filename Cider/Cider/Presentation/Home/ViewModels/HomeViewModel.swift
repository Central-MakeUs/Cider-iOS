//
//  HomeViewModel.swift
//  Cider
//
//  Created by 임영선 on 2023/08/04.
//

import Foundation
import Combine

final class HomeViewModel: ViewModelType {
    
    enum ViewModelState {
        case applySnapshot(_ isSuccess: Bool)
    }
    
    private var usecase: HomeUsecase
    var state: AnyPublisher<ViewModelState, Never> { currentState.compactMap { $0 }.eraseToAnyPublisher() }
    var currentState: CurrentValueSubject<ViewModelState?, Never> = .init(nil)
    private var cancellables: Set<AnyCancellable> = .init()
    var popularChallanges: [ChallengeResponseDto]?
    var publicChallanges: [ChallengeResponseDto]?
    var categoryChallenges: [ChallengeElement] = []
    var feeds: FeedResponse = []
    var popularItems: [Item] = []
    var publicItems: [Item] = []
    var categoryItems: [Item] = []
    var feedItems: [Item] = []
    var categoryType: ChallengeType = .financialTech
    
    init(usecase: HomeUsecase) {
        self.usecase = usecase
    }
    
    func viewDidload() {
        getHomeChallenge()
        getCategory(categoryType.alphabet)
        getHomeFeed()
    }
    
    func getCategory(_ category: String) {
        getCategoryChallenge(category)
    }
    
}

private extension HomeViewModel {
    
    func getHomeChallenge() {
        Task {
            let response = try await usecase.getHomeChallenge()
            print(response)
            popularChallanges = response.popularChallengeResponseDto
            publicChallanges = response.officialChallengeResponseDto
            
            guard let popularChallanges,
                  let publicChallanges else {
                return
            }
            for _ in 0..<popularChallanges.count {
                popularItems.append(Item())
            }
            for _ in 0..<publicChallanges.count {
                publicItems.append(Item())
            }
            currentState.send(.applySnapshot(true))
        }
    }
    
    func getCategoryChallenge(_ category: String) {
        Task {
            let response = try await usecase.getCategory(category: category)
            print(response)
            categoryChallenges = response
            categoryItems = []
            for _ in 0..<categoryChallenges.count {
                categoryItems.append(Item())
            }
            currentState.send(.applySnapshot(true))
        }
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
            currentState.send(.applySnapshot(true))
        }
    }
    
}
