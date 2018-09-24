//
//  WebViewController.swift
//  QatarMuseum
//
//  Created by Exalture on 07/06/18.
//  Copyright © 2018 Exalture. All rights reserved.
//

import UIKit
import WebKit
class WebViewController: UIViewController,UIWebViewDelegate {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var webView: UIWebView!
    
    @IBOutlet weak var loadingView: LoadingView!
    var webViewUrl: URL? = nil
    var titleString: String? = nil
    override func viewDidLoad() {
    loadingView.isHidden = false
    loadingView.showLoading()
        super.viewDidLoad()
        if ((titleString != nil) && (titleString != "")) {
            self.titleLabel.text = titleString
        }
        titleLabel.font = UIFont.headerFont
        let requestObj = URLRequest(url: webViewUrl!)
        self.webView.loadRequest(requestObj)
        webView.delegate = self
        loadingView.isHidden = false
        loadingView.showLoading()
        webView.backgroundColor = UIColor.whiteColor
        webView.scrollView.bounces = false
        
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        
    }
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        loadingView.stopLoading()
        loadingView.isHidden = true
    }
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
       loadingView.stopLoading()
        loadingView.isHidden = true
    }
    func webViewDidStartLoad(_ webView: UIWebView) {
    }
    func webViewDidFinishLoad(_ webView: UIWebView) {
        loadingView.stopLoading()
        loadingView.isHidden = true
    }
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        loadingView.stopLoading()
        loadingView.isHidden = true
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    @IBAction func didTapClose(_ sender: UIButton) {
        self.dismiss(animated: false, completion: nil)
    }
    

}
