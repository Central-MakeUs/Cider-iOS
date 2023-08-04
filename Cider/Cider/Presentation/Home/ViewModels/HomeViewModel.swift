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
        case changeNextButtonState(_ isEnabled: Bool)
    }
    
    private var usecase: HomeUsecase
    var state: AnyPublisher<ViewModelState, Never> { currentState.compactMap { $0 }.eraseToAnyPublisher() }
    var currentState: CurrentValueSubject<ViewModelState?, Never> = .init(nil)
    private var cancellables: Set<AnyCancellable> = .init()
    
    
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
        }
    }
    
}
