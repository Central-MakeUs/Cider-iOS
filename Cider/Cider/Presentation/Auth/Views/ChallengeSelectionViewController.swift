//
//  KeywordViewController.swift
//  Cider
//
//  Created by 임영선 on 2023/07/07.
//

import UIKit
import Combine

final class ChallengeSelectionViewController: UIViewController {

    private let viewModel = KeywordViewModel()
    private var cancellables = Set<AnyCancellable>()
    
    private let processView = ProcessView()
    
    private lazy var mainTitleLabel: UILabel = {
        let label = UILabel()
        label.font = CustomFont.PretendardBold(size: .xl5).font
        label.text = "관심 챌린지와 키워드를\n모두 선택해주세요"
        label.textColor = .custom.text
        label.setTextWithLineHeight(lineHeight: 39.2)
        label.numberOfLines = 0
        return label
    }()
    
    private let challengesView = ChallengesView()
    private let keywordsView = KeywordsView()
    
    private lazy var barView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.custom.gray1
        view.heightAnchor.constraint(equalToConstant: 2).isActive = true
        return view
    }()
    
    private lazy var completionButton: CiderBottomButton = {
        let button = CiderBottomButton(style: .disabled, title: "완료")
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
        view.addSubviews(processView, mainTitleLabel, challengesView, keywordsView, barView, completionButton)
        
        NSLayoutConstraint.activate([
            processView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            processView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            processView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            mainTitleLabel.topAnchor.constraint(equalTo: processView.bottomAnchor, constant: 24),
            mainTitleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            challengesView.topAnchor.constraint(equalTo: mainTitleLabel.bottomAnchor, constant: 36),
            challengesView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            challengesView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            challengesView.heightAnchor.constraint(equalToConstant: 200),
            barView.leadingAnchor.constraint(equalTo: mainTitleLabel.leadingAnchor),
            barView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            barView.topAnchor.constraint(equalTo: challengesView.bottomAnchor, constant: 23),
            keywordsView.leadingAnchor.constraint(equalTo: challengesView.leadingAnchor),
            keywordsView.trailingAnchor.constraint(equalTo: challengesView.trailingAnchor),
            keywordsView.heightAnchor.constraint(equalToConstant: 128),
            keywordsView.topAnchor.constraint(equalTo: barView.bottomAnchor, constant: 12),
            completionButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            completionButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            completionButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20)
        ])
    }
    
    func setNavigationBar() {
        self.navigationController?.navigationBar.topItem?.title = ""
        self.navigationItem.title = "회원가입"
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
                case .changeNextButtonState(let isEnabled):
                    self?.completionButton.setStyle(isEnabled == true ? .enabled : .disabled)
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

