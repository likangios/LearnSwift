//
//  TiaoKuanViewController.swift
//  LearnSwift
//
//  Created by luck on 2018/10/9.
//  Copyright © 2018年 luck. All rights reserved.
//

import UIKit
import WebKit
class TiaoKuanViewController: UIViewController ,WKNavigationDelegate,UIScrollViewDelegate{
    
    var hasHiddenRecommond:Bool = false
    var hasHiddenPay:Bool = false
    lazy var webView: WKWebView = {
        let web = WKWebView.init()
        web.navigationDelegate = self
        web.scrollView.delegate = self
        return web
    }()
    lazy var agreeButton: UIButton = {
        let btn = UIButton.init(type: UIButtonType.custom)
        btn.setTitle("阅读并同意用户条款", for: UIControlState.normal)
        btn.backgroundColor = UIColor.black
        btn.setTitleColor(UIColor.white, for: UIControlState.normal)
        btn.layer.cornerRadius = 20
        return btn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UserDefaults.standard.setValue("1", forKey: "first")
        UserDefaults.standard.synchronize()
        view.addSubview(self.webView)
        self.webView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        self.webView.load(URLRequest.init(url: URL.init(string: "https://www.jianshu.com/p/b686a5fb9d63")!))
        
        view.addSubview(self.agreeButton)
        self.agreeButton.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(-30)
            make.size.equalTo(CGSize(width: 200, height: 40))
        }
        self.agreeButton.addTarget(self, action: #selector(buttonclick), for: UIControlEvents.touchUpInside)
    }
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        webView.evaluateJavaScript("document.getElementsByClassName('header-wrap')[0].style.display = 'none'") { (obj, error) in
            
        }
        webView.evaluateJavaScript("document.getElementsByClassName('footer-wrap')[0].style.display = 'none'") { (obj, error) in
            
        }
        webView.evaluateJavaScript("document.getElementsByClassName('panel')[0].style.display = 'none'") { (obj, error) in
            
        }
        webView.evaluateJavaScript("document.getElementsByClassName('app-open')[0].style.display = 'none'") { (obj, error) in
            
        }
        webView.evaluateJavaScript("document.getElementsByClassName('open-app-btn')[0].style.display = 'none'") { (obj, error) in
            
        }
        webView.evaluateJavaScript("document.getElementsByClassName('article-info')[0].style.display = 'none'") { (obj, error) in
            
        }
    }
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !self.hasHiddenRecommond {
            webView.evaluateJavaScript("document.getElementsByClassName('recommend-note')[0].style.display = 'none'") { (obj, error) in
                
            }
        }
        if !self.hasHiddenPay {
            webView.evaluateJavaScript("document.getElementsByClassName('btn btn-pay reward-button')[0].style.display = 'none'") { (obj, error) in
                
            }
        }     
    }

    @objc func buttonclick() -> Void {
        self.dismiss(animated: true, completion: nil)
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
