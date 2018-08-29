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
    lazy var inputField: UITextField = {
        let field = UITextField()
        field.borderStyle = UITextBorderStyle.roundedRect
        field.layer.borderColor = mainColor.cgColor
        field.textColor = UIColor.white
        field.layer.borderWidth = 0.5
        field.layer.cornerRadius = 17.5
        field.placeholder = "输入弹幕内容"
        field.setValue(UIColor.white, forKeyPath: "_placeholderLabel.textColor")
        field.backgroundColor = UIColor.clear
        field.textAlignment = NSTextAlignment.center
        return field
    }()
    
    var disposeBag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.black
        view.addSubview(ledView)
        view.addSubview(controlView)
        view.addSubview(inputField)
        inputField.snp.makeConstraints { (make) in
            make.left.equalTo(15)
            make.centerX.equalToSuperview()
            make.top.equalTo(20)
            make.height.equalTo(35)
        }
        controlView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        ledView.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.size.equalTo(CGSize(width: view.frame.height, height: view.frame.width))
        }
        ledView.transform = CGAffineTransform.init(rotationAngle: CGFloat(Double.pi)/2.0)
        ledView.space = 100
        ledView.content = "点击输入框输入字幕"
        controlView.speedSlider.obserable.subscribe({ (event) in
            self.speedSliderValueChanged(speed: event.element!)
        }).disposed(by: disposeBag)
        
        controlView.fontSlider.obserable.debounce(1, scheduler: MainScheduler.instance).subscribe { (event) in
            self.changedFont(value: event.element!)
        }.disposed(by: disposeBag)
        
        controlView.colorObserable.debounce(0.5, scheduler: MainScheduler.instance).subscribe {[weak self] (event) in
            if self!.controlView.isSelectedBg {
                self!.view.backgroundColor = event.element!
            }
            else{
                self!.ledView.fontColor = event.element!
            }
        }.disposed(by: disposeBag)
        
        
        let inputValid = self.inputField.rx.text.orEmpty
            .skipWhile { $0.count <= 0 }
            .share(replay: 1)
        
        inputValid.distinctUntilChanged().bind { (text) in
            self.ledView.content = text
            self.ledView.creatLabels()
        }.disposed(by: disposeBag)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
extension ViewController {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        controlView.showMainView(animate: true)
    }
    @objc func changedFont(value:Float) -> Void {
        if value > 0.0 {
            print("font size = \(value)")
            ledView.fontSize = CGFloat(value)
            ledView.content = "点击输入框输入字幕"
            ledView.creatLabels()
            UserDefaults.standard.set(value, forKey: "fontSize")
        }
    }
    @objc func speedSliderValueChanged(speed:Float) -> Void {
        ledView.speed = CGFloat(speed)
        UserDefaults.standard.set(speed, forKey: "speed")

    }
    
}

