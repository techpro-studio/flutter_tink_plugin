//
//  TinkAuthViewController.swift
//  tink_plugin
//
//  Created by Alex on 28.01.2021.
//

import Foundation
import WebKit

final class TinkAuthViewController: UIViewController, WKNavigationDelegate, WKUIDelegate {
    private let redirectURI: String
    private let webView = WKWebView()
    private let url: URL

    var tinkAuthDataCallback: ((TinkAuthData) -> Void)!

    init(authURL: URL) {
        self.url = authURL
        self.redirectURI = authURL.getQueryParameter(name: "redirect_uri")!
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


    @objc func close() {
        self.finish(data: .userCancelled)
    }


    func finish(data: TinkAuthData){
        self.dismiss(animated: true) {[weak self] in
            self?.tinkAuthDataCallback(data)
        }
    }

    public override func viewDidLoad() {
        super.viewDidLoad()

        if #available(iOS 13.0, *) {
            self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(self.close))
        } else {
            self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(self.close))
        }
        title = "Tink authentication"
        webView.navigationDelegate = self
        webView.uiDelegate = self
        webView.translatesAutoresizingMaskIntoConstraints = false
        webView.fill(in: self.view)

        webView.load(URLRequest(url: url))
    }

    public func webViewDidClose(_ webView: WKWebView) {
        webView.removeFromSuperview()
    }


    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if let url = navigationAction.request.url {
            if !["https", "http"].contains(url.scheme) {
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                } else {
                    UIApplication.shared.openURL(url)
                }
                decisionHandler(.cancel)
            } else if url.absoluteString.contains(self.redirectURI), let tinkAuthData = TinkAuthDataExtractor.extract(url: url) {
                decisionHandler(.cancel)
                self.finish(data: tinkAuthData)
            } else {
                decisionHandler(.allow)
            }
        } else {
            decisionHandler(.allow)
        }
    }

    deinit {
        print("Deinited Tink")
    }
}
