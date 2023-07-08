//
//  KeywordViewController.swift
//  Cider
//
//  Created by 임영선 on 2023/07/07.
//

import UIKit
import Combine

final class ChallengeSelectionViewController: UIViewController {

    private let viewModel = ChallengeSelectionViewModel()
    private var cancellables = Set<AnyCancellable>()
    
    private let processView = ProcessView()
    private let challengesView = ChallengesView()
    
    private lazy var mainTitleLabel: UILabel = {
        let label = UILabel()
        label.font = CustomFont.PretendardBold(size: .xl5).font
        label.text = "원하는 챌린지 분야를\n선택해보세요"
        label.textColor = .custom.text
        label.setTextWithLineHeight(lineHeight: 39.2)
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var rightButton: UIButton = {
        let button = UIButton()
        button.setTitle("완료", for: .normal)
        button.titleLabel?.font = CustomFont.PretendardBold(size: .lg).font
        button.setTitleColor(.custom.gray7, for: .normal)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        bind()
        setTapGesture()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNavigationBar()
    }
    
}


private extension ChallengeSelectionViewController {
    
    func configure() {
        view.backgroundColor = .white
        processView.setProcessType(.challengeRecommendation)
        view.addSubviews(processView, mainTitleLabel, challengesView)
        
        NSLayoutConstraint.activate([
            processView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            processView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            processView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            mainTitleLabel.topAnchor.constraint(equalTo: processView.bottomAnchor, constant: 24),
            mainTitleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            challengesView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            challengesView.leadingAnchor.constraint(equalTo: mainTitleLabel.leadingAnchor),
            challengesView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            challengesView.heightAnchor.constraint(equalToConstant: 304)
        ])
    }
    
    func setNavigationBar() {
        self.navigationController?.navigationBar.topItem?.title = ""
        self.navigationItem.title = "회원가입"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: rightButton)
    }
    
    func bind() {
        viewModel.currentState.receive(on: DispatchQueue.main)
            .sink { [weak self] state in
                switch state {
                case .changeChallengeState(let type, let isSelected):
                    switch type {
                    case .financialTech:
                        self?.challengesView.financialTechView.setStyle(isSelected ? .selected : .unselected)
                    case .moneySaving:
                        self?.challengesView.moneySavingView.setStyle(isSelected ? .selected : .unselected)
                    case .moneyManagement:
                        self?.challengesView.moneyManagementView.setStyle(isSelected ? .selected : .unselected)
                    case .financialLearning:
                        self?.challengesView.financialLearningView.setStyle(isSelected ? .selected : .unselected)
                    }
                case .none:
                    break
                }
            }
            .store(in: &cancellables)
    }
    
    func setTapGesture() {
        challengesView.financialTechView.addTapGesture(self, action: #selector(didTapFinancialTech))
        challengesView.moneySavingView.addTapGesture(self, action: #selector(didTapMoneySaving))
        challengesView.moneyManagementView.addTapGesture(self, action: #selector(didTapMoneyManagement))
        challengesView.financialLearningView.addTapGesture(self, action: #selector(didTapFinancialLearning))
    }
    
}

private extension ChallengeSelectionViewController {
    
    @objc func didTapFinancialTech(_ sender: Any?) {
        viewModel.didSelectChallenge(.financialTech)
    }
    
    @objc func didTapMoneySaving(_ sender: Any?) {
        viewModel.didSelectChallenge(.moneySaving)
    }
    
    @objc func didTapMoneyManagement(_ sender: Any?) {
        viewModel.didSelectChallenge(.moneyManagement)
    }
    
    @objc func didTapFinancialLearning(_ sender: Any?) {
        viewModel.didSelectChallenge(.financialLearning)
    }
    
    @objc func didTapCompletion(_ sender: Any?) {
        
    }
    
}

#if DEBUG
import SwiftUI

@available(iOS 13.0, *)
struct KeywordViewController_Preview: PreviewProvider {
    static var devices = ["iPhone 12", "iPhone SE", "iPhone 11 Pro Max"]

    static var previews: some View {
        ForEach(devices, id: \.self) { deviceName in
            ChallengeSelectionViewController()
                .toPreview()
                .previewDevice(PreviewDevice(rawValue: deviceName))
                .previewDisplayName(deviceName)
        }
    }
}
#endif

