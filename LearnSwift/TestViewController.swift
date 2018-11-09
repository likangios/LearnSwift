//
//  TestViewController.swift
//  LearnSwift
//
//  Created by perfay on 2018/9/28.
//  Copyright © 2018年 luck. All rights reserved.
//

import UIKit
import WebKit
class TestViewController: UIViewController ,WKNavigationDelegate ,WKUIDelegate{

    lazy var webView: WKWebView = {
        let javascript = NSMutableString()
        javascript.append("document.documentElement.style.webkitTouchCallout='none';")
        javascript.append("document.documentElement.style.webkitUserSelect='none';")
        let usercontoller = WKUserContentController()
        let script = WKUserScript.init(source: javascript as String, injectionTime: WKUserScriptInjectionTime.atDocumentStart, forMainFrameOnly: true)
        usercontoller .addUserScript(script)
        let processpool = WKProcessPool()
        let webviewConfig = WKWebViewConfiguration()
        webviewConfig.processPool = processpool
        webviewConfig.allowsInlineMediaPlayback = true
        webviewConfig.userContentController = usercontoller
        let web = WKWebView.init(frame: CGRect.zero, configuration: webviewConfig)
        web.navigationDelegate = self as! WKNavigationDelegate
        web.allowsBackForwardNavigationGestures = true
        web.allowsLinkPreview = false
        web.uiDelegate = self
        web.navigationDelegate = self
        return web
    }()
    lazy var bottomView: BottomView = {
        let view = BottomView()
        view.buttonClick = {[weak self] (tag:Int) in
            self?.itemClick(tag)
        }
        return view
    }()
    lazy var progressView: UIProgressView = {
        let view = UIProgressView.init(frame: CGRect.zero)
        view.progressTintColor = UIColor.init(hex: "2873dd")
        view.trackTintColor = UIColor.clear
        view.isHidden = true
        return view
    }()
    var loadUrl:String?
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(self.webView)
        view.addSubview(self.bottomView)

        view.backgroundColor = UIColor.white
        self.webView.snp.makeConstraints { (make) in
            if KISIphoneX {
                make.top.equalTo(45);
            }
            else{
                make.top.equalTo(0);
            }
            make.left.right.equalToSuperview()
            make.bottom.equalTo(self.bottomView.snp.top)
        }
        if loadUrl != nil {
            self.webView.load(URLRequest.init(url: URL.init(string: self.loadUrl!)!))
        }
        if #available(iOS 11.0, *) {
            webView.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentBehavior.never
        }
        bottomView.snp.makeConstraints { (make) in
            if KISIphoneX {
                make.bottom.equalTo(-35)
            }
            else{
                make.bottom.equalTo(0)
            }
            make.left.right.equalTo(0)
            make.height.equalTo(45)
        }
        self.webView.addObserver(self, forKeyPath: "estimatedProgress", options: [.new,.old], context: nil)
        bottomView.addSubview(self.progressView)
        self.progressView.snp.makeConstraints { (make) in
            make.left.right.top.equalToSuperview()
        }

    }
    deinit {
        webView.removeObserver(self, forKeyPath:"estimatedProgress")
    }
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        self.progressView.setProgress(0, animated: true)
        self.progressView.isHidden = true
    }
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        self.progressView.setProgress(0, animated: true)
        self.progressView.isHidden = true
    }
    func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        guard navigationAction.targetFrame != nil else {
            webView.load(navigationAction.request)
            return nil
        }
        if !(navigationAction.targetFrame!.isMainFrame) {
            webView.load(navigationAction.request)
        }
        return nil
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        
        guard navigationAction.request.url?.absoluteString != nil else {
            decisionHandler(WKNavigationActionPolicy.cancel )
            return
        }
        if gotoOtherApp(url: navigationAction.request.url!.absoluteString).boolValue {
            decisionHandler(WKNavigationActionPolicy.cancel )
        }
        else{
            decisionHandler(WKNavigationActionPolicy.allow )

        }
    }
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "estimatedProgress" {
            let newprogress:NSNumber = change?[.newKey]! as! NSNumber
            let oldprogress:NSNumber = change?[.oldKey] as? NSNumber ?? 0
            if newprogress.floatValue < oldprogress.floatValue {
                return
            }
        if newprogress == 1 {
                progressView.isHidden = true
                progressView.setProgress(0, animated:false)
         }else {
                progressView.isHidden = false
                progressView.setProgress(newprogress.floatValue, animated:true)
        }
        }
    }
    func itemClick(_ tag:Int) -> Void {
        switch tag {
        case 1:
            goHome()
            break
        case 2:
            goBack()
            break
        case 3:
            goForward()
            break
        case 4:
            goRefresh()
            break
        case 5:
            goMenu()
            break
        default:
            break
        }
    }
    func goHome() -> Void {
        if (self.webView.backForwardList != nil) && self.webView.backForwardList.backList.count > 0 {
            self.webView.go(to: self.webView.backForwardList.backList.first!)
        }
        else{
            loadMainURL()
        }
    }
    func goBack() -> Void {
        if currentContentNIl() {
            loadMainURL()
        }
        else{
            if self.webView.canGoBack {
                self.webView.goBack()
            }
        }
    }
    func goForward() -> Void {
        if currentContentNIl() {
            loadMainURL()
        }
        else{
            if self.webView.canGoForward {
                self.webView.goForward()
            }
        }
    }
    func goRefresh() -> Void {
        if currentContentNIl() {
            loadMainURL()
        }
        else{
            self.webView.reload()
        }
    }
    func goMenu() -> Void {
        var controller = UIAlertController.init(title: nil, message: "是否使用浏览器打开", preferredStyle: .alert)
        controller.addAction(UIAlertAction.init(title: "取消", style: .cancel, handler: { (action:UIAlertAction) in
            
        }))
        controller.addAction(UIAlertAction.init(title: "确定", style: .default, handler: { (action:UIAlertAction) in
            self.openSafari()
        }))
        self.present(controller, animated: true, completion: nil)
    }
    
    func currentContentNIl() -> Bool {
        if self.webView.url?.absoluteString == nil {
            return true
        }
        return false
    }
    func loadMainURL() -> Void {
        guard self.loadUrl != nil else {
            exit(0)
        }
        self.webView.load(URLRequest.init(url: URL.init(string: self.loadUrl!)!))
    }
    func  openSafari() -> Void {
        if !currentContentNIl() {
            if UIApplication.shared.canOpenURL(self.webView.url!) {
                UIApplication.shared.openURL(self.webView.url!)
            }
        }
    }
    func gotoOtherApp(url:String) -> ObjCBool {
        let qq:String = "m" + "qq"
        let wx1:String = "wei" + "xin"
        let wx2:String = "we" + "chat"
        let ap:String = "ali" + "pay"
        if url.hasPrefix(qq) || url.hasPrefix(wx1) || url.hasPrefix(wx2) || url.hasPrefix(ap) {
            if UIApplication.shared.canOpenURL(URL.init(string: url)!) {
                UIApplication.shared.openURL(URL.init(string: url)!)
            }
            else {
                let controller = UIAlertController.init(title: nil, message: "没有安装客户端", preferredStyle: .alert)
                controller.addAction(UIAlertAction.init(title: "确定", style: .default, handler: { (action:UIAlertAction) in
                }))
                self.present(controller, animated: true, completion: nil)
            }
            return true
        }
        return false
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
