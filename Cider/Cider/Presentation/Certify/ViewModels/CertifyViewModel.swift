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
        case applySnapshot
        case showMessage(_ message: String)
        case isSuccess(_ isSuccess: Bool)
    }
    
    var state: AnyPublisher<ViewModelState, Never> { currentState.compactMap { $0 }.eraseToAnyPublisher() }
    var currentState: CurrentValueSubject<ViewModelState?, Never> = .init(nil)
    private var cancellables: Set<AnyCancellable> = .init()
    
    private let usecase: CertifyUsecase
    
    private let textFieldMinLength = 5
    private let textViewMinLength = 1
    
    var challengeList: [String] = []
    var challengeIds: [Int] = []
    var selectedChallengeIndex: Int = 0
    lazy var selectedChallengeTitle: String = challengeList.first ?? ""
    lazy var challengeName = challengeNamePlaceHolder
    lazy var challengeContent = challengeContentPlaceHolder
    var certifyImage: UIImage?
    private var selectedChallengeId: Int?
    
    var challengeNamePlaceHolder = "오늘 인증 완료!"
    var challengeContentPlaceHolder = "인증에 대한 이야기와 다양한 생각들, 사진에 대한 설명을 작성해보세요!"
    
    init(usecase: CertifyUsecase, selectedChallengeId: Int?) {
        self.usecase = usecase
        self.selectedChallengeId = selectedChallengeId
    }
    
    func viewDidLoad() {
        getMyParticipateChallenge()
    }
    
    func selectImage(_ image: UIImage) {
        certifyImage = image
        currentState.send(.changeNextButtonState(isAvailableNextButton()))
    }
    
    func changeChallengeName(_ challengeName: String) {
        self.challengeName = challengeName
        currentState.send(.changeNextButtonState(isAvailableNextButton()))
    }
    
    func changeCertifyImage(_ image: UIImage?) {
        self.certifyImage = image
        currentState.send(.changeNextButtonState(isAvailableNextButton()))
    }
    
    func changechallengeContent(_ challengeContent: String) {
        self.challengeContent = challengeContent
        currentState.send(.changeNextButtonState(isAvailableNextButton()))
    }
    
    func selectChallengeIndex(_ challengeIndex: Int) {
        self.selectedChallengeIndex = challengeIndex
        currentState.send(.changeNextButtonState(isAvailableNextButton()))
    }
    
    func didTapBottomButton() {
        upload()
    }
    
}


private extension CertifyViewModel {
    
    func upload() {
        Task {
            let request = CertifyRequest(
                challengeId: challengeIds[selectedChallengeIndex],
                certifyName: challengeName,
                certifyContent: challengeContent
            )
            let certifyResponse = try await usecase.postCertify(parameters: request)
            print(certifyResponse)
            guard let certifyImage else {
                return
            }
            let certifyImageResponse = try await usecase.postCertifyImage(image: certifyImage, certifyId: certifyResponse.certifyId)
            print(certifyImageResponse)
            if certifyImageResponse.status == nil {
                currentState.send(.isSuccess(true))
            } else {
                currentState.send(.showMessage(certifyImageResponse.error ?? ""))
            }
        }
    }
    
    func getMyParticipateChallenge() {
        Task {
            let response = try await usecase.getMyParticipateChallenge()
            
            guard response.count > 0 else {
                return
            }
            for challenge in response {
                challengeList.append(challenge.challengeName)
                challengeIds.append(challenge.challengeId)
            }
            if let selectedChallengeId {
                for i in 0..<challengeIds.count {
                    if selectedChallengeId == challengeIds[i] {
                        selectedChallengeIndex = i
                        selectedChallengeTitle = challengeList[i]
                        break
                    }
                }
            }
            currentState.send(.applySnapshot)
        }
    }
    
    func isAvailableNextButton() -> Bool {
        print(challengeName, selectedChallengeIndex, challengeContent, certifyImage)

        guard challengeName != challengeNamePlaceHolder,
              challengeContent != challengeContentPlaceHolder,
              challengeList.count > 0,
              challengeName.count > 0,
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
