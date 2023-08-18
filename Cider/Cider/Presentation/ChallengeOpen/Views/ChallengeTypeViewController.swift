//
//  ChallengeTypeViewController.swift
//  Cider
//
//  Created by 임영선 on 2023/07/17.
//

import UIKit

class ChallengeTypeViewController: UIViewController {

    private let mainTitleLabel = MainTitleLabel(title: "개설을 원하는\n챌린지 분야를\n선택해보세요")
    private lazy var challengesView: ChallengesView =  {
        let view = ChallengesView()
        view.financialTechView.addTapGesture(self, action: #selector(didTapFinancialTech))
        view.financialLearningView.addTapGesture(self, action: #selector(didTapFinancialLearning))
        view.moneySavingView.addTapGesture(self, action: #selector(didMoneySaving))
        view.moneyManagementView.addTapGesture(self, action: #selector(didTapMoneyManagement))
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNavigationBar()
    }
    
}

private extension ChallengeTypeViewController {
    
    func setUp() {
        configure()
    }
    
    func configure() {
        view.backgroundColor = .white
        view.addSubviews(mainTitleLabel, challengesView)
        NSLayoutConstraint.activate([
            mainTitleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 52),
            mainTitleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            challengesView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            challengesView.leadingAnchor.constraint(equalTo: mainTitleLabel.leadingAnchor),
            challengesView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            challengesView.heightAnchor.constraint(equalToConstant: 304)
        ])
    }
    
    func setNavigationBar() {
        self.navigationController?.navigationBar.topItem?.title = ""
        self.navigationItem.title = "챌린지 개설"
        setNavigationBar(backgroundColor: .white, tintColor: .black, shadowColor: .clear)
    }
    
    func pushChallengeOpenViewController(_ type: ChallengeType) {
        let viewController = ChallengeOpenViewController(
            challengeType: type,
            viewModel: ChallengeOpenViewModel()
        )
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
}

private extension ChallengeTypeViewController {
    
    @objc func didTapLeftBarButton(_ sender: Any?) {
        self.dismiss(animated: true)
    }
    
    @objc func didTapFinancialTech(_ sender: Any?) {
        pushChallengeOpenViewController(.financialTech)
    }
    
    @objc func didTapFinancialLearning(_ sender: Any?) {
        pushChallengeOpenViewController(.financialLearning)
    }
    
    @objc func didMoneySaving(_ sender: Any?) {
        pushChallengeOpenViewController(.moneySaving)
    }
    
    @objc func didTapMoneyManagement(_ sender: Any?) {
        pushChallengeOpenViewController(.moneyManagement)
    }
    
}
