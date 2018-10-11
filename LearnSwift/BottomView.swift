//
//  BottomView.swift
//  LearnSwift
//
//  Created by perfay on 2018/10/10.
//  Copyright © 2018年 luck. All rights reserved.
//

import UIKit
import RxSwift

class BottomView: UIView {
    
    var obserable = ReplaySubject<Float>.create(bufferSize: 1)
    let disposeBag = DisposeBag()
    typealias clickClosure = (_ type:Int) -> Void
    
    public var buttonClick:clickClosure?

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
        creatSubView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
extension BottomView {
    func creatSubView() -> Void {
        let imgs = ["test1","test2","test3","test4","test5"]
        var lasBtn:UIButton? = nil
        for index in 1...5 {
            let btn = UIButton.init(type: .custom)
            btn.setImage(UIImage.init(named: imgs[index - 1]), for: .normal)
            btn.tag = index
            btn.addTarget(self, action: #selector(buttonClick(btn:)), for: .touchUpInside)
            addSubview(btn)
            btn.snp.makeConstraints { (make) in
                make.top.bottom.equalToSuperview()
                if lasBtn != nil {
                    make.width.equalTo(lasBtn!.snp.width)
                    make.left.equalTo(lasBtn!.snp.right)
                }
                else{
                    make.left.equalTo(0)
                }
            }
            lasBtn = btn
        }
        lasBtn!.snp.makeConstraints({ (make) in
            make.right.equalToSuperview()
        })
    }
    @objc func buttonClick(btn:UIButton) -> Void {
        if (buttonClick != nil) {
            buttonClick!(btn.tag)
        }
    }
}
