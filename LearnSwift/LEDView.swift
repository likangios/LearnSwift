//
//  LEDView.swift
//  LearnSwift
//
//  Created by perfay on 2018/8/22.
//  Copyright © 2018年 luck. All rights reserved.
//

import UIKit

class LEDView: UIView {
    let timeInterval:Double = 0.02
    var _fontSize:CGFloat = 50
    var fontSize: CGFloat{
        get {
            return _fontSize;
        }
        set {
            _fontSize = newValue
            self.content = _content
            
        }
    }
    var fontName:String = "system"
    var labels:[UILabel] = []
    var animaingLabel:[UILabel] = []
    var freeLabel:[UILabel] = []
    var timeSpace:CGFloat = 0
    var timer:Timer?
    var space:CGFloat = 50
    var speed:CGFloat = 2
    
    private  var contentWidth:CGFloat = 0
    private let maxWidth:CGFloat = 20000
    private  var _fontColor:UIColor = UIColor.white
    private var _content:String = "点击输入框输入字幕"
    var content: String{
        get {
            return _content.count>0 ? _content:"点击输入框输入字幕"
        }
        set {
            if ((newValue.count) != nil) {
                _content = newValue
                self.creatLabels()
                
            }
        }
    }
    var fontColor: UIColor {
        get {
            return _fontColor
        }
        set {
            _fontColor = newValue
            self.changeFontColor()
            self.isHidden = false
//            if self.timer?.fireDate != Date.distantFuture {
//                self.timer?.fireDate = Date.distantFuture
//            }
//            NSObject.cancelPreviousPerformRequests(withTarget: self)
//            self.perform(#selector(continueTimer), with: nil, afterDelay: 0.5)
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
extension LEDView {
    
    func creatLabels() -> Void {
        let width = getLabWidth(labelStr: self.content, font: UIFont.systemFont(ofSize: fontSize), width: maxWidth).width
        contentWidth = width;
        
        labels.removeAll()
        animaingLabel.removeAll()
        freeLabel.removeAll()
        timer?.invalidate()
        
        for subLabel in subviews {
            if subLabel.isKind(of: UILabel.self) {
                subLabel.removeFromSuperview()
            }
        }
        
        let count:Int = Int(ceil(UIScreen.main.bounds.height/width)) + 1
        for item in 1...count {
            let label = UILabel()
            label.text = content
            label.font = UIFont.systemFont(ofSize: fontSize)
            label.textColor = fontColor
            addSubview(label)
            label.snp.makeConstraints { (make) in
                make.centerY.equalToSuperview()
                make.left.equalTo(snp.right)
            }
            layoutIfNeeded()
            labels.append(label)
            freeLabel.append(label)
            print(item)
        }
        
        if speed == 0 {
            let flb = freeLabel[0]
            flb.frame  = CGRect(x: 0, y: flb.frame.minY, width: flb.frame.width, height: flb.frame.height)
        }
        timer = Timer.scheduledTimer(timeInterval: timeInterval, target: self, selector: #selector(animations(timer:)), userInfo: nil, repeats: true)
        RunLoop.current.add(timer!, forMode: RunLoopMode.commonModes)
        timer!.fire()
        
    }
    func getLabWidth(labelStr:String,font:UIFont,width:CGFloat) -> CGSize {
        let size = CGSize(width: width, height: UIScreen.main.bounds.width)
        let dic = [NSAttributedStringKey.font:font]
       return NSString(string: labelStr).boundingRect(with: size, options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: dic, context: nil).size
    }
    
    @objc func animations(timer:Timer) -> Void {
//        self.isHidden = !self.isHidden
        if animaingLabel.count == 0 {
            let flb = getFreeLabel()
            guard flb != nil else {
                return;
            }
            animaingLabel.append(flb!)
            timeSpace = 0;
        }
        guard speed > 0 else {
            return
        }
        timeSpace += speed
        if timeSpace >= space + contentWidth{
            let flb = getFreeLabel()
            if flb != nil {
                animaingLabel.append(flb!)
            }
            timeSpace = 0
        }
        moveAllLabel()
    }
    func moveAllLabel() -> Void {
        for label in animaingLabel {
            label.center = CGPoint(x: label.center.x - speed, y: label.center.y)
            if (label.center.x + label.bounds.size.width/2.0) < 0
            {
                label.frame = CGRect(x: UIScreen.main.bounds.height, y: label.frame.minY, width: label.frame.width, height: label.frame.height)
                freeLabel.append(label)
                animaingLabel.remove(at: animaingLabel.index(of: label)!)
            }
        }
    }
    func getFreeLabel() -> UILabel?{
        guard freeLabel.count != 0 else {
            return nil
        }
        let label = freeLabel[0]
        freeLabel.remove(at: 0);
        return label;
    }
    func changeFontColor() -> Void {
        for label in labels {
            label.textColor = fontColor
        }
    }
    @objc func continueTimer() -> Void {
        self.timer?.fireDate = Date.distantPast
    }
    

}
