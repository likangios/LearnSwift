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
    var disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.black
        view.addSubview(ledView)
        view.addSubview(controlView)
        controlView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        ledView.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.size.equalTo(CGSize(width: view.frame.height, height: view.frame.width))
        }
        ledView.transform = CGAffineTransform.init(rotationAngle: CGFloat(Double.pi)/2.0)
        ledView.speed = 3
        ledView.space = 100
        ledView.fontSize = 150
        ledView.content = "答复；萨芬贾师傅阿萨德了富士达；了发送到"
        controlView.speedSlider.obserable.subscribe({ (event) in
            self.speedSliderValueChanged(speed: event.element!)
        }).disposed(by: disposeBag)
        
        controlView.fontSlider.obserable.debounce(1, scheduler: MainScheduler.instance).subscribe { (event) in
            self.changedFont(value: event.element!)
        }.disposed(by: disposeBag)
        
        controlView.colorObserable.debounce(0.5, scheduler: MainScheduler.instance).subscribe { (event) in
            print(event)
            self.ledView.fontColor = event.element!
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
    @objc func fontSliderValueChanged(font:Float) -> Void {
    NSObject.cancelPreviousPerformRequests(withTarget: self)
        print("font si \(font)")
    self.perform(#selector(changedFont(value:)), with: 200, afterDelay: 1)
    }
    @objc func changedFont(value:Float) -> Void {
        if value > 0.0 {
            ledView.fontSize = CGFloat(value)
        }
    }
    @objc func speedSliderValueChanged(speed:Float) -> Void {
        ledView.speed = CGFloat(speed)
        UserDefaults.standard.set(speed, forKey: "speed")

    }
    
}
