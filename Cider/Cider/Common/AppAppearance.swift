//
//  AppAppearance.swift
//  Cider
//
//  Created by 임영선 on 2023/06/30.
//

import UIKit

final class AppAppearance {
    
    static func setUpAppearance() {
        let navigationBarAppearance = UINavigationBarAppearance()
        navigationBarAppearance.configureWithOpaqueBackground()
        navigationBarAppearance.backgroundColor = UIColor.white
        navigationBarAppearance.shadowColor = .white
        navigationBarAppearance.titleTextAttributes = [
            NSAttributedString.Key.font: CustomFont.PretendardMedium(size: .xl2).font ?? .systemFont(ofSize: 16),
            .foregroundColor: UIColor.black
        ]
        UINavigationBar.appearance().tintColor = .custom.icon
        UINavigationBar.appearance().standardAppearance = navigationBarAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = navigationBarAppearance
        
        let tabBarItemappearance = UITabBarItem.appearance()
        let attributes = [NSAttributedString.Key.font: CustomFont.PretendardBold(size: FontSize(rawValue: 10)!).font]
        tabBarItemappearance.setTitleTextAttributes(attributes as [NSAttributedString.Key : Any], for: .normal)
        
        let tabBarAppearance = UITabBarAppearance()
        tabBarAppearance.backgroundColor = .white
        UITabBar.appearance().standardAppearance = tabBarAppearance
        UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
    }
    
}
