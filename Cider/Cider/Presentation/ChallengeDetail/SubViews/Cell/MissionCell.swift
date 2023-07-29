//
//  MissionCell.swift
//  Cider
//
//  Created by 임영선 on 2023/07/28.
//

import UIKit

final class MissionCell: UICollectionViewCell {
    
    private lazy var missionInfoLabel: DynamicLabel = {
        let label = DynamicLabel(horizontalPadding: 0, verticalPadding: 8)
        label.backgroundColor = UIColor(red: 0.13, green: 0.15, blue: 0.16, alpha: 1)
        return label
    }()
    
}
