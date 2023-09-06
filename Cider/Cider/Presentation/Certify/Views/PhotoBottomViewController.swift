//
//  PhotoBottomViewController.swift
//  Cider
//
//  Created by 임영선 on 2023/09/07.
//

import UIKit
import Combine

final class PhotoBottomViewController: UIViewController {

    private lazy var galleryButton: UIButton = {
        let button = UIButton()
        button.setTitle("갤러리 가져오기", for: .normal)
        button.titleLabel?.font = CustomFont.PretendardBold(size: .base).font
        button.setTitleColor(.custom.text, for: .normal)
        button.addTarget(self, action: #selector(didTapGallery), for: .touchUpInside)
        return button
    }()
    
    private lazy var cameraButton: UIButton = {
        let button = UIButton()
        button.setTitle("카메라 사진찍기", for: .normal)
        button.titleLabel?.font = CustomFont.PretendardBold(size: .base).font
        button.setTitleColor(.custom.text, for: .normal)
        button.addTarget(self, action: #selector(didTapCamera), for: .touchUpInside)
        return button
    }()
    
    private lazy var separtorView1: UIView = {
        let view = UIView()
        view.backgroundColor = .custom.gray2
        return view
    }()
    
    private lazy var imagePickerController: UIImagePickerController = {
        let controller = UIImagePickerController()
        controller.delegate = self
        controller.allowsEditing = true
        return controller
    }()
    
    private let profileImageName = ["bearProfile", "chickProfile", "fishProfile", "rabbitProfile", "pigProfile"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    private func configure() {
        view.backgroundColor = .white
        view.addSubviews(galleryButton, cameraButton, separtorView1)
        NSLayoutConstraint.activate([
            separtorView1.heightAnchor.constraint(equalToConstant: 2),
            galleryButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 30),
            galleryButton.heightAnchor.constraint(equalToConstant: 48),
            cameraButton.heightAnchor.constraint(equalToConstant: 48),
            galleryButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            galleryButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            separtorView1.leadingAnchor.constraint(equalTo: galleryButton.leadingAnchor),
            separtorView1.trailingAnchor.constraint(equalTo: galleryButton.trailingAnchor),
            separtorView1.topAnchor.constraint(equalTo: galleryButton.bottomAnchor),
            cameraButton.topAnchor.constraint(equalTo: separtorView1.bottomAnchor),
            cameraButton.leadingAnchor.constraint(equalTo: galleryButton.leadingAnchor),
            cameraButton.trailingAnchor.constraint(equalTo: galleryButton.trailingAnchor)
        ])
    }
    
}

private extension PhotoBottomViewController {
    
    @objc func didTapGallery(_ sender: Any?) {
        imagePickerController.sourceType = .photoLibrary
        self.present(imagePickerController, animated: true)
    }
    
    @objc func didTapCamera(_ sender: Any?) {
        imagePickerController.sourceType = .camera
        self.present(imagePickerController, animated: true)
    }
    
    @objc func didTapRandom(_ sender: Any?) {
        guard let imageName = profileImageName.randomElement() else {
            return
        }
        NotificationCenter.default.post(name: .selectImage, object: UIImage(named: imageName))
        self.dismiss(animated: true)
    }
    
}

extension PhotoBottomViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            NotificationCenter.default.post(name: .selectImage, object: image)
        }
        picker.dismiss(animated: true, completion: nil)
        self.dismiss(animated: true)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
}
