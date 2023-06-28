//
//  UILabel+Extension.swift
//  Cider
//
//  Created by 임영선 on 2023/06/28.
//

import UIKit

public extension UILabel {
    
    func editTextColor(of prefix: String, in color: UIColor) {
        guard let text = text else {
            return
        }
        let attributedString = NSMutableAttributedString(string: text)
        let range = (text as NSString).range(of: prefix)
        attributedString.addAttribute(.foregroundColor, value: color, range: range)
        attributedText = attributedString
    }
    
    func setTextWithLineHeight(lineHeight: CGFloat) {
        let style = NSMutableParagraphStyle()
        style.maximumLineHeight = lineHeight
        style.minimumLineHeight = lineHeight
        let attributes: [NSAttributedString.Key: Any] = [
            .paragraphStyle: style,
            .baselineOffset: (lineHeight - font.lineHeight) / 4
        ]
        let attrString = NSAttributedString(
            string: text ?? "",
            attributes: attributes
        )
        self.attributedText = attrString
    }
    
}
