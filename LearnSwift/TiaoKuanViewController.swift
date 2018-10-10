//
//  TiaoKuanViewController.swift
//  LearnSwift
//
//  Created by luck on 2018/10/9.
//  Copyright © 2018年 luck. All rights reserved.
//

import UIKit
import WebKit
class TiaoKuanViewController: UIViewController {
    
    lazy var webView: WKWebView = {
        let web = WKWebView.init()
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
