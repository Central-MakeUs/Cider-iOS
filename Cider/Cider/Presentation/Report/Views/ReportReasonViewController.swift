//
//  ReportReasonViewController.swift
//  Cider
//
//  Created by 임영선 on 2023/08/18.
//

import UIKit

final class ReportReasonViewController: UIViewController {
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = CustomFont.PretendardBold(size: .lg).font
        label.textColor = .black
        label.text = "작성자 신고 사유 선택"
        return label
    }()
    
    private lazy var selectButton: UIButton = {
        let button = UIButton()
        button.setTitle("선택", for: .normal)
        button.titleLabel?.font = CustomFont.PretendardBold(size: .lg).font
        button.setTitleColor(.custom.gray5, for: .normal)
        button.isEnabled = false
        return button
    }()
    
    private lazy var reasonView1: ReportReasonView = {
        let view = ReportReasonView(reason: "올바르지 않은 인증 내용 및 사진", style: .unselected)
        view.tag = 0
        return view
    }()
    private lazy var reasonView2: ReportReasonView = {
        let view = ReportReasonView(reason: "상업적 광고 및 판매", style: .unselected)
        view.tag = 1
        return view
    }()
    
    private lazy var reasonView3: ReportReasonView = {
        let view = ReportReasonView(reason: "중복 및 도배성 글", style: .unselected)
        view.tag = 2
        return view
    }()
    
    private lazy var reasonView4: ReportReasonView = {
        let view = ReportReasonView(reason: "욕설 및 외설적인 언어 사용", style: .unselected)
        view.tag = 3
        return view
    }()
    
    private lazy var reasonView5: ReportReasonView = {
        let view = ReportReasonView(reason: "명예 훼손 및 타인 비방", style: .unselected)
        view.tag = 4
        return view
    }()
    
    private lazy var reasonView6: ReportReasonView = {
        let view = ReportReasonView(reason: "정치 종교 목적의 게시글", style: .unselected)
        view.tag = 5
        return view
    }()
    
    private lazy var reasonView7: ReportReasonView = {
        let view = ReportReasonView(reason: "게시판 성격에 부적절함", style: .unselected)
        view.setUnderbarHidden()
        view.tag = 6
        return view
    }()
    
    private lazy var reasonStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.addArrangedSubviews(reasonView1, reasonView2, reasonView3, reasonView4, reasonView5,
        reasonView6, reasonView7)
        return stackView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    


}

private extension ReportReasonViewController {
    
    func setUp() {
        configure()
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
    
}
