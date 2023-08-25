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
        case changeNextButtonState(_ isEnabled: Bool)
        case pushPrecautionViewController(request: ChallengeOpenRequest, successData: Data, failData: Data)
    }
    
    var state: AnyPublisher<ViewModelState, Never> { currentState.compactMap { $0 }.eraseToAnyPublisher() }
    var currentState: CurrentValueSubject<ViewModelState?, Never> = .init(nil)
    private var cancellables: Set<AnyCancellable> = .init()
    let infoPlaceHolder = "챌린지 목적, 참여시 좋은 점, 참여 권유 대상 등\n챌린저들의 이해를 돕기 위한 설명을 적어주세요."
    private let textFieldMinLength = 5
    private let textViewMinLength = 30
    
    private var challengeType: String?
    var challengeName: String?
    lazy var challengeInfo = infoPlaceHolder
    var missionInfo: String?
    var challengeCapacity: Int = 3
    var recruitPeriod: Int = 1
    var challengePeriod: Int = 1
    var failImageData: Data?
    var successImageData: Data?
    private var isPublic = false
    
    func selectFailImage(_ image: UIImage) {
        let data = image.jpegData(compressionQuality: 0.9)
        failImageData = data
        currentState.send(.changeNextButtonState(isAvailableNextButton()))
    }
    
    func selectSuccessImage(_ image: UIImage) {
        let data = image.jpegData(compressionQuality: 0.9)
        successImageData = data
        currentState.send(.changeNextButtonState(isAvailableNextButton()))
    }
    
    func selectChallengeType(_ type: ChallengeType) {
        challengeType = type.alphabet
    }
    
    func changeChallengeName(_ challengeName: String) {
        self.challengeName = challengeName
        currentState.send(.changeNextButtonState(isAvailableNextButton()))
    }
    
    func changeMissionInfo(_ missionInfo: String) {
        self.missionInfo = missionInfo
        currentState.send(.changeNextButtonState(isAvailableNextButton()))
    }
    
    func changeChallengeInfo(_ challengeInfo: String) {
        self.challengeInfo = challengeInfo
        currentState.send(.changeNextButtonState(isAvailableNextButton()))
    }
    
    func changeChallengeCapacity(_ challengeCapacity: Int) {
        self.challengeCapacity = challengeCapacity
        currentState.send(.changeNextButtonState(isAvailableNextButton()))
    }
    
    func changeRecruitPeriod(_ recruitPeriod: Int) {
        self.recruitPeriod = recruitPeriod
        currentState.send(.changeNextButtonState(isAvailableNextButton()))
    }
    
    func changeChallengePeriod(_ challengePeriod: Int) {
        self.challengePeriod = challengePeriod
        currentState.send(.changeNextButtonState(isAvailableNextButton()))
    }
    
    func didTapNextButton() {
        guard let request = getRequest(),
              let successData = successImageData,
              let failData = failImageData else {
            return
        }
        currentState.send(
            .pushPrecautionViewController(
                request: request,
                successData: successData,
                failData: failData
            )
        )
    }
    
}


private extension ChallengeOpenViewModel {
    
    func isAvailableNextButton() -> Bool {
        guard let challengeName = challengeName,
              challengeInfo != infoPlaceHolder,
              let missionInfo = missionInfo,
              let _ = challengeType,
              let _ = successImageData,
              let _ = failImageData else {
            return false
        }
        guard challengeName.count >= textFieldMinLength,
              challengeInfo.count >= textViewMinLength,
              missionInfo.count >= textFieldMinLength else {
            return false
        }
        print(getRequest())
        return true
    }
    
    func getRequest() -> ChallengeOpenRequest? {
        guard let challengeName = challengeName,
              challengeInfo != infoPlaceHolder,
              let missionInfo = missionInfo,
              let challengeType = challengeType else {
            return nil
        }
        
        let request = ChallengeOpenRequest(
            challengeBranch: challengeType,
            challengeName: challengeName,
            challengeInfo: challengeInfo,
            certifyMission: missionInfo,
            challengeCapacity: challengeCapacity,
            recruitPeriod: recruitPeriod,
            challengePeriod: challengePeriod,
            isPublic: isPublic
        )
        return request
    }
    
}
