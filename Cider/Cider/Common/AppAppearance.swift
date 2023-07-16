//
//  AppAppearance.swift
//  Cider
//
//  Created by 임영선 on 2023/06/30.
//

import UIKit

final class AppAppearance {
    
    static func setUpAppearance() {
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.font: CustomFont.PretendardMedium(size: .xl2).font ?? .systemFont(ofSize: 16)]
        UINavigationBar.appearance().tintColor = .custom.icon
        
        let appearance = UITabBarItem.appearance()
        let attributes = [NSAttributedString.Key.font: CustomFont.PretendardBold(size: FontSize(rawValue: 10)!).font]
        appearance.setTitleTextAttributes(attributes as [NSAttributedString.Key : Any], for: .normal)
    }
    
}
