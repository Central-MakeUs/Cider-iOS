//
//  ServiceAgreeCell.swift
//  Cider
//
//  Created by 임영선 on 2023/06/29.
//

import UIKit

final class ServiceAgreeCell: UITableViewCell {
    
    static let identifier = "ServiceAgreeCell"
    
    private lazy var mainTitleLabel: UILabel = {
        let label = UILabel()
        label.font = CustomFont.PretendardBold(size: .lg).font
        label.textColor = .custom.text
        return label
    }()
    
    private lazy var subTitleLabel: UILabel = {
        let label = UILabel()
        label.font = CustomFont.PretendardBold(size: .lg).font
        label.textColor = .custom.gray5
        return label
    }()
    
    private lazy var checkButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "checkboxUnselected"), for: .normal)
        button.setImage(UIImage(named: "checkboxSelected"), for: .selected)
        return button
    }()

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        mainTitleLabel.text = ""
        subTitleLabel.text = ""
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        confiure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}

private extension ServiceAgreeCell {
    
    func confiure() {
        selectionStyle = .none
        contentView.addSubviews(mainTitleLabel, subTitleLabel, checkButton)
        NSLayoutConstraint.activate([
            checkButton.leadingAnchor.constraint(equalTo: leadingAnchor),
            checkButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            mainTitleLabel.leadingAnchor.constraint(equalTo: checkButton.trailingAnchor, constant: 8),
            mainTitleLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            subTitleLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            subTitleLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
}

extension ServiceAgreeCell {
    
    func setUp(mainText: String, subTitle: String?) {
        mainTitleLabel.text = mainText
        if let subTitle {
            subTitleLabel.text = subTitle
        }
    }
    
    func addTargetAction(_ target: Any?, action: Selector) {
        checkButton.addTarget(target, action: action, for: .touchUpInside)
    }
    
    func setCheckboxState(_ style: CiderSelectionStyle) {
        checkButton.isSelected = style == .selected ? true : false
    }
    
    func addTagCheckbox(_ index: Int) {
        checkButton.tag = index
    }
    
}
