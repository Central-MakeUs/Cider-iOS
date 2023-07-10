//
//  UITextField+Extension.swift
//  Cider
//
//  Created by 임영선 on 2023/06/29.
//

import UIKit

extension UITextField {
    func addLeftPadding(_ padding: Int) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: padding, height: Int(self.frame.height)))
        self.leftView = paddingView
        self.leftViewMode = ViewMode.always
    }
    
    func setPlaceholderColor(_ placeholderColor: UIColor) {
            attributedPlaceholder = NSAttributedString(
                string: placeholder ?? "",
                attributes: [
                    .foregroundColor: placeholderColor,
                    .font: font
                ].compactMapValues { $0 }
            )
    }
    
    
}
