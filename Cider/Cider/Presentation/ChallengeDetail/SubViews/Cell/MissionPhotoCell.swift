//
//  MissionPhotoCell.swift
//  Cider
//
//  Created by 임영선 on 2023/08/03.
//

import UIKit

final class MissionPhotoCell: UICollectionViewCell {
    
    static let identifier = "MissionPhotoCell"

    private lazy var missionImageView1: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 4
        return imageView
    }()
    
    private lazy var missionImageView2: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 4
        return imageView
    }()
    
    private lazy var missionImageView3: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 4
        return imageView
    }()
    
    private lazy var missionImageView4: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 4
        return imageView
    }()
    
    private lazy var missionImageView5: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 4
        return imageView
    }()
    
    private lazy var missionImageView6: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 4
        return imageView
    }()
    
    private lazy var imageViews = [missionImageView1, missionImageView2, missionImageView3,
                                   missionImageView4, missionImageView5, missionImageView6]
    
    private lazy var stackView1: UIStackView = {
        let stackView = UIStackView(axis: .horizontal, alignment: .fill, distribution: .fillEqually, spacing: 12)
        stackView.addArrangedSubviews(missionImageView1, missionImageView2, missionImageView3)
        return stackView
    }()
    
    private lazy var stackView2: UIStackView = {
        let stackView = UIStackView(axis: .horizontal, alignment: .fill, distribution: .fillEqually, spacing: 12)
        stackView.addArrangedSubviews(missionImageView4, missionImageView5, missionImageView6)
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        let height = (UIScreen.main.bounds.width-48-24)/3
        addSubviews(stackView1, stackView2)
        NSLayoutConstraint.activate([
            stackView1.topAnchor.constraint(equalTo: topAnchor),
            stackView1.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24),
            stackView1.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24),
            stackView1.heightAnchor.constraint(equalToConstant: height),
            stackView2.topAnchor.constraint(equalTo: stackView1.bottomAnchor, constant: 8),
            stackView2.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24),
            stackView2.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24),
            stackView2.heightAnchor.constraint(equalToConstant: height),
            stackView2.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -24)
        ])
    }
}

extension MissionPhotoCell {
    
    func setUp(photos: [String]) {
        for i in 0..<photos.count {
            imageViews[i].load(url: photos[i])
        }
    }
    
}

#if DEBUG
import SwiftUI

@available(iOS 13.0, *)
struct MissionPhotoCell_Preview: PreviewProvider {
    static var previews: some View {
        
        UIViewPreview {
            let cell = MissionPhotoCell()
            cell.setUp(
                photos: [
             "sss"
            ])
            return cell
        }
        .previewLayout(.fixed(width: 150, height: 192))
        .padding(10)
    }
}
#endif
