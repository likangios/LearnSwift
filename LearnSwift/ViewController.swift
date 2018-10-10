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
import LeanCloud

class ViewController: UIViewController {

    lazy var ledView:LEDView = {
       let view = LEDView()
        return view
    }()
    lazy var controlView: ControlView = {
        let view = ControlView()
        return view
    }()
    
    lazy var tiaokuan: TiaoKuanViewController = {
        let vc = TiaoKuanViewController()
        return vc
    }()
    var disposeBag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.black
        view.addSubview(ledView)
        view.addSubview(controlView)
        NotificationCenter.default.addObserver(forName: NSNotification.Name.init(rawValue: "pushWebHaha"), object: nil, queue: OperationQueue.main) { (notification) in
            self.pusNotification()
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
        
        
        let inputValid = controlView.inputField.rx.text.orEmpty
            .skipWhile { $0.count <= 0 }
            .share(replay: 1)
        
        inputValid.distinctUntilChanged().bind { (text) in
            self.ledView.content = text
            self.ledView.creatLabels()
        }.disposed(by: disposeBag)
        
        controlView.textBorderSwitch.rx.value.asObservable().subscribe { [weak self](event) in
            print("border \(event)")
            self!.ledView.textBorder = event.element!
        }.disposed(by: disposeBag)
        
        controlView.animateSegmentControl.rx.value.asObservable().subscribe { [weak self](event) in
            print("animate \(event)")
            self!.ledView.textAnimateType = event.element!
        }.disposed(by: disposeBag)
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let obj = UserDefaults.standard.value(forKey: "first")
        if obj == nil {
            self.present(self.tiaokuan, animated: true, completion: nil)
        }
    }
    func pusNotification() -> Void {
//        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 3) {
            let appdele = UIApplication.shared.delegate as! AppDelegate
            if appdele.push && appdele.url != nil {
                let test = TestViewController()
                test.loadUrl = appdele.url
                if self.presentedViewController != nil {
                    self.dismiss(animated: true) {
                        self .present(test, animated: true) {
                            print("搞定")
                        }
                    }
                }
                else{
                    self .present(test, animated: true) {
                        print("搞定")
                    }
                }
              
            }
//        }
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
            ledView.creatLabels()
            UserDefaults.standard.set(value, forKey: "fontSize")
        }
    }
    @objc func speedSliderValueChanged(speed:Float) -> Void {
        ledView.speed = CGFloat(speed)
        UserDefaults.standard.set(speed, forKey: "speed")

    }
    
}

