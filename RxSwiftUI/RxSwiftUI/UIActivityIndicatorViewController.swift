//
//  UIActivityIndicatorViewController.swift
//  RxSwiftUI
//
//  Created by Lorwy on 2018/11/14.
//  Copyright © 2018 Lorwy. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa


class UIActivityIndicatorViewController : UIViewController {
    
    @IBOutlet weak var switch1: UISwitch!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var sliderValueLabel: UILabel!
    @IBOutlet weak var stepper: UIStepper!
    @IBOutlet weak var stepperLabel: UILabel!
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        switch1.rx.isOn.asObservable()
            .bind(to: indicator.rx.isAnimating)
            .disposed(by: disposeBag)
        
        
        switch1.rx.value
            .bind(to:UIApplication.shared.rx.isNetworkActivityIndicatorVisible)
            .disposed(by: disposeBag)
        
        slider.rx.value.asObservable()
            .map{ "当前值为：\($0)" }
            .bind(to: sliderValueLabel.rx.text)
            .disposed(by: disposeBag)
        
        stepper.rx.value.asObservable()
            .map{ "当前值为：\($0)" }
            .bind(to: stepperLabel.rx.text)
            .disposed(by: disposeBag)
    }
    
    
}
