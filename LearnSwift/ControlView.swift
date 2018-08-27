//
//  ControlView.swift
//  LearnSwift
//
//  Created by perfay on 2018/8/22.
//  Copyright © 2018年 luck. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

class ControlView: UIControl ,UIScrollViewDelegate{
    
    lazy var speedSlider: SliderView = {
        let spview = SliderView.init(frame: CGRect.zero, Title: "速 度", sdMinValue: 0, sdMaxValue: 20, sdTintColor: UIColor.purple)
        return spview
    }()
    lazy var fontSlider: SliderView = {
        let spview = SliderView.init(frame: CGRect.zero, Title: "大 小", sdMinValue: 50, sdMaxValue: 300, sdTintColor: UIColor.purple)
        return spview
    }()
    
    lazy var greenSlider: SliderView = {
        let spview = SliderView.init(frame: CGRect.zero, Title: "绿 色", sdMinValue: 0, sdMaxValue: 1, sdTintColor: UIColor.green)
        return spview
    }()
    lazy var redSlider: SliderView = {
        let spview = SliderView.init(frame: CGRect.zero, Title: "红 色", sdMinValue: 0, sdMaxValue: 1, sdTintColor: UIColor.red)
        return spview
    }()
    lazy var blueSlider: SliderView = {
        let spview = SliderView.init(frame: CGRect.zero, Title: "蓝 色", sdMinValue: 0, sdMaxValue: 1, sdTintColor: UIColor.blue)
        return spview
    }()
    var disposeBag = DisposeBag()
    var colorObserable = PublishSubject<UIColor>()

    lazy var mainView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        view.layer.borderWidth = 0.5
        view.layer.borderColor = UIColor.white.cgColor
        return view
    }()
    lazy var scrollView: UIScrollView = {
        let sc = UIScrollView()
        sc.isPagingEnabled = true
        sc.delegate = self as UIScrollViewDelegate
        sc.bouncesZoom = false
        return sc
    }()
    lazy var segmentControl: UISegmentedControl = {
        let segment = UISegmentedControl.init(items: ["字体","背景"])
        segment.backgroundColor = UIColor.clear
        segment.layer.borderColor = mainColor.cgColor
        segment.layer.borderWidth = 1.0
        segment.layer.cornerRadius = 17.5
        segment.layer.masksToBounds = true
        return segment
    }()
    lazy var pageControl: UIPageControl = {
        let pg = UIPageControl()
        pg.numberOfPages = 3
        pg.tintColor = mainColor
        return pg
    }()
    lazy var bottomView: UIView = {
        let view = UIView()
        return view
    }()
    private var scrollSubViewL:UIView?
    private var scrollSubViewC:UIView?
    private var scrollSubViewR:UIView?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.rx.controlEvent(.touchUpInside).subscribe { (event) in
            print("control tap \(event)")
            self.hiddenMainView(animate: true)
        }.disposed(by: disposeBag)
        creatSubView()

        Observable.combineLatest(greenSlider.obserable, redSlider.obserable, blueSlider.obserable) { (g_value, red_value, blue_value) ->UIColor in
            UserDefaults.standard.set(red_value, forKey: "color_r")
            UserDefaults.standard.set(g_value, forKey: "color_g")
            UserDefaults.standard.set(blue_value, forKey: "color_b")
            return UIColor.init(red: CGFloat(red_value), green: CGFloat(g_value), blue: CGFloat(blue_value), alpha: 1.0)
            }.bind(to: colorObserable).disposed(by: disposeBag)
        
//        let subject1 = PublishSubject<Int>()
//        let subject2 = PublishSubject<String>()
//
//        Observable.combineLatest(subject1, subject2) {
//            "\($0)\($1)"
//            }
//            .subscribe(onNext: { print($0) })
//            .disposed(by: disposeBag)

        self.scrollView.rx.didEndDecelerating.subscribe { (event) in
            self.pageControl.currentPage = Int(self.scrollView.contentOffset.x/self.scrollView.frame.width)
        }.disposed(by: disposeBag)
        segmentControl.rx.selectedSegmentIndex.subscribe { (event) in
            print(event)
        }.disposed(by: disposeBag)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
extension ControlView {
    func hiddenMainView(animate:Bool) -> Void {
        if animate == true {
            UIView.animate(withDuration: 0.25, animations: {
                self.mainView.transform = CGAffineTransform.init(translationX: 0, y: UIScreen.main.bounds.height * 0.3)
            }) { (finish) in
                self.isHidden = true
            }
        }
        else{
            self.isHidden = true
            self.mainView.transform = CGAffineTransform.init(translationX: 0, y: UIScreen.main.bounds.height * 0.3)
        }
    }
    func showMainView(animate:Bool) -> Void {
        if animate == true {
            UIView.animate(withDuration: 0.25) {
                self.isHidden = false
                self.mainView.transform = CGAffineTransform.identity
            }
        }
        else{
                self.isHidden = false
               self.mainView.transform = CGAffineTransform.identity
        }
        
        
    }
    func creatSubView() -> Void {
        addSubview(mainView)
        mainView.addSubview(scrollView)
        mainView.addSubview(pageControl)
        mainView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.3)
        }
        scrollView.snp.makeConstraints { (make) in
            make.left.right.top.equalToSuperview()
            make.bottom.equalTo(-30)
        }
        pageControl.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(-10)
        }
        var lastView:UIView?
        for index in 1...3 {
            let view = UIView()
            scrollView.addSubview(view)
            view.snp.makeConstraints { (make) in
                make.top.bottom.equalToSuperview()
                make.centerY.equalToSuperview()
                make.width.equalTo(mainView)
                if lastView === nil {
                    make.left.equalToSuperview()
                }
                else{
                    make.left.equalTo(lastView!.snp.right)
                }
            }
            lastView = view
            switch index {
            case 1:
                creatTextControlView(view)
                break
            case 2:
                creatColorControlView(view)
                break
            case 3:
                creatAnimateControlView(view)
                break
            default:
                break
                
            }
            
        }
        lastView!.snp.makeConstraints({ (make) in
            make.right.equalToSuperview()
        })
        
    }
    func creatTextControlView( _ view:UIView) -> Void {
        view.addSubview(speedSlider)
        view.addSubview(fontSlider)

        speedSlider.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(10)
            make.height.equalTo(30)
        }
        fontSlider.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(speedSlider.snp.bottom).offset(5)
            make.height.equalTo(30)
        }
    }
    func creatColorControlView(_ view:UIView) -> Void {
        view.addSubview(segmentControl)
        view.addSubview(blueSlider)
        view.addSubview(greenSlider)
        view.addSubview(redSlider)
        blueSlider.slider.value = UserDefaults.standard.value(forKey: "color_b") as! Float
        greenSlider.slider.value = UserDefaults.standard.value(forKey: "color_g") as! Float
        redSlider.slider.value = UserDefaults.standard.value(forKey: "color_b") as! Float
        
        segmentControl.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(5)
            make.size.equalTo(CGSize(width: 120, height: 35))
        }
        blueSlider.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(segmentControl.snp.bottom).offset(15)
            make.height.equalTo(30)
        }
        greenSlider.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(blueSlider.snp.bottom).offset(5)
            make.height.equalTo(30)
        }
        redSlider.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(greenSlider.snp.bottom).offset(5)
            make.height.equalTo(30)
        }
    }
    func creatAnimateControlView(_ view:UIView) -> Void {
        let v = UIView()
        v.backgroundColor = UIColor.orange
        view.addSubview(v)
        v.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
}
