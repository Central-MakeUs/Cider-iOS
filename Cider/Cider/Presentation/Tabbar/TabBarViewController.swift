//
//  TabBarViewController.swift
//  Cider
//
//  Created by 임영선 on 2023/07/16.
//

import UIKit

final class TabBarViewController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTabBarViewController()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    private func setTabBarViewController() {
        let homeChallengeViewController = UINavigationController(
            rootViewController: HomeViewController(
                viewModel: HomeViewModel(
                    usecase: DefaultHomeUsecase(
                        repository: DefaultHomeRepository()
                    )
                )
            )
        )
        let dummyViewController = UIViewController()
        
        let mypageViewController = UINavigationController(
            rootViewController: MypageViewController(
                viewModel: MypageViewModel(
                    usecase: DefaultMypageUsecase(
                        repository: DefaultMypageRepository()
                    )
                )
            )
        )
        
        homeChallengeViewController.view.backgroundColor = .white
        mypageViewController.view.backgroundColor = .white
        
        homeChallengeViewController.title = "챌린지"
        dummyViewController.title = "글쓰기"
        mypageViewController.title = "마이"
        
        homeChallengeViewController.tabBarItem.image = UIImage(named: "filled_noti_24")
        homeChallengeViewController.tabBarItem.tag = 0
        
        dummyViewController.tabBarItem.image = UIImage(named: "filled_plus_24")
        dummyViewController.tabBarItem.tag = 1
        
        mypageViewController.tabBarItem.image = UIImage(named: "filled_profile_24")
        mypageViewController.tabBarItem.tag = 2
        
        self.delegate = self
        self.tabBar.tintColor = .custom.main
        self.setViewControllers([homeChallengeViewController, dummyViewController, mypageViewController], animated: true)
    }
    
    private func showWritingViewController() {
        let viewController = WritingViewController()
        if let sheet = viewController.sheetPresentationController {
            let identifier = UISheetPresentationController.Detent.Identifier("customMedium")
            let customDetent = UISheetPresentationController.Detent.custom(identifier: identifier) { context in
                return 200-10
            }
            sheet.detents = [customDetent]
            sheet.prefersScrollingExpandsWhenScrolledToEdge = false
            sheet.prefersGrabberVisible = true
        }
        self.present(viewController, animated: true)
    }
    
}

extension TabBarViewController: UITabBarControllerDelegate {
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        if viewController.tabBarItem.tag == 1 {
            showWritingViewController()
            return false
        } else {
            return true
        }
    }
    
}
