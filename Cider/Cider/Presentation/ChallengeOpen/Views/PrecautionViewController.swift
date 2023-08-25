//
//  PrecautionViewController.swift
//  Cider
//
//  Created by 임영선 on 2023/07/20.
//

import UIKit
import Combine

final class PrecautionViewController: UIViewController {
    
    private let viewModel: PrecautionViewModel
    private var cancellables = Set<AnyCancellable>()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(axis: .vertical, alignment: .fill, distribution: .fillEqually, spacing: 0)
        stackView.addArrangedSubviews(precautionView1, precautionView2, precautionView3, precautionView4)
        return stackView
    }()
    
    private let mainTitleLabel = MainTitleLabel(title: "챌린지 신청하기 전\n유의해주세요")
    
    private lazy var precautionView1: PrecautionView = {
        let view = PrecautionView(title: "인증샷 검토는 호스트가 직접 관리해요")
        view.setButtonTag(0)
        view.addCheckboxAction(self, action: #selector(didTapCheckbox))
        return view
    }()
    
    private lazy var precautionView2: PrecautionView = {
        let view = PrecautionView(title: "챌린지 승인 후 챌린지 삭제는 불가능해요")
        view.setButtonTag(1)
        view.addCheckboxAction(self, action: #selector(didTapCheckbox))
        return view
    }()
    
    private lazy var precautionView3: PrecautionView = {
        let view = PrecautionView(title: "최소 참여 인원 3명 미충족시 진행이 불가능해요")
        view.setButtonTag(2)
        view.addCheckboxAction(self, action: #selector(didTapCheckbox))
        return view
    }()
    
    private lazy var precautionView4: PrecautionView = {
        let view = PrecautionView(title: "모집과 시작은 승인일 기준 다음날 자정에 시작해요")
        view.setButtonTag(3)
        view.addCheckboxAction(self, action: #selector(didTapCheckbox))
        return view
    }()
   
    private lazy var bottomButton: CiderBottomButton = {
        let button = CiderBottomButton(style: .disabled, title: "확인했어요")
        button.addTarget(self, action: #selector(didTapNextButton), for: .touchUpInside)
        return button
    }()
    
    init(viewModel: PrecautionViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNavigationBar()
    }

}


private extension PrecautionViewController {
    
    func setUp() {
        configure()
        bind()
    }
    
    func bind() {
        viewModel.state.receive(on: DispatchQueue.main)
            .sink { [weak self] state in
                switch state {
                case .changeNextButtonState(let isEnabled):
                    self?.bottomButton.setStyle(isEnabled ? .enabled : .disabled)
                }
            }
            .store(in: &cancellables)
    }
    
    func configure() {
        view.backgroundColor = .white
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
    
    func pushChallengeOpenCompleteViewController() {
        let viewController = ChallengeCompleteViewController()
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    func setNavigationBar() {
        self.navigationController?.navigationBar.topItem?.title = ""
        self.navigationItem.title = "유의사항"
    }
    
}

private extension PrecautionViewController {
    
    @objc func didTapCheckbox(_ sender: UIButton) {
        viewModel.didTapCheckbox(index: sender.tag)
        sender.isSelected.toggle()
    }
    
    @objc func didTapNextButton(_ sender: Any?) {
        pushChallengeOpenCompleteViewController()
    }
    
}


//#if DEBUG
//import SwiftUI
//
//@available(iOS 13.0, *)
//struct PrecautionViewController_Preview: PreviewProvider {
//    static var devices = ["iPhone 12", "iPhone SE", "iPhone 11 Pro Max"]
//
//    static var previews: some View {
//        ForEach(devices, id: \.self) { deviceName in
//            PrecautionViewController(viewModel: PrecautionViewModel())
//            .toPreview()
//            .previewDevice(PreviewDevice(rawValue: deviceName))
//            .previewDisplayName(deviceName)
//        }
//    }
//}
//#endif
