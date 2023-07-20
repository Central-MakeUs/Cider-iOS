//
//  PrecautionView.swift
//  Cider
//
//  Created by 임영선 on 2023/07/20.
//

import UIKit

final class PrecautionView: UIView {
    
    private let title: String
    
    private lazy var mainTitleLabel: UILabel = {
        let label = UILabel()
        label.font = CustomFont.PretendardBold(size: .lg).font
        label.textColor = .custom.text
        label.text = title
        return label
    }()
    
    private lazy var checkButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "checkboxUnselected"), for: .normal)
        button.setImage(UIImage(named: "checkboxSelected"), for: .selected)
        return button
    }()

    init(title: String) {
        self.title = title
        super.init(frame: .zero)
        confiure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addCheckboxAction(_ target: Any?, action: Selector) {
        checkButton.addTarget(target, action: action, for: .touchUpInside)
    }
    
    func setButtonTag(_ index: Int) {
        checkButton.tag = index
    }
    
}

private extension PrecautionView {
    
    func confiure() {
        addSubviews(mainTitleLabel, checkButton)
        NSLayoutConstraint.activate([
            checkButton.leadingAnchor.constraint(equalTo: leadingAnchor),
            checkButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            mainTitleLabel.leadingAnchor.constraint(equalTo: checkButton.trailingAnchor, constant: 8),
            mainTitleLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
        ])
    }
    
}
