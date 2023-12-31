//
//  ReportViewController.swift
//  Cider
//
//  Created by 임영선 on 2023/08/18.
//

import UIKit

final class ReportViewController: UIViewController {
    
    private let userId: Int
    private let certifyId: Int

    private lazy var userReportButton: UIButton = {
        let button = UIButton()
        button.setTitle("작성자 신고하기", for: .normal)
        button.titleLabel?.font = CustomFont.PretendardBold(size: .base).font
        button.setTitleColor(.custom.text, for: .normal)
        button.addTarget(self, action: #selector(didTapUserReport), for: .touchUpInside)
        return button
    }()
    
    private lazy var postReportButton: UIButton = {
        let button = UIButton()
        button.setTitle("게시글 신고하기", for: .normal)
        button.titleLabel?.font = CustomFont.PretendardBold(size: .base).font
        button.setTitleColor(.custom.text, for: .normal)
        button.addTarget(self, action: #selector(didTapPostReport), for: .touchUpInside)
        return button
    }()
    
    private lazy var userBlockButton: UIButton = {
        let button = UIButton()
        button.setTitle("작성자 차단하기", for: .normal)
        button.titleLabel?.font = CustomFont.PretendardBold(size: .base).font
        button.setTitleColor(.custom.text, for: .normal)
        button.addTarget(self, action: #selector(didTapUserBlock), for: .touchUpInside)
        return button
    }()
    
    private lazy var postBlockButton: UIButton = {
        let button = UIButton()
        button.setTitle("게시글 차단하기", for: .normal)
        button.titleLabel?.font = CustomFont.PretendardBold(size: .base).font
        button.setTitleColor(.custom.text, for: .normal)
        button.addTarget(self, action: #selector(didTapPostBlock), for: .touchUpInside)
        return button
    }()
    
    private lazy var separtorView1: UIView = {
        let view = UIView()
        view.backgroundColor = .custom.underBar
        return view
    }()
    
    private lazy var separtorView2: UIView = {
        let view = UIView()
        view.backgroundColor = .custom.underBar
        return view
    }()
    
    private lazy var separtorView3: UIView = {
        let view = UIView()
        view.backgroundColor = .custom.underBar
        return view
    }()
    
    init(userId: Int, certifyId: Int) {
        self.userId = userId
        self.certifyId = certifyId
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    private func configure() {
        view.backgroundColor = .white
        view.addSubviews(userReportButton, postReportButton, userBlockButton, postBlockButton, separtorView1, separtorView2, separtorView3)
        NSLayoutConstraint.activate([
            separtorView1.heightAnchor.constraint(equalToConstant: 2),
            separtorView2.heightAnchor.constraint(equalToConstant: 2),
            separtorView3.heightAnchor.constraint(equalToConstant: 2),
            userReportButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 30),
            userReportButton.heightAnchor.constraint(equalToConstant: 48),
            postReportButton.heightAnchor.constraint(equalToConstant: 48),
            userBlockButton.heightAnchor.constraint(equalToConstant: 48),
            postBlockButton.heightAnchor.constraint(equalToConstant: 48),
            userReportButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            userReportButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            separtorView1.leadingAnchor.constraint(equalTo: userReportButton.leadingAnchor),
            separtorView1.trailingAnchor.constraint(equalTo: userReportButton.trailingAnchor),
            separtorView1.topAnchor.constraint(equalTo: userReportButton.bottomAnchor),
            postReportButton.topAnchor.constraint(equalTo: separtorView1.bottomAnchor),
            postReportButton.leadingAnchor.constraint(equalTo: userReportButton.leadingAnchor),
            postReportButton.trailingAnchor.constraint(equalTo: userReportButton.trailingAnchor),
            separtorView2.leadingAnchor.constraint(equalTo: userReportButton.leadingAnchor),
            separtorView2.trailingAnchor.constraint(equalTo: userReportButton.trailingAnchor),
            separtorView2.topAnchor.constraint(equalTo: postReportButton.bottomAnchor),
            userBlockButton.leadingAnchor.constraint(equalTo: userReportButton.leadingAnchor),
            userBlockButton.trailingAnchor.constraint(equalTo: userReportButton.trailingAnchor),
            userBlockButton.topAnchor.constraint(equalTo: separtorView2.bottomAnchor),
            separtorView3.leadingAnchor.constraint(equalTo: userReportButton.leadingAnchor),
            separtorView3.trailingAnchor.constraint(equalTo: userReportButton.trailingAnchor),
            separtorView3.topAnchor.constraint(equalTo: userBlockButton.bottomAnchor),
            postBlockButton.leadingAnchor.constraint(equalTo: userReportButton.leadingAnchor),
            postBlockButton.trailingAnchor.constraint(equalTo: userReportButton.trailingAnchor),
            postBlockButton.topAnchor.constraint(equalTo: separtorView3.bottomAnchor)
        ])
    }
    
}

private extension ReportViewController {
    
    @objc func didTapUserReport(_ sender: Any?) {
        presentReportReasonViewController(.userReport)
    }
    
    @objc func didTapPostReport(_ sender: Any?) {
        presentReportReasonViewController(.postReport)
    }
    
    @objc func didTapUserBlock(_ sender: Any?) {
        presentReportPopupViewController(.userBlock)
    }
    
    @objc func didTapPostBlock(_ sender: Any?) {
        presentReportPopupViewController(.postBlock)
    }
    
    func presentReportReasonViewController(_ reportType: ReportType) {
        let viewController = ReportReasonViewController(
            viewModel: ReportReasonViewModel(),
            reportType: reportType,
            userId: userId,
            certifyId: certifyId
        )
        if let sheet = viewController.sheetPresentationController {
            let identifier = UISheetPresentationController.Detent.Identifier("customMedium")
            let customDetent = UISheetPresentationController.Detent.custom(identifier: identifier) { context in
                return 424-34
            }
            sheet.detents = [customDetent]
            sheet.prefersScrollingExpandsWhenScrolledToEdge = false
            sheet.prefersGrabberVisible = true
        }
        self.present(viewController, animated: true)
    }
    
    func presentReportPopupViewController(_ reportType: ReportType) {
        let viewController = ReportPopupViewController(
            reportType: reportType,
            viewModel: ReportViewModel(
                usecase: DefaultReportUsecase(
                    repository: DefaultReportRepository()
                ), userId: userId,
                certifyId: certifyId,
                reason: nil
            )
        )
        viewController.modalTransitionStyle = .crossDissolve
        viewController.modalPresentationStyle = .overFullScreen
        self.present(viewController, animated: true)
    }
    
}
