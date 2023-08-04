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
    var popularItems: [Item] = []
    var publicItems: [Item] = []
    var categoryType: ChallengeType = .financialTech

    private var isSelectedList = [false, false, false, false]
    
    init(usecase: HomeUsecase) {
        self.usecase = usecase
    }
    
    func viewDidload() {
        getHomeChallenge()
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
    
}
