//
//  ServiceAgreeViewController.swift
//  Cider
//
//  Created by 임영선 on 2023/06/29.
//

import UIKit

class ServiceAgreeViewController: UIViewController {
    
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
    
    private lazy var confirmButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .custom.gray4
        button.setTitle("확인했어요", for: .normal)
        button.titleLabel?.font = CustomFont.PretendardBold(size: .xl2).font
        button.setTitleColor(UIColor.white, for: .normal)
        button.heightAnchor.constraint(equalToConstant: 48).isActive = true
        button.layer.cornerRadius = 4
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

    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
}

private extension ServiceAgreeViewController {
    
    func configure() {
        view.backgroundColor = .white
        view.addSubviews(processView, tableView, confirmButton)
        NSLayoutConstraint.activate([
            processView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            processView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            processView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
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
    
}

private extension ServiceAgreeViewController {
    
    @objc func didTapConfirm(_ sender: Any?) {
        let viewController = NicknameViewController()
        self.navigationController?.pushViewController(viewController, animated: true)
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
            cellData[indexPath.section].opened.toggle()
            tableView.reloadData()
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
            ServiceAgreeViewController()
                .toPreview()
                .previewDevice(PreviewDevice(rawValue: deviceName))
                .previewDisplayName(deviceName)
        }
    }
}
#endif

