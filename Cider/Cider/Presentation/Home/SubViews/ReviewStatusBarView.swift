//
//  ReviewStatusView.swift
//  Cider
//
//  Created by 임영선 on 2023/07/26.
//

import UIKit

enum ReviewStyle {
    case none
    case done
    case success
}

final class ReviewStatusBarView: UIView {
    
    private let reviewingView = ReviewStatusView(style: .done, title: "심사중")
    private let failReviewView = ReviewStatusView(style: .done, title: "반려/실패")
    private let successReviewView = ReviewStatusView(style: .done, title: "심사완료")
    
    private lazy var separatorView1: UIView = {
        let view = UIView()
        view.backgroundColor = .custom.gray4
        view.heightAnchor.constraint(equalToConstant: 1).isActive = true
        return view
    }()
    
    private lazy var separatorView2: UIView = {
        let view = UIView()
        view.backgroundColor = .custom.gray4
        view.heightAnchor.constraint(equalToConstant: 1).isActive = true
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        addSubviews(reviewingView, failReviewView, successReviewView, separatorView1, separatorView2)
        NSLayoutConstraint.activate([
            reviewingView.leadingAnchor.constraint(equalTo: leadingAnchor),
            reviewingView.centerYAnchor.constraint(equalTo: centerYAnchor),
            failReviewView.centerYAnchor.constraint(equalTo: centerYAnchor),
            failReviewView.centerXAnchor.constraint(equalTo: centerXAnchor),
            successReviewView.trailingAnchor.constraint(equalTo: trailingAnchor),
            successReviewView.centerYAnchor.constraint(equalTo: centerYAnchor),
            separatorView1.leadingAnchor.constraint(equalTo: reviewingView.trailingAnchor),
            separatorView1.trailingAnchor.constraint(equalTo: failReviewView.leadingAnchor),
            separatorView1.centerYAnchor.constraint(equalTo: centerYAnchor),
            separatorView2.leadingAnchor.constraint(equalTo: failReviewView.trailingAnchor),
            separatorView2.trailingAnchor.constraint(equalTo: successReviewView.leadingAnchor),
            separatorView2.centerYAnchor.constraint(equalTo: centerYAnchor),
        ])
    }
    
    func setReviewStyle(_ type: ReviewType) {
        switch type {
        case .reviewing:
            reviewingView.setStyle(.success)
            failReviewView.setStyle(.none)
            successReviewView.setStyle(.none)
            
        case .failReview:
            reviewingView.setStyle(.done)
            failReviewView.setStyle(.success)
            successReviewView.setStyle(.none)
            
        case .successReview:
            reviewingView.setStyle(.done)
            failReviewView.setStyle(.done)
            successReviewView.setStyle(.success)
        }
    }

}


final class ReviewStatusView: UIView {
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    init(style: ReviewStyle, title: String) {
        super.init(frame: .zero)
        cofigure()
        setStyle(style)
        titleLabel.text = title
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func cofigure() {
        layer.cornerRadius = 10
        layer.borderWidth = 0.5
        addSubviews(titleLabel)
        NSLayoutConstraint.activate([
            self.heightAnchor.constraint(equalToConstant: 20),
            self.widthAnchor.constraint(equalToConstant: 58),
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
    }
    
    func setStyle(_ style: ReviewStyle) {
        switch style {
        case .none:
            self.backgroundColor = .white
            titleLabel.font = CustomFont.PretendardRegular(size: .lg).font
            titleLabel.textColor = .custom.gray5
            self.layer.borderColor = UIColor.custom.gray2?.cgColor
            
        case .done:
            self.backgroundColor = .custom.gray5
            titleLabel.font = CustomFont.PretendardRegular(size: .lg).font
            titleLabel.textColor = .white
            self.layer.borderColor = UIColor.custom.gray2?.cgColor
            
        case .success:
            self.backgroundColor = .custom.main
            titleLabel.font = CustomFont.PretendardBold(size: .lg).font
            titleLabel.textColor = .white
            self.layer.borderColor = UIColor.custom.main?.cgColor
        }
    }
    
}

#if DEBUG
import SwiftUI

@available(iOS 13.0, *)
struct ReviewStatusBarView_Preview: PreviewProvider {
    static var previews: some View {
        
        UIViewPreview {
            let view = ReviewStatusBarView()
            view.setReviewStyle(.successReview)
            return view
        }
        .previewLayout(.fixed(width: 150, height: 192))
        .padding(50)
    }
}
#endif
