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
    let reasons = ["올바르지 않은 인증 내용 및 사진", "상업적 광고 및 판매", "중복 및 도배성 글", "욕설 및 외설적인 언어 사용", "명예 훼손 및 타인 비방", "정치 종교 목적의 게시글", "게시판 성격에 부적절함"]
    var selectedIndex = 0
    
    func selectReason(_ index: Int) {
        selectedIndex = index
        for i in 0..<isSelectedReason.count {
            isSelectedReason[i] = i==index ? true : false
        }
        currentState.send(.isEnabledNext((isSelectedReason.filter{ $0 == true }.count) == 1))
    }
    
}
