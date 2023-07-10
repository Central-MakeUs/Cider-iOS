//
//  ServiceAgreeDetailCell.swift
//  Cider
//
//  Created by 임영선 on 2023/06/29.
//

import UIKit

final class ServiceAgreeDetailCell: UITableViewCell {
    
    static let identifier = "ServiceAgreeDetailCell"

    private lazy var textView: UITextView = {
        let textView = UITextView()
        textView.font = CustomFont.PretendardRegular(size: .base).font
        textView.textColor = .custom.gray5
        textView.backgroundColor = .custom.gray1
        textView.isEditable = true
        textView.showsVerticalScrollIndicator = true
        textView.textAlignment = .left
        textView.isScrollEnabled = true
        textView.isUserInteractionEnabled = true
        return textView
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
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

private extension ServiceAgreeDetailCell {
    func confiure() {
        selectionStyle = .none
        backgroundColor = .white
        contentView.addSubviews(textView)
        NSLayoutConstraint.activate([
            textView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            textView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            textView.topAnchor.constraint(equalTo: topAnchor),
            textView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}

extension ServiceAgreeDetailCell {
    func setUp(_ text: String) {
        textView.text = text
    }
}
