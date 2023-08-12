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
        case applySnapshot(_ isSuccess: Bool)
    }
    
    private var usecase: HomeUsecase
    var state: AnyPublisher<ViewModelState, Never> { currentState.compactMap { $0 }.eraseToAnyPublisher() }
    
    var currentState: CurrentValueSubject<ViewModelState?, Never> = .init(nil)
    private var cancellables: Set<AnyCancellable> = .init()

    init(usecase: HomeUsecase) {
        self.usecase = usecase
    }
    
}
