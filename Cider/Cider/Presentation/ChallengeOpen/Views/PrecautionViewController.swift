//
//  PrecautionViewController.swift
//  Cider
//
//  Created by 임영선 on 2023/07/20.
//

import UIKit

final class PrecautionViewController: UIViewController {
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(axis: .vertical, alignment: .fill, distribution: .fillEqually, spacing: 0)
        stackView.addArrangedSubviews(precautionView1, precautionView2, precautionView3, precautionView4)
        return stackView
    }()
    
    private let mainTitleLabel = MainTitleLabel(title: "챌린지 신청하기 전\n유의해주세요")
    
    private let precautionView1 = PrecautionView(title: "인증샷 검토는 호스트가 직접 관리해요")
    private let precautionView2 = PrecautionView(title: "챌린지 승인 후 챌린지 삭제는 불가능해요")
    private let precautionView3 = PrecautionView(title: "최소 참여 인원 3명 미충족시 진행이 불가능해요")
    private let precautionView4 = PrecautionView(title: "모집과 시작은 승인일 기준 다음날 자정에 시작해요")

    private lazy var bottomButton: CiderBottomButton = {
        let button = CiderBottomButton(style: .disabled, title: "확인했어요")
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
    }


}


private extension PrecautionViewController {
    
    func setUp() {
        configure()
    }
    
    func configure() {
        view.addSubviews(mainTitleLabel, stackView, bottomButton)
        NSLayoutConstraint.activate([
            mainTitleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 54),
            mainTitleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            bottomButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            bottomButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            bottomButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            stackView.bottomAnchor.constraint(equalTo: bottomButton.topAnchor, constant: -24),
            stackView.heightAnchor.constraint(equalToConstant: 192)
        ])
    }
    
}


#if DEBUG
import SwiftUI

@available(iOS 13.0, *)
struct PrecautionViewController_Preview: PreviewProvider {
    static var devices = ["iPhone 12", "iPhone SE", "iPhone 11 Pro Max"]

    static var previews: some View {
        ForEach(devices, id: \.self) { deviceName in
            PrecautionViewController()
            .toPreview()
            .previewDevice(PreviewDevice(rawValue: deviceName))
            .previewDisplayName(deviceName)
        }
    }
}
#endif
