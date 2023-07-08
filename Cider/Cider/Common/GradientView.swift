//
//  GradientView.swift
//  Cider
//
//  Created by 임영선 on 2023/07/08.
//

import UIKit

final class GradientView: UIView {
    
    var type: ChallengeType = .financialTech
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    init(type: ChallengeType) {
        super.init(frame: .zero)
        self.type = type
        layoutSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override class var layerClass: AnyClass {
        return CAGradientLayer.self
    }
    
    override func layoutSubviews() {
        switch type {
        case .financialTech:
            (layer as? CAGradientLayer)?.colors = [UIColor(red: 0.21, green: 0.87, blue: 0.79, alpha: 1).cgColor, UIColor(red: 0.29, green: 0.9, blue: 0.84, alpha: 1).cgColor, UIColor(red: 0.38, green: 0.94, blue: 0.83, alpha: 1).cgColor]
            (layer as? CAGradientLayer)?.locations = [0.00, 0.33, 0.97]
        case .moneySaving:
            (layer as? CAGradientLayer)?.colors = [UIColor(red: 0.95, green: 0.57, blue: 0.77, alpha: 1).cgColor, UIColor(red: 0.96, green: 0.65, blue: 0.85, alpha: 1).cgColor, UIColor(red: 0.98, green: 0.7, blue: 0.84, alpha: 1).cgColor ]
            (layer as? CAGradientLayer)?.locations = [0.18, 0.85, 1.00]
        case .moneyManagement:
            (layer as? CAGradientLayer)?.colors = [UIColor(red: 1, green: 0.75, blue: 0, alpha: 1).cgColor, UIColor(red: 1, green: 0.79, blue: 0.2, alpha: 1).cgColor, UIColor(red: 0.95, green: 0.87, blue: 0.41, alpha: 1).cgColor]
            (layer as? CAGradientLayer)?.locations = [0.18, 0.85, 1.00]
        case .financialLearning:
            (layer as? CAGradientLayer)?.colors = [UIColor(red: 0, green: 0.61, blue: 1, alpha: 1).cgColor, UIColor(red: 0.2, green: 0.69, blue: 1, alpha: 1).cgColor, UIColor(red: 0.31, green: 0.73, blue: 1, alpha: 1).cgColor]
            (layer as? CAGradientLayer)?.locations = [0.18, 0.85, 1.00]
        }
        (layer as? CAGradientLayer)?.startPoint = CGPoint(x: 0.9, y: 1.0)
        (layer as? CAGradientLayer)?.endPoint = CGPoint(x: 0.0, y: 0.0)
    }

}
