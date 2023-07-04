//
//  Font.swift
//  Cider
//
//  Created by 임영선 on 2023/06/28.
//

import UIKit

enum FontSize: Int {
    case xl5 = 28
    case xl4 = 24
    case xl3 = 20
    case xl2 = 18
    case xl = 16
    case lg = 14
    case base = 13
    case sm = 12
    case xs = 10
}

enum CustomFont {

    case PretendardBold(size: FontSize)
    case PretendardMedium(size: FontSize)
    case PretendardRegular(size: FontSize)
    
    var font: UIFont? {
        switch self {
        case .PretendardBold(let size):
            return UIFont(name: "Pretendard-Bold", size: CGFloat(size.rawValue))
        case .PretendardMedium(let size):
            return UIFont(name: "Pretendard-Medium", size: CGFloat(size.rawValue))
        case .PretendardRegular(let size):
            return UIFont(name: "Pretendard-Regular", size: CGFloat(size.rawValue))
        }
    }
    
}
