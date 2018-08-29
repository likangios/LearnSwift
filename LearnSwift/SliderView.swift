//
//  SliderView.swift
//  LearnSwift
//
//  Created by perfay on 2018/8/24.
//  Copyright © 2018年 luck. All rights reserved.
//

import UIKit
import RxSwift


class SliderView: UIView {

    lazy var slider: UISlider = {
        let sd = UISlider()
        sd.minimumValue = sMinValue
        sd.maximumValue = sMaxValue
        sd.value = sValue
        return sd
    }()
    lazy var title: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.white
        label.textAlignment = NSTextAlignment.left
        return label;
    }()
    var obserable = ReplaySubject<Float>.create(bufferSize: 1)
    
    let disposeBag = DisposeBag()

    private var sValue:Float = 5
    private var sMinValue:Float = 0
    private var sMaxValue:Float = 1
    private var sTintColor :UIColor = UIColor.blue
    private var titleStr:String = ""
    
    public init(frame: CGRect ,Title: String ,sValue:Float, sdMinValue:Float,sdMaxValue:Float,sdTintColor:UIColor) {
        super.init(frame: frame)
        self.titleStr = Title
        self.sValue = sValue
        self.sMinValue = sdMinValue
        self.sMaxValue = sdMaxValue
        self.sTintColor = sdTintColor
        creatSubView()
        slider.rx.value.asObservable().bind(to: obserable).disposed(by: disposeBag)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
extension SliderView {
    
    func  creatSubView() -> Void {
        addSubview(title)
        addSubview(slider)
        
        title.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalTo(5)
        }
        slider.snp.makeConstraints { (make) in
            make.left.equalTo(60)
            make.bottom.top.equalToSuperview()
            make.right.equalTo(-5)
        }
        title.text = titleStr
        slider.tintColor = sTintColor

    }
}
