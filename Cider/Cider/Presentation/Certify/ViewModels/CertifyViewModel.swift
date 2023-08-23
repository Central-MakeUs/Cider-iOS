//
//  CertifyViewModel.swift
//  Cider
//
//  Created by 임영선 on 2023/08/23.
//

import Foundation
import Combine
import UIKit

final class CertifyViewModel: ViewModelType {
    
    enum ViewModelState {
        case changeNextButtonState(_ isEnabled: Bool)
    }
    
    var state: AnyPublisher<ViewModelState, Never> { currentState.compactMap { $0 }.eraseToAnyPublisher() }
    var currentState: CurrentValueSubject<ViewModelState?, Never> = .init(nil)
    private var cancellables: Set<AnyCancellable> = .init()
    
    private let textFieldMinLength = 5
    private let textViewMinLength = 1
    
    var challengeList: [String] = ["만보걷기", "어쩌고좀비버스재밌따"]
    var challengeIds: [Int] = [5, 10]
    var challengeIndex: Int = 0
    lazy var challengeName = challengeNamePlaceHolder
    lazy var challengeContent = challengeContentPlaceHolder
    var certifyImage: UIImage?
    
    var challengeNamePlaceHolder = "오늘 인증 완료!"
    var challengeContentPlaceHolder = "인증에 대한 이야기와 다양한 생각들, 사진에 대한 설명을 작성해보세요!"
    
    func selectImage(_ image: UIImage) {
        let data = image.jpegData(compressionQuality: 0.9)
        certifyImage = image
        currentState.send(.changeNextButtonState(isAvailableNextButton()))
    }
    
    func changeChallengeName(_ challengeName: String) {
        self.challengeName = challengeName
        currentState.send(.changeNextButtonState(isAvailableNextButton()))
    }
    
    func changechallengeContent(_ challengeContent: String) {
        self.challengeContent = challengeContent
        currentState.send(.changeNextButtonState(isAvailableNextButton()))
    }
    
    func selectChallengeIndex(_ challengeIndex: Int) {
        self.challengeIndex = challengeIndex
        currentState.send(.changeNextButtonState(isAvailableNextButton()))
    }
    
}


private extension CertifyViewModel {
    
    func isAvailableNextButton() -> Bool {
        print(challengeName, challengeIndex, challengeContent, certifyImage)

        guard challengeName != challengeNamePlaceHolder,
              challengeContent != challengeContentPlaceHolder,
              let _ = certifyImage else {
            return false
        }
        
        guard challengeName.count >= textFieldMinLength,
              challengeContent.count >= textViewMinLength else {
            return false
        }
        return true
    }
    
}
