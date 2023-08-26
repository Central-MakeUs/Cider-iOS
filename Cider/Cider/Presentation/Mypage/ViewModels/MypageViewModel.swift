//
//  MypageViewModel.swift
//  Cider
//
//  Created by 임영선 on 2023/08/12.
//

import Foundation
import Combine

final class MypageViewModel: ViewModelType {
    
    enum ViewModelState {
        case sendData(_ data: MypageResponse)
    }
    
    private var usecase: MypageUsecase
    var state: AnyPublisher<ViewModelState, Never> { currentState.compactMap { $0 }.eraseToAnyPublisher() }
    
    var currentState: CurrentValueSubject<ViewModelState?, Never> = .init(nil)
    private var cancellables: Set<AnyCancellable> = .init()
    var data: MypageResponse?

    init(usecase: MypageUsecase) {
        self.usecase = usecase
    }
    
    func viewDidLoad() {
        getMypage()
    }
    
}

private extension MypageViewModel {
    
    func getMypage() {
        Task {
            do {
                let response = try await usecase.getMypage()
                print(response)
                data = response
                currentState.send(.sendData(response))
            }
        }
    }
    
}
