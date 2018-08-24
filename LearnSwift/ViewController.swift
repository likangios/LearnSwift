//
//  ViewController.swift
//  LearnSwift
//
//  Created by perfay on 2018/8/21.
//  Copyright © 2018年 luck. All rights reserved.
//

import UIKit
import SnapKit
import Hue
import RxSwift
import RxCocoa


class ViewController: UIViewController {

    lazy var ledView:LEDView = {
       let view = LEDView()
        return view
    }()
    lazy var controlView: ControlView = {
        let view = ControlView()
        return view
    }()
    lazy var speedSlider:UISlider = {
        let sd = UISlider.init()
        sd.minimumValue = 0
        sd.maximumValue = 20
        sd.tintColor = UIColor.white
        return sd
    }();
    lazy var fontSizeSlider:UISlider = {
        let sd = UISlider.init()
        sd.minimumValue = 50
        sd.maximumValue = 300
        sd.tintColor = UIColor.white
        return sd
    }();
   lazy var greenSlider:UISlider = {
        let sd = UISlider.init()
        sd.minimumValue = 0
        sd.maximumValue = 1
        sd.tintColor = UIColor.green
        return sd
    }();
    lazy var blueSlider:UISlider = {
        let sd = UISlider.init()
        sd.minimumValue = 0
        sd.maximumValue = 1
        sd.tintColor = UIColor.blue
        return sd
    }();
    lazy var redSlider:UISlider = {
        let sd = UISlider.init()
        sd.minimumValue = 0
        sd.maximumValue = 1
        sd.tintColor = UIColor.red
        return sd
    }();
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
//        view.addSubview(ledView)
//        view.addSubview(speedSlider)
//        view.addSubview(greenSlider)
//        view.addSubview(blueSlider)
//        view.addSubview(redSlider)
//        view.addSubview(fontSizeSlider)
        view.addSubview(controlView)
        controlView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        /*
        ledView.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.size.equalTo(CGSize(width: view.frame.height, height: view.frame.width))
        }
        ledView.transform = CGAffineTransform.init(rotationAngle: CGFloat(Double.pi)/2.0)
        ledView.speed = 3
        ledView.space = 100
        ledView.fontSize = 150
        ledView.content = "答复；萨芬贾师傅阿萨德了富士达；了发送到"
        redSlider.snp.makeConstraints { (make) in
            make.left.equalTo(20)
            make.right.equalTo(-20)
            make.bottom.equalTo(-20)
            make.height.equalTo(20)
        }
        blueSlider.snp.makeConstraints { (make) in
            make.left.equalTo(20)
            make.right.equalTo(-20)
            make.bottom.equalTo(redSlider.snp.top).offset(-20)
            make.height.equalTo(20)
        }
        greenSlider.snp.makeConstraints { (make) in
            make.left.equalTo(20)
            make.right.equalTo(-20)
            make.bottom.equalTo(blueSlider.snp.top).offset(-20)
            make.height.equalTo(20)
        }
        fontSizeSlider.snp.makeConstraints { (make) in
            make.left.equalTo(20)
            make.right.equalTo(-20)
            make.bottom.equalTo(greenSlider.snp.top).offset(-20)
            make.height.equalTo(20)
        }
        speedSlider.snp.makeConstraints { (make) in
            make.left.equalTo(20)
            make.right.equalTo(-20)
            make.bottom.equalTo(fontSizeSlider.snp.top).offset(-20)
            make.height.equalTo(20)
        }
//        greenSlider.addTarget(self, action: #selector(sliderValueChanged), for: UIControlEvents.valueChanged)
//        redSlider.addTarget(self, action: #selector(sliderValueChanged), for: UIControlEvents.valueChanged)
//        blueSlider.addTarget(self, action: #selector(sliderValueChanged), for: UIControlEvents.valueChanged)
        fontSizeSlider.addTarget(self, action: #selector(fontSliderValueChanged), for: UIControlEvents.valueChanged)
        speedSlider.addTarget(self, action: #selector(speedSliderValueChanged), for: UIControlEvents.valueChanged)
                
        
//        let greenSliderValue = Variable<Float>(1.0)
//        _ = greenSlider.rx.value <-> greenSliderValue
//
//        let blueSliderValue = Variable<Float>(1.0)
//        _ = blueSlider.rx.value <-> blueSliderValue
//
//        let redSliderValue = Variable<Float>(1.0)
//        _ = redSlider.rx.value <-> redSliderValue
//
//        greenSliderValue.asObservable().subscribe(onNext: { (value) in
//            print("greenSliderValue value is \(value)")
//        }, onError: nil, onCompleted: nil, onDisposed: nil).dispose()
//
//        redSliderValue.asObservable().subscribe(onNext: { (value) in
//            print("redSliderValue value is \(value)")
//        }, onError: nil, onCompleted: nil, onDisposed: nil).dispose()
//
//        blueSliderValue.asObservable().subscribe(onNext: { (value) in
//            print("blueSliderValue value is \(value)")
//        }, onError: nil, onCompleted: nil, onDisposed: nil).dispose()

        
        
        greenSlider.value = UserDefaults.standard.value(forKey: "color_g") as? Float  ?? 0.5
        redSlider.value = UserDefaults.standard.value(forKey: "color_r") as? Float  ?? 0.5
        blueSlider.value = UserDefaults.standard.value(forKey: "color_b") as? Float  ?? 0.5
        speedSlider.value = UserDefaults.standard.value(forKey: "speed") as? Float  ?? 0.5

        ledView.speed = CGFloat(UserDefaults.standard.value(forKey: "speed") as? Float  ?? 10)
        sliderValueChanged()
         */
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
extension ViewController {
    @objc func sliderValueChanged() -> Void {
        ledView.fontColor = UIColor.init(red: CGFloat(redSlider.value), green: CGFloat(greenSlider.value), blue: CGFloat(blueSlider.value), alpha: 1)
        UserDefaults.standard.set(redSlider.value, forKey: "color_r")
        UserDefaults.standard.set(greenSlider.value, forKey: "color_g")
        UserDefaults.standard.set(blueSlider.value, forKey: "color_b")
    }
   @objc func fontSliderValueChanged() -> Void {
    NSObject.cancelPreviousPerformRequests(withTarget: self)
    self.perform(#selector(changedFont(value:)), with: CGFloat(fontSizeSlider.value), afterDelay: 1)
    }
    @objc func changedFont(value:CGFloat) -> Void {
        ledView.fontSize = CGFloat(fontSizeSlider.value)
        ledView.content = "答复；萨芬贾师傅阿萨德了富士达；了发送到"
    }
    @objc func speedSliderValueChanged() -> Void {
        ledView.speed = CGFloat(speedSlider.value)
        UserDefaults.standard.set(speedSlider.value, forKey: "speed")

    }
    
}
