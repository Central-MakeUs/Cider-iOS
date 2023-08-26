//
//  RedrawViewModel.swift
//  Cider
//
//  Created by 임영선 on 2023/08/25.
//

import Foundation
import Combine

final class RedrawViewModel: ViewModelType {
   
    enum ViewModelState {
        case success
    }
    
    
    private var usecase: RedrawUsecase
    var state: AnyPublisher<ViewModelState, Never> { currentState.compactMap { $0 }.eraseToAnyPublisher() }
    
    var currentState: CurrentValueSubject<ViewModelState?, Never> = .init(nil)
    private var cancellables: Set<AnyCancellable> = .init()

    init(usecase: RedrawUsecase) {
        self.usecase = usecase
    }
    
    func redraw() {
        Task {
            do {
                guard let refreshToken = Keychain.loadRefreshToken() else {
                    return
                }
                Keychain.saveToken(data: refreshToken)
                let response = try await usecase.redraw()
                print(response)
            }
        }
    }
    
}
