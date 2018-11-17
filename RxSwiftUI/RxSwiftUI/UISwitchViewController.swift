//
//  UISwitchViewController.swift
//  RxSwiftUI
//
//  Created by Lorwy on 2018/11/14.
//  Copyright © 2018 Lorwy. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class UISwitchViewController: UIViewController {
    
    
    @IBOutlet weak var switch1: UISwitch!
    @IBOutlet weak var btn1: UIButton!
    @IBOutlet weak var switchStatusLabel: UILabel!
    
    @IBOutlet weak var segment: UISegmentedControl!
    @IBOutlet weak var segmentStatusLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 1，UISwitch（开关按钮）

        switch1.rx.isOn.asObservable()
            .map{
                "当前开关状态：\($0)"
            }
            .bind(to: switchStatusLabel.rx.text)
            .disposed(by: disposeBag)
        
        switch1.rx.isOn
            .bind(to: btn1.rx.isEnabled)
            .disposed(by: disposeBag)
        
        // 2，UISegmentedControl（分段选择控件）
        segment.rx.selectedSegmentIndex.asObservable()
            .map{"当前项：\($0)"}
            .bind(to: segmentStatusLabel.rx.text)
            .disposed(by: disposeBag)
        
        let showImageObservable: Observable<UIColor> = segment.rx.selectedSegmentIndex.asObservable().map {
            let color = [UIColor.red, UIColor.orange, UIColor.gray]
            return color[$0]
        }
        
        showImageObservable.bind(to: imageView.rx.bgColor)
            .disposed(by: disposeBag)
                
    }
}

extension Reactive where Base: UIImageView {
    public var bgColor: Binder<UIColor> {
        return Binder(self.base) { imageview , bgColor in
            imageview.backgroundColor = bgColor
        }
    }
}
