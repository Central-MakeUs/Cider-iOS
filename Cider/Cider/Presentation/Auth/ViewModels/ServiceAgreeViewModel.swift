//
//  ServiceAgreeViewModel.swift
//  Cider
//
//  Created by 임영선 on 2023/07/09.
//

import Foundation
import Combine

final class ServiceAgreeViewModel: ViewModelType {
    
    enum ViewModelState {
        case changeNextButtonState(isEnabled: Bool)
        case changeCheckboxState(_ selectedStates: [Bool])
    }
    
    var state: AnyPublisher<ViewModelState, Never> { currentState.compactMap { $0 }.eraseToAnyPublisher() }
    var currentState: CurrentValueSubject<ViewModelState?, Never> = .init(nil)
    private var cancellables: Set<AnyCancellable> = .init()
    var selectedStates = [false, false, false, false]
    
    func didSelectedAgreement(index: Int) {
        switch index {
        case 0,1,2:
            selectedStates[index].toggle()
            if selectedStates == [true, true, true, false] {
                selectedStates[3] = true
            }
            else {
                selectedStates[3] = false
            }
        case 3:
            if selectedStates[3] == true {
                selectedStates = [false, false, false, false]
            } else {
                selectedStates = [true, true, true, true]
            }
        default:
            break
        }
        currentState.send(.changeCheckboxState(selectedStates))
        currentState.send(.changeNextButtonState(isEnabled: selectedStates == [true, true, true, true]))
    }
    
}
