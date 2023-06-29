//
//  ServiceAgreeViewController.swift
//  Cider
//
//  Created by 임영선 on 2023/06/29.
//

import UIKit

class ServiceAgreeViewController: UIViewController {
    
    private let processView = ProcessView()

    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    

}

private extension ServiceAgreeViewController {
    func configure() {
        view.addSubviews(processView)
        NSLayoutConstraint.activate([
            processView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            processView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            processView.topAnchor.constraint(equalTo: view.topAnchor, constant: 16)
        ])
        processView.setProcessType(.serviceAgree)
    }
}


#if DEBUG
import SwiftUI

@available(iOS 13.0, *)
struct ServiceAgreeViewController_Preview: PreviewProvider {
    static var devices = ["iPhone 12", "iPhone SE", "iPhone 11 Pro Max"]

    static var previews: some View {
        ForEach(devices, id: \.self) { deviceName in
            ServiceAgreeViewController()
                .toPreview()
                .previewDevice(PreviewDevice(rawValue: deviceName))
                .previewDisplayName(deviceName)
        }
    }
}
#endif

