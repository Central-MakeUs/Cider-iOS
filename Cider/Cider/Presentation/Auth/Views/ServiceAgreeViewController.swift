//
//  ServiceAgreeViewController.swift
//  Cider
//
//  Created by 임영선 on 2023/06/29.
//

import UIKit
import Combine

class ServiceAgreeViewController: UIViewController {
    
    private let viewModel: ServiceAgreeViewModel
    private var cancellables = Set<AnyCancellable>()
    
    private let processView = ProcessView()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.register(ServiceAgreeCell.self, forCellReuseIdentifier: ServiceAgreeCell.identifier)
        tableView.register(ServiceAgreeDetailCell.self, forCellReuseIdentifier: ServiceAgreeDetailCell.identifier)
        tableView.register(ServiceAgreeHeaderView.self, forHeaderFooterViewReuseIdentifier: ServiceAgreeHeaderView.identifier)
        tableView.backgroundColor = .white
        tableView.showsVerticalScrollIndicator = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorInset.left = 0
        tableView.separatorColor = .custom.gray2
        tableView.sectionFooterHeight = 0
        return tableView
    }()
    
    private lazy var confirmButton: CiderBottomButton = {
        let button = CiderBottomButton(style: .disabled, title: "확인했어요")
        button.addTarget(self, action: #selector(didTapConfirm), for: .touchUpInside)
        return button
    }()
    
    private var cellData = [
        ServiceAgreeCellData(mainTitle: "만 14세 이상입니다(필수)"),
        ServiceAgreeCellData(mainTitle: "서비스 이용 약관(필수)", subTitle: "자세히 보기", detailText: """
        개인정보 처리
        개인정보 처리
        개인정보 처리
        개인정보
                서비스 이용 약관(필수)
        개인정보 처리
        개인정보 처리
        개인정보 처리
        개인정보 처리
                서비스 이용 약관(필수)
        개인정보 처리
        개인정보 처리서비스 이용 약관(필수)
        개인정보 처리
        개인정보 처리
                서비스 이용 약관(필수)서비스 이용 약관(필수)서비스 이용 약관(필수)서비스 이용 약관(필수)
        개인정보 처리
        개인정보 처리
        개인정보 처리 개인정보 처리 방침(필수)개인정보 처리 방침(필수)개인정보 처리 방침(필수)개인정보 처리 방침(필수)개인정보 처리 방침(필수)개인정보 처리 방침(필수)개인정보 처리 방침(필수)개인정보 처리 방침(필수)
        """),
        ServiceAgreeCellData(mainTitle: "개인정보 처리 방침(필수)",  subTitle: "자세히 보기", detailText: """
        개인정보 처리
        개인정보 처리
        개인정보 처리
        """),
        ServiceAgreeCellData(mainTitle: "약관 전체 동의", subTitle: "전체 약관에 동의합니다")
    ]
    
    private var selectedStates = [false, false, false, false]
    
    init(viewModel: ServiceAgreeViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        bind()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNavigationBar()
    }
    
}

private extension ServiceAgreeViewController {
    
    func configure() {
        view.backgroundColor = .white
        view.addSubviews(processView, tableView, confirmButton)
        NSLayoutConstraint.activate([
            processView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            processView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            processView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.topAnchor.constraint(equalTo: processView.bottomAnchor, constant: 24),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            tableView.bottomAnchor.constraint(equalTo: confirmButton.topAnchor, constant: -16),
            confirmButton.leadingAnchor.constraint(equalTo: tableView.leadingAnchor),
            confirmButton.trailingAnchor.constraint(equalTo: tableView.trailingAnchor),
            confirmButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20)
            
        ])
        processView.setProcessType(.serviceAgree)
    }
    
    func setNavigationBar() {
        self.navigationController?.navigationBar.topItem?.title = ""
        self.navigationItem.title = "회원가입"
    }
    
    func bind() {
        viewModel.state.receive(on: DispatchQueue.main)
            .sink { [weak self] state in
                switch state {
                case .changeCheckboxState(let selectedStates):
                    self?.selectedStates = selectedStates
                    self?.tableView.reloadData()
                case .changeNextButtonState(let isEnabled):
                    self?.confirmButton.setStyle(isEnabled == true ? .enabled : .disabled)
                }
            }
            .store(in: &cancellables)
    }
    
}

private extension ServiceAgreeViewController {
    
    @objc func didTapConfirm(_ sender: Any?) {
        let viewController = NicknameViewController()
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    @objc func didTapCheckbox(_ sender: UIButton) {
        viewModel.didSelectedAgreement(index: sender.tag)
        
    }
    
}

extension ServiceAgreeViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if cellData[section].opened == true {
            return 2
        } else {
            return 1
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return cellData.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ServiceAgreeCell.identifier) as? ServiceAgreeCell else {
                return UITableViewCell()
            }
            cell.setUp(mainText: cellData[indexPath.section].mainTitle, subTitle: cellData[indexPath.section].subTitle)
            cell.addTagCheckbox(indexPath.section)
            cell.addTargetAction(self, action: #selector(didTapCheckbox))
            cell.setCheckboxState(selectedStates[indexPath.section] == false ? .unselected : .selected)
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ServiceAgreeDetailCell.identifier) as? ServiceAgreeDetailCell else {
                return UITableViewCell()
            }
            guard let detailText = cellData[indexPath.section].detailText else {
                return cell
            }
            cell.setUp(detailText)
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if (indexPath.section == 1 || indexPath.section == 2) && indexPath.row == 0 {
            cellData[indexPath.section].subTitle = cellData[indexPath.section].subTitle == "접기" ? "자세히 보기" : "접기"
            cellData[indexPath.section].opened.toggle()
           // tableView.reloadData()
            tableView.reloadSections(IndexSet(integer: indexPath.section), with: .fade)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 1 {
            return 312
        } else {
            return 48
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case 0:
            if cellData.filter({ $0.opened == true }).count > 0 {
                return 0
            } else {
                return (UIScreen.main.bounds.height)*0.4
            }
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            guard let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: ServiceAgreeHeaderView.identifier) as? ServiceAgreeHeaderView else {
                return nil
            }
            return headerView
        }
        return nil
    }
    
}


#if DEBUG
import SwiftUI

@available(iOS 13.0, *)
struct ServiceAgreeViewController_Preview: PreviewProvider {
    static var devices = ["iPhone 12", "iPhone SE", "iPhone 11 Pro Max"]

    static var previews: some View {
        ForEach(devices, id: \.self) { deviceName in
            ServiceAgreeViewController(viewModel: ServiceAgreeViewModel())
                .toPreview()
                .previewDevice(PreviewDevice(rawValue: deviceName))
                .previewDisplayName(deviceName)
        }
    }
}
#endif

