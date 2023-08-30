//
//  UIImageView+Extension.swift
//  Cider
//
//  Created by 임영선 on 2023/08/08.
//

import UIKit
import Kingfisher

extension UIImageView {
    func load(url: String) {
        guard let url = URL(string: url) else {
            return
        }
        self.kf.indicatorType = .activity
        self.kf.setImage(
          with: url,
          placeholder: nil,
          options: [.transition(.fade(1.2))],
          completionHandler: nil
        )
    }
}
