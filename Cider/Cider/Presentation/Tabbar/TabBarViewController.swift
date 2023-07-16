//
//  TabBarViewController.swift
//  Cider
//
//  Created by 임영선 on 2023/07/16.
//

import UIKit

class TabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setTabBarViewController()
    }
    
    private func setTabBarViewController() {
        let homeChallengeViewController = UINavigationController(rootViewController: UIViewController())
        homeChallengeViewController.view.backgroundColor = .white
        
        let writingViewController = UIViewController()
        writingViewController.view.backgroundColor = .white
        
        let mypageViewController = UINavigationController(rootViewController: UIViewController())
        mypageViewController.view.backgroundColor = .white
       
        homeChallengeViewController.title = "챌린지"
        writingViewController.title = "글쓰기"
        mypageViewController.title = "마이"
        
        homeChallengeViewController.tabBarItem.image = UIImage(named: "filled_noti_24")
        writingViewController.tabBarItem.image = UIImage(named: "filled_plus_24")
        mypageViewController.tabBarItem.image = UIImage(named: "filled_profile_24")
        
        self.tabBar.tintColor = .custom.main
        self.setViewControllers([homeChallengeViewController, writingViewController, mypageViewController], animated: true)
    }
}
