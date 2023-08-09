//
//  UIViewController+Extension.swift
//  Cider
//
//  Created by 임영선 on 2023/06/28.
//

import UIKit

#if DEBUG
import SwiftUI
@available(iOS 13, *)
extension UIViewController {
    private struct Preview: UIViewControllerRepresentable {
        // this variable is used for injecting the current view controller
        let viewController: UIViewController

        func makeUIViewController(context: Context) -> UIViewController {
            return viewController
        }

        func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        }
    }

    func toPreview() -> some View {
        // inject self (the current view controller) for the preview
        Preview(viewController: self)
    }
}
#endif



extension UIViewController {
    
    func setNavigationBar(backgroundColor: UIColor?, tintColor: UIColor) {
        self.navigationController?.navigationBar.scrollEdgeAppearance?.backgroundColor = backgroundColor
        self.navigationController?.navigationBar.scrollEdgeAppearance?.titleTextAttributes = [.foregroundColor: tintColor]
        self.navigationController?.navigationBar.standardAppearance.backgroundColor = backgroundColor
        self.navigationController?.navigationBar.standardAppearance.titleTextAttributes = [.foregroundColor: tintColor]
        self.navigationItem.backBarButtonItem?.tintColor = tintColor
        self.navigationController?.navigationBar.tintColor = tintColor == .white ? .white : .custom.icon
    }
    
    func hideKeyboard() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self,
            action: #selector(UIViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
}
