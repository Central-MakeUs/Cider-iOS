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
    
    func setNavigationBar(backgroundColor: UIColor?, tintColor: UIColor, shadowColor: UIColor?) {
        self.navigationController?.navigationBar.scrollEdgeAppearance?.backgroundColor = backgroundColor
        self.navigationController?.navigationBar.scrollEdgeAppearance?.titleTextAttributes = [.foregroundColor: tintColor]
        self.navigationController?.navigationBar.standardAppearance.backgroundColor = backgroundColor
        self.navigationController?.navigationBar.standardAppearance.titleTextAttributes = [.foregroundColor: tintColor]
        self.navigationItem.backBarButtonItem?.tintColor = tintColor
        self.navigationController?.navigationBar.tintColor = tintColor == .white ? .white : .custom.icon
        self.navigationController?.navigationBar.scrollEdgeAppearance?.shadowColor = shadowColor
        self.navigationController?.navigationBar.standardAppearance.shadowColor = shadowColor
    }
    
    func hideKeyboard() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self,
            action: #selector(UIViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func showToast(message : String) {
        let toastLabel = DynamicLabel(horizontalPadding: 30, verticalPadding: 12)
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        toastLabel.textColor = UIColor.white
        toastLabel.font = CustomFont.PretendardRegular(size: .lg).font
        toastLabel.textAlignment = .center
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 8
        toastLabel.clipsToBounds  =  true
        
        view.addSubviews(toastLabel)
        NSLayoutConstraint.activate([
            toastLabel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -40),
            toastLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        self.view.addSubview(toastLabel)
        UIView.animate(withDuration: 0.3, delay: 0.9, options: .curveEaseOut, animations: {
            toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    }
    
    func showAlert(message: String) {
        let alert = UIAlertController(title: "알림", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(alert, animated: true)
    }
    
}
