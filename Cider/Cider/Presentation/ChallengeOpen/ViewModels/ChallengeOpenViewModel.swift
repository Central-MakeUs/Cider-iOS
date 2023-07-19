//
//  ChallengeOpenViewModel.swift
//  Cider
//
//  Created by 임영선 on 2023/07/19.
//

import Foundation
import Combine
import UIKit

final class ChallengeOpenViewModel: ViewModelType {
    
    enum ViewModelState {
        case changeNextButtonState(isEnabled: Bool)
    }
    
    var state: AnyPublisher<ViewModelState, Never> { currentState.compactMap { $0 }.eraseToAnyPublisher() }
    var currentState: CurrentValueSubject<ViewModelState?, Never> = .init(nil)
    private var cancellables: Set<AnyCancellable> = .init()
    
    private var challengeType: String?
    private var challengeName: String?
    private var challengeInfo: String?
    private var challengeCapacity: Int?
    private var recruitPeriod: Int?
    private var challengePeriod: Int?
    private var failImageData: Data?
    private var successImageData: Data?
    private var isPublic = false
    
    func selectFailImage(_ image: UIImage) {
        let data = image.jpegData(compressionQuality: 0.9)
        failImageData = data
    }
    
    func selectSuccessImage(_ image: UIImage) {
        let data = image.jpegData(compressionQuality: 0.9)
        successImageData = data
    }
    
    func selectChallengeType(_ type: ChallengeType) {
        challengeType = type.getAlphabet()
    }
    
}
