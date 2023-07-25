//
//  BannerCell.swift
//  Cider
//
//  Created by 임영선 on 2023/07/21.
//

import UIKit

final class BannerCell: UICollectionViewCell {
    
   static let identifier = "BannerCell"
   let ciderInfoView = CiderInfoView()
    
    private func configure(_ index: Int) {
        switch index {
        case 0:
            addSubviews(ciderInfoView)
            NSLayoutConstraint.activate([
                ciderInfoView.leadingAnchor.constraint(equalTo: leadingAnchor),
                ciderInfoView.trailingAnchor.constraint(equalTo: trailingAnchor),
                ciderInfoView.topAnchor.constraint(equalTo: topAnchor),
                ciderInfoView.bottomAnchor.constraint(equalTo: bottomAnchor)
            ])
        default:
            break
        }
    }
    
}

extension BannerCell {
    
    func setUp(_ index: Int) {
        configure(index)
    }
    
}
