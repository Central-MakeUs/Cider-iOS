//
//  ReportReasonViewController.swift
//  Cider
//
//  Created by 임영선 on 2023/08/18.
//

import UIKit
import Combine

final class ReportReasonViewController: UIViewController {
    
    private let viewModel: ReportReasonViewModel
    private let reportType: ReportType
    private var cancellables: Set<AnyCancellable> = .init()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = CustomFont.PretendardBold(size: .lg).font
        label.textColor = .black
        label.text = reportType.title
        return label
    }()
    
    private lazy var selectButton: UIButton = {
        let button = UIButton()
        button.setTitle("선택", for: .normal)
        button.titleLabel?.font = CustomFont.PretendardBold(size: .lg).font
        button.setTitleColor(.custom.gray5, for: .normal)
        button.isEnabled = false
        button.addTarget(self, action: #selector(didTapSelect), for: .touchUpInside)
        return button
    }()
    
    private lazy var reasonView1: ReportReasonView = {
        let view = ReportReasonView(reason: "올바르지 않은 인증 내용 및 사진", style: .unselected)
        view.tag = 0
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapReason)))
        return view
    }()
    private lazy var reasonView2: ReportReasonView = {
        let view = ReportReasonView(reason: "상업적 광고 및 판매", style: .unselected)
        view.tag = 1
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapReason)))
        return view
    }()
    
    private lazy var reasonView3: ReportReasonView = {
        let view = ReportReasonView(reason: "중복 및 도배성 글", style: .unselected)
        view.tag = 2
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapReason)))
        return view
    }()
    
    private lazy var reasonView4: ReportReasonView = {
        let view = ReportReasonView(reason: "욕설 및 외설적인 언어 사용", style: .unselected)
        view.tag = 3
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapReason)))
        return view
    }()
    
    private lazy var reasonView5: ReportReasonView = {
        let view = ReportReasonView(reason: "명예 훼손 및 타인 비방", style: .unselected)
        view.tag = 4
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapReason)))
        return view
    }()
    
    private lazy var reasonView6: ReportReasonView = {
        let view = ReportReasonView(reason: "정치 종교 목적의 게시글", style: .unselected)
        view.tag = 5
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapReason)))
        return view
    }()
    
    private lazy var reasonView7: ReportReasonView = {
        let view = ReportReasonView(reason: "게시판 성격에 부적절함", style: .unselected)
        view.setUnderbarHidden()
        view.tag = 6
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapReason)))
        return view
    }()
    
    private lazy var reasonViews = [reasonView1, reasonView2, reasonView3, reasonView4, reasonView5,
                               reasonView6, reasonView7]
    
    private lazy var reasonStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.addArrangedSubviews(reasonView1, reasonView2, reasonView3, reasonView4, reasonView5,
        reasonView6, reasonView7)
        return stackView
    }()
    
    init(viewModel: ReportReasonViewModel, reportType: ReportType) {
        self.viewModel = viewModel
        self.reportType = reportType
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
    }

}

private extension ReportReasonViewController {
    
    func setUp() {
        configure()
        bind()
    }
    
    func bind() {
        viewModel.state.receive(on: DispatchQueue.main)
            .sink { [weak self] state in
                switch state {
                case .isEnabledNext(let isEnabled):
                    self?.selectButton.isEnabled = isEnabled
                }
            }
            .store(in: &cancellables)
    }
    
    func configure() {
        view.backgroundColor = .white
        view.addSubviews(reasonStackView,titleLabel, selectButton)
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 30),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            selectButton.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
            selectButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            reasonStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            reasonStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            reasonStackView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            reasonStackView.heightAnchor.constraint(equalToConstant: 336)
        ])
    }
    
    func setStyle(_ selectedIndex: Int) {
        for i in 0..<reasonViews.count {
            reasonViews[i].setStyle(i==selectedIndex ? .selected : .unselected)
        }
    }
    
    func presentReportPopupViewController(_ reportType: ReportType) {
        let viewController = ReportPopupViewController(reportType: reportType)
        viewController.modalTransitionStyle = .crossDissolve
        viewController.modalPresentationStyle = .overFullScreen
        self.present(viewController, animated: true)
    }
    
}

private extension ReportReasonViewController {
    
    @objc func didTapReason(_ sender: UITapGestureRecognizer) {
        guard let tag = sender.view?.tag else {
            return
        }
        setStyle(tag)
        viewModel.selectReason(tag)
    }
    
    @objc func didTapSelect(_ sender: Any?) {
        presentReportPopupViewController(reportType)
    }
    
}
