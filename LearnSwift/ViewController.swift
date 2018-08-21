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
class ViewController: UIViewController {

    lazy var textLabel:UILabel = {
       let label = UILabel.init()
        label.textColor = UIColor.white
        label.font = UIFont.systemFont(ofSize: 50)
        label.textAlignment = NSTextAlignment.center
        label.text = "为你打call"
        return label
    }()
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
        view.backgroundColor = UIColor.black
        view.addSubview(textLabel)
        view.addSubview(greenSlider)
        view.addSubview(blueSlider)
        view.addSubview(redSlider)
        view.addSubview(fontSizeSlider)
        
        textLabel.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.size.equalTo(CGSize(width: view.frame.height, height: view.frame.width))
        }
        textLabel.transform = CGAffineTransform.init(rotationAngle: CGFloat(Double.pi)/2.0)
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
        greenSlider.addTarget(self, action: #selector(sliderValueChanged), for: UIControlEvents.valueChanged)
        redSlider.addTarget(self, action: #selector(sliderValueChanged), for: UIControlEvents.valueChanged)
        blueSlider.addTarget(self, action: #selector(sliderValueChanged), for: UIControlEvents.valueChanged)
        fontSizeSlider.addTarget(self, action: #selector(fontSliderValueChanged), for: UIControlEvents.valueChanged)

        greenSlider.value = UserDefaults.standard.value(forKey: "color_g") as? Float  ?? 0.5
        redSlider.value = UserDefaults.standard.value(forKey: "color_r") as? Float  ?? 0.5
        blueSlider.value = UserDefaults.standard.value(forKey: "color_b") as? Float  ?? 0.5
        sliderValueChanged()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}
extension ViewController {
    @objc func sliderValueChanged() -> Void {
        textLabel.textColor = UIColor.init(red: CGFloat(redSlider.value), green: CGFloat(greenSlider.value), blue: CGFloat(blueSlider.value), alpha: 1)
        UserDefaults.standard.set(redSlider.value, forKey: "color_r")
        UserDefaults.standard.set(greenSlider.value, forKey: "color_g")
        UserDefaults.standard.set(blueSlider.value, forKey: "color_b")
    }
   @objc func fontSliderValueChanged() -> Void {
    textLabel.font = UIFont.systemFont(ofSize: CGFloat(fontSizeSlider.value))
    }
    
}
