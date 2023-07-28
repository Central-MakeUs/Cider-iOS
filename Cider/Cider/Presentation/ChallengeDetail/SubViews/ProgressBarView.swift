//
//  ProgressBarView.swift
//  Cider
//
//  Created by 임영선 on 2023/07/28.
//

import UIKit

enum ProgressBarType {
    case averageProgress
    case myProgress
    
    var mainColor: UIColor? {
        switch self {
        case .averageProgress:
            return .custom.main
        case .myProgress:
            return .custom.secondary
        }
    }
    
    var backgroundColor: UIColor? {
        switch self {
        case .averageProgress:
            return .custom.lightBlue
        case .myProgress:
            return .custom.gray1
        }
    }
    
    var statusText: String {
        switch self {
        case .averageProgress:
            return "평균 현황"
        case .myProgress:
            return "나의 현황"
        }
    }
    
}

final class ProgressBarView: UIView {
    
    let progressWidth = UIScreen.main.bounds.width - 48 - 8 - 53
    
    private lazy var progressView: UIProgressView = {
        let progressView = UIProgressView()
        progressView.trackTintColor = .custom.gray4
        progressView.progress = 0
        return progressView
    }()
    
    private lazy var percentLabel: UILabel = {
        let label = UILabel()
        label.font = CustomFont.PretendardBold(size: .sm).font
        label.textColor = .white
        label.heightAnchor.constraint(equalToConstant: 21).isActive = true
        label.widthAnchor.constraint(equalToConstant: 37).isActive = true
        label.clipsToBounds = true
        label.layer.cornerRadius = 4
        label.textAlignment = .center
        return label
    }()
    
    private lazy var statusLabel: UILabel = {
        let label = UILabel()
        label.font = CustomFont.PretendardBold(size: .sm).font
        label.heightAnchor.constraint(equalToConstant: 21).isActive = true
        label.widthAnchor.constraint(equalToConstant: 53).isActive = true
        label.clipsToBounds = true
        label.layer.cornerRadius = 4
        label.textAlignment = .center
        return label
    }()
    
    init() {
        super.init(frame: .zero)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        addSubviews(progressView, percentLabel, statusLabel)
        NSLayoutConstraint.activate([
            progressView.centerYAnchor.constraint(equalTo: centerYAnchor),
            progressView.leadingAnchor.constraint(equalTo: leadingAnchor),
            progressView.widthAnchor.constraint(equalToConstant: progressWidth),
            progressView.heightAnchor.constraint(equalToConstant: 6),
            statusLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            statusLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            percentLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
        
    }
    
}

extension ProgressBarView {
    
    func setUp(_ type: ProgressBarType, percent: Float) {
        progressView.progressTintColor = type.mainColor
        percentLabel.backgroundColor = percent < 0.1 ? .custom.gray4 : type.mainColor
        percentLabel.text = "\(Int(percent*100))%"
        statusLabel.textColor = type.mainColor
        statusLabel.backgroundColor = type.backgroundColor
        statusLabel.text = type.statusText
        
        var progressXPoint: CGFloat {
            switch percent {
            case 0..<0.1:
                return 0
                
            case 0.9...1:
                return self.progressWidth*CGFloat(percent) - 37
                
            default:
                return self.progressWidth*CGFloat(percent) - 37/2
            }
        }
        
        self.percentLabel.leadingAnchor.constraint(
            equalTo: self.leadingAnchor,
            constant: progressXPoint
        ).isActive = true
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+0.2) {
            self.progressView.setProgress(percent, animated: true)
        }
    }
    
}



#if DEBUG
import SwiftUI

@available(iOS 13.0, *)
struct ProgressBarView_Preview: PreviewProvider {
    static var previews: some View {
        
        UIViewPreview {
            let view = ProgressBarView()
            view.setUp(.myProgress, percent: 0.1)
            
            return view
        }
        .previewLayout(.fixed(width: 150, height: 192))
        //.padding(100)
    }
}
#endif
