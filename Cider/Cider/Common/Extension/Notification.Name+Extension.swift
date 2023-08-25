//
//  Notification.Name+Extension.swift
//  Cider
//
//  Created by 임영선 on 2023/07/20.
//

import Foundation

extension Notification.Name {
    
    static let didChangedCiderTextField = Notification.Name("didChangedCiderTextField")
    static let didChangedUnit = Notification.Name("didChangedUnit")
    static let didChangedMember = Notification.Name("didChangedMember")
    static let didChangedChallengeDate = Notification.Name("didChangedChallengeDate")
    static let didChangedRecruit = Notification.Name("didChangedRecruit")
    static let tapChallengeDetailMenu = Notification.Name("tapChallengeDetailMenu")
    static let tapSorting = Notification.Name("tapSorting")
    static let selectProfileImage = Notification.Name("selectProfileImage")
    static let selectParticipateChallenge = Notification.Name("selectParticipateChallenge")
    static let didChangedChallengeName = Notification.Name("didChangedChallengeName")
    static let didChangedMission = Notification.Name("didChangedMission")
}
