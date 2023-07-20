//
//  PrecautionViewModel.swift
//  Cider
//
//  Created by 임영선 on 2023/07/20.
//

import Foundation
import Combine

final class PrecautionViewModel: ViewModelType {
    
    enum ViewModelState {
        case changeNextButtonState(_ isEnabled: Bool)
    }
    
    var state: AnyPublisher<ViewModelState, Never> { currentState.compactMap { $0 }.eraseToAnyPublisher() }
    var currentState: CurrentValueSubject<ViewModelState?, Never> = .init(nil)
    private var cancellables: Set<AnyCancellable> = .init()
    
    
    private var isSelectedList = [false, false, false, false]
    
    func didTapCheckbox(index: Int) {
        isSelectedList[index].toggle()
        print(isSelectedList)
        currentState.send(.changeNextButtonState(isAvailableNextButton()))
    }
    
}

private extension PrecautionViewModel {
    
    func isAvailableNextButton() -> Bool {
        return isSelectedList.filter {$0==true}.count == 4
    }
    
}
