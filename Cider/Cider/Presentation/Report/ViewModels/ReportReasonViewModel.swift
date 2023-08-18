//
//  ReportReasonViewModel.swift
//  Cider
//
//  Created by 임영선 on 2023/08/18.
//

import Foundation
import Combine

final class ReportReasonViewModel: ViewModelType {
    
    enum ViewModelState {
        case isEnabledNext(_ isEnabled: Bool)
    }
    
    var state: AnyPublisher<ViewModelState, Never> { currentState.compactMap { $0 }.eraseToAnyPublisher() }
    var currentState: CurrentValueSubject<ViewModelState?, Never> = .init(nil)
    private var cancellables: Set<AnyCancellable> = .init()
    private var isSelectedReason = [false, false, false, false, false, false, false]
    
    func selectReason(_ index: Int) {
        for i in 0..<isSelectedReason.count {
            isSelectedReason[i] = i==index ? true : false
        }
        currentState.send(.isEnabledNext((isSelectedReason.filter{ $0 == true }.count) == 1))
    }
    
}
