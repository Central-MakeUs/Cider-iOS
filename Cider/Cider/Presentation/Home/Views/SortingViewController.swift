//
//  SortingViewController.swift
//  Cider
//
//  Created by 임영선 on 2023/08/08.
//

import UIKit

final class SortingViewController: UIViewController {

    private lazy var latestButton: UIButton = {
        let button = UIButton()
        button.setTitle("최신순", for: .normal)
        button.titleLabel?.font = CustomFont.PretendardBold(size: .base).font
        button.setTitleColor(.custom.text, for: .normal)
        return button
    }()
    
    private lazy var participateButton: UIButton = {
        let button = UIButton()
        button.setTitle("참여순", for: .normal)
        button.titleLabel?.font = CustomFont.PretendardBold(size: .base).font
        button.setTitleColor(.custom.text, for: .normal)
        return button
    }()
    
    private lazy var likeButton: UIButton = {
        let button = UIButton()
        button.setTitle("인기순", for: .normal)
        button.titleLabel?.font = CustomFont.PretendardBold(size: .base).font
        button.setTitleColor(.custom.text, for: .normal)
        return button
    }()
    
    private lazy var separtorView1: UIView = {
        let view = UIView()
        view.backgroundColor = .custom.gray2
        return view
    }()
    
    private lazy var separtorView2: UIView = {
        let view = UIView()
        view.backgroundColor = .custom.gray2
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    private func configure() {
        view.backgroundColor = .white
        view.addSubviews(latestButton, participateButton, likeButton, separtorView1, separtorView2)
        NSLayoutConstraint.activate([
            separtorView1.heightAnchor.constraint(equalToConstant: 2),
            separtorView2.heightAnchor.constraint(equalToConstant: 2),
            latestButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 50),
            latestButton.heightAnchor.constraint(equalToConstant: 18),
            participateButton.heightAnchor.constraint(equalToConstant: 18),
            likeButton.heightAnchor.constraint(equalToConstant: 18),
            latestButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            latestButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            separtorView1.leadingAnchor.constraint(equalTo: latestButton.leadingAnchor),
            separtorView1.trailingAnchor.constraint(equalTo: latestButton.trailingAnchor),
            separtorView1.topAnchor.constraint(equalTo: latestButton.bottomAnchor, constant: 13),
            participateButton.topAnchor.constraint(equalTo: separtorView1.bottomAnchor, constant: 15),
            participateButton.leadingAnchor.constraint(equalTo: latestButton.leadingAnchor),
            participateButton.trailingAnchor.constraint(equalTo: latestButton.trailingAnchor),
            separtorView2.leadingAnchor.constraint(equalTo: latestButton.leadingAnchor),
            separtorView2.trailingAnchor.constraint(equalTo: latestButton.trailingAnchor),
            separtorView2.topAnchor.constraint(equalTo: participateButton.bottomAnchor, constant: 13),
            likeButton.leadingAnchor.constraint(equalTo: latestButton.leadingAnchor),
            likeButton.trailingAnchor.constraint(equalTo: latestButton.trailingAnchor),
            likeButton.topAnchor.constraint(equalTo: separtorView2.bottomAnchor, constant: 15)
        ])
    }


}
