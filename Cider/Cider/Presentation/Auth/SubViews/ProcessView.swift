//
//  ProcessView.swift
//  Cider
//
//  Created by 임영선 on 2023/06/29.
//

import UIKit

final class ProcessView: UIStackView {
    
    private lazy var serviceAgreeLabel: UILabel = {
        let label = UILabel()
        label.text = "서비스 동의"
        label.textAlignment = .center
        label.font = CustomFont.PretendardRegular(size: .lg).font
        label.textColor = .custom.gray5
        label.widthAnchor.constraint(equalToConstant: 81).isActive = true
        label.heightAnchor.constraint(equalToConstant: 20).isActive = true
        return label
    }()
    
    
    private lazy var dataInputLabel: UILabel = {
        let label = UILabel()
        label.text = "정보 입력"
        label.textAlignment = .center
        label.font = CustomFont.PretendardRegular(size: .lg).font
        label.textColor = .custom.gray5
        label.widthAnchor.constraint(equalToConstant: 81).isActive = true
        label.heightAnchor.constraint(equalToConstant: 20).isActive = true
        return label
    }()
    
    private lazy var keywordRecommendationLabel: UILabel = {
        let label = UILabel()
        label.text = "키워드 추천"
        label.textAlignment = .center
        label.font = CustomFont.PretendardRegular(size: .lg).font
        label.textColor = .custom.gray5
        label.widthAnchor.constraint(equalToConstant: 81).isActive = true
        label.heightAnchor.constraint(equalToConstant: 20).isActive = true
        return label
    }()
    
    private lazy var barView1: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.custom.gray2
        view.heightAnchor.constraint(equalToConstant: 1).isActive = true
        view.widthAnchor.constraint(equalToConstant: 312).isActive = true
        return view
    }()
    
    private lazy var barView2: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.custom.gray2
        view.heightAnchor.constraint(equalToConstant: 1).isActive = true
        view.widthAnchor.constraint(equalToConstant: 312).isActive = true
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        self.axis = .horizontal
        self.distribution = .equalCentering
        self.alignment = .center
        self.addArrangedSubviews(serviceAgreeLabel, barView1, dataInputLabel, barView2, keywordRecommendationLabel)
        NSLayoutConstraint.activate([
            self.heightAnchor.constraint(equalToConstant: 20)
        ])
    }
   
}


extension ProcessView {
    
    func setProcessType(_ processType: ProcessType) {
        switch processType {
        case .serviceAgree:
            serviceAgreeLabel.textColor = .custom.main
            serviceAgreeLabel.layer.borderColor = UIColor.custom.main?.cgColor
            serviceAgreeLabel.layer.borderWidth = 0.5
            serviceAgreeLabel.layer.cornerRadius = 8
            serviceAgreeLabel.backgroundColor = .custom.lightBlue
            
        case .dataInput:
            dataInputLabel.textColor = .custom.main
            dataInputLabel.layer.borderColor = UIColor.custom.main?.cgColor
            dataInputLabel.layer.borderWidth = 0.5
            dataInputLabel.layer.cornerRadius = 8
            dataInputLabel.backgroundColor = .custom.lightBlue
           
        case .keywordRecommendation:
            keywordRecommendationLabel.textColor = .custom.main
            keywordRecommendationLabel.layer.borderColor = UIColor.custom.main?.cgColor
            keywordRecommendationLabel.layer.borderWidth = 0.5
            keywordRecommendationLabel.layer.cornerRadius = 8
            keywordRecommendationLabel.backgroundColor = .custom.lightBlue
           
        }
    }
    
}
