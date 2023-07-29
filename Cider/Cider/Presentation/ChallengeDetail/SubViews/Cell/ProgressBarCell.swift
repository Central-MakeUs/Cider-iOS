//
//  ProgressBarCell.swift
//  Cider
//
//  Created by 임영선 on 2023/07/28.
//

import UIKit

final class ProgressBarCell: UICollectionViewCell {
    
    static let identifier = "ProgressBarCell"
    
    private let averageProgressView = ProgressBarView()
    private let myProgressView = ProgressBarView()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(axis: .vertical, alignment: .fill, distribution: .fillEqually, spacing: 16)
        return stackView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

extension ProgressBarCell {
    
    func setUp(
        averagePercent: Float,
        myPercent: Float?
    ) {
        self.backgroundColor = .white
        if let myPercent {
            stackView.addArrangedSubviews(averageProgressView, myProgressView)
            averageProgressView.setUp(.averageProgress, percent: averagePercent)
            myProgressView.setUp(.myProgress, percent: myPercent)
        } else {
            stackView.addArrangedSubviews(averageProgressView)
            averageProgressView.setUp(.averageProgress, percent: averagePercent)
        }
        addSubviews(stackView)
        NSLayoutConstraint.activate([
            averageProgressView.heightAnchor.constraint(equalToConstant: 21),
            averageProgressView.heightAnchor.constraint(equalToConstant: 21),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16)
        ])
    }
    
}

#if DEBUG
import SwiftUI

@available(iOS 13.0, *)
struct ProgressBarCell_Preview: PreviewProvider {
    static var previews: some View {
        
        UIViewPreview {
            let cell = ProgressBarCell()
            cell.setUp(averagePercent: 0.5, myPercent: nil)
            return cell
        }
        .previewLayout(.fixed(width: 150, height: 192))
        .padding(50)
    }
}
#endif
