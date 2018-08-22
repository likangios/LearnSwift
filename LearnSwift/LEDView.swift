//
//  LEDView.swift
//  LearnSwift
//
//  Created by perfay on 2018/8/22.
//  Copyright © 2018年 luck. All rights reserved.
//

import UIKit

class LEDView: UIView {
    let timeInterval:Double = 0.01
    var fontSize:CGFloat = 50
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
    private var _content:String?
    var content: String?{
        get {
            return _content;
        }
        set {
            _content = newValue
            self.creatLabels()
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
            self.timer?.fireDate = Date.distantFuture
            NSObject.cancelPreviousPerformRequests(withTarget: self)
            self.perform(#selector(continueTimer), with: nil, afterDelay: 0.5)
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
        let width = getLabWidth(labelStr: content ?? "", font: UIFont.systemFont(ofSize: fontSize), width: maxWidth).width
        contentWidth = width;
        
        labels.removeAll()
        animaingLabel.removeAll()
        freeLabel.removeAll()
        timer?.invalidate()
        
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
        self.isHidden = !self.isHidden
        if animaingLabel.count == 0 {
            let flb = getFreeLabel()
            guard flb != nil else {
                return;
            }
            animaingLabel.append(flb!)
            timeSpace = 0;
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
