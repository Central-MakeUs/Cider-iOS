//
//  ReportPopupViewController.swift
//  Cider
//
//  Created by 임영선 on 2023/08/18.
//

import UIKit

final class ReportPopupViewController: UIViewController {
    
    private let reportType: ReportType
    private let viewModel: ReportViewModel

    private lazy var backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 8
        view.addSubviews(mainTitleLabel, subTitleLabel, bottomButton)
        return view
    }()
    
    private lazy var mainTitleLabel: UILabel = {
        let label = UILabel()
        label.font = CustomFont.PretendardBold(size: .xl).font
        label.textColor = .custom.text
        label.text = reportType.popUpMainTitle
        return label
    }()
    
    private lazy var subTitleLabel: UILabel = {
        let label = UILabel()
        label.font = CustomFont.PretendardRegular(size: .base).font
        label.textColor = .custom.text
        label.text = reportType.popUpSubTitle
        label.setTextWithLineHeight(lineHeight: 18.2)
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    private lazy var bottomButton: UIButton = {
        let button = UIButton()
        button.setTitle(reportType.popUpButtonTitle, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .custom.main
        button.titleLabel?.font = CustomFont.PretendardBold(size: .lg).font
        button.layer.cornerRadius = 4
        button.addTarget(self, action: #selector(didTapBottom), for: .touchUpInside)
        return button
    }()
    
    init(reportType: ReportType, viewModel: ReportViewModel) {
        self.reportType = reportType
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

}

private extension ReportPopupViewController {
    
    func setUp() {
        configure()
    }
    
    func configure() {
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissAllViewController)))
        view.backgroundColor = .black.withAlphaComponent(0.6)
        view.addSubviews(backgroundView)
        NSLayoutConstraint.activate([
            backgroundView.heightAnchor.constraint(equalToConstant: 166),
            backgroundView.widthAnchor.constraint(equalToConstant: 256),
            backgroundView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            backgroundView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            mainTitleLabel.centerXAnchor.constraint(equalTo: backgroundView.centerXAnchor),
            mainTitleLabel.topAnchor.constraint(equalTo: backgroundView.topAnchor, constant: 28),
            subTitleLabel.topAnchor.constraint(equalTo: mainTitleLabel.bottomAnchor, constant: 8),
            subTitleLabel.centerXAnchor.constraint(equalTo: backgroundView.centerXAnchor),
            bottomButton.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor, constant: 12),
            bottomButton.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor, constant: -12),
            bottomButton.heightAnchor.constraint(equalToConstant: 44),
            bottomButton.bottomAnchor.constraint(equalTo: backgroundView.bottomAnchor, constant: -12)
        ])
    }
    
    @objc func dismissAllViewController(_ sender: Any?) {
        switch reportType {
        case .postBlock, .userBlock:
            self.presentingViewController?.presentingViewController?.dismiss(animated: true)
        case .postReport, .userReport:
            self.presentingViewController?.presentingViewController?.presentingViewController?.dismiss(animated: true)
        }
    }
    
    @objc func didTapBottom(_ sender: Any?) {
        viewModel.report(reportType)
        switch reportType {
        case .postBlock, .userBlock:
            self.presentingViewController?.presentingViewController?.dismiss(animated: true)
            self.presentingViewController?.presentingViewController?.showToast(message: reportType.toastMessage)
        case .postReport, .userReport:
            self.presentingViewController?.presentingViewController?.presentingViewController?.dismiss(animated: true)
            self.presentingViewController?.presentingViewController?.presentingViewController?.showToast(message: reportType.toastMessage)
        }
        
    }
    
}
