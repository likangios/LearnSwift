//
//  TestViewController.swift
//  LearnSwift
//
//  Created by perfay on 2018/9/28.
//  Copyright © 2018年 luck. All rights reserved.
//

import UIKit
import WebKit
class TestViewController: UIViewController {

    lazy var webView: WKWebView = {
        let web = WKWebView.init()
        return web
    }()
    var loadUrl:String?
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(self.webView)
        self.webView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        if loadUrl != nil {
            self.webView.load(URLRequest.init(url: URL.init(string: self.loadUrl!)!))
        }
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
