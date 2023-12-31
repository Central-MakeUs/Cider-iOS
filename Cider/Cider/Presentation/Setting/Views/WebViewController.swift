//
//  WebViewController.swift
//  Cider
//
//  Created by 임영선 on 2023/08/18.
//

import UIKit
import WebKit

public final class WebViewController: UIViewController, WKUIDelegate, WKNavigationDelegate {

    private let webView = WKWebView(frame: .zero)
    private let url: String

    public override func viewDidLoad() {
        super.viewDidLoad()
    }

    public init(url: String) {
        self.url = url
        super.init(nibName: nil, bundle: nil)
        configureWebView()

    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configureWebView() {
        view.addSubviews(webView)
        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: view.topAnchor),
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            webView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        let url = URL(string: url)
        let request = URLRequest(url: url!)
        webView.allowsBackForwardNavigationGestures = true
        webView.uiDelegate = self
        webView.navigationDelegate = self
        webView.load(request)
    }
    
}
