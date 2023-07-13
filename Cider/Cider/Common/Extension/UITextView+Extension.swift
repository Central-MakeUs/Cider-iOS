//
//  UITextView+Extension.swift
//  Cider
//
//  Created by 임영선 on 2023/07/13.
//

import UIKit

extension UITextView {
    
    func setTextWithLineHeight(lineHeight: CGFloat) {
        let style = NSMutableParagraphStyle()
        style.lineSpacing = lineHeight
        let attributedString = NSMutableAttributedString(string: text)
        attributedString.addAttribute(NSAttributedString.Key.kern, value: CGFloat(0), range: NSRange(location: 0, length: attributedString.length))
        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value: style, range: NSRange(location: 0, length: attributedString.length))
        self.attributedText = attributedString
    }
    
}
