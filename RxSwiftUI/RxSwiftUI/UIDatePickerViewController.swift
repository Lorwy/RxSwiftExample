//
//  UIDatePickerViewController.swift
//  RxSwiftUI
//
//  Created by Lorwy on 2018/11/15.
//  Copyright © 2018 Lorwy. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class UIDatePickerViewController: UIViewController {
    
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var datePicker2: UIDatePicker!
    @IBOutlet weak var startBtn: UIButton!
    
    let leftTime = BehaviorRelay<Double>(value:TimeInterval(180))
    let countDownStopped = BehaviorRelay<Bool>(value:true)
    
    // 日期格式化器
    lazy var dateFormatter : DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy年MM月dd日 HH:mm"
        return formatter
    }()
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        datePicker.rx.date
            .map { [weak self] in
                "当前选择时间：" + self!.dateFormatter.string(from: $0)
            }
            .bind(to: dateLabel.rx.text)
            .disposed(by: disposeBag)
        
        DispatchQueue.main.async {
            _ = self.datePicker2.rx.countDownDuration <-> self.leftTime
        }
        
        Observable.combineLatest(leftTime.asObservable(), countDownStopped.asObservable()) {
            leftTimeValue, countDownStoppedValue in
            if countDownStoppedValue {
                return "开始"
            } else {
                return "倒计时开始，还有 \(Int(leftTimeValue))秒..."
            }
        }.bind(to: startBtn.rx.title())
        .disposed(by: disposeBag)
        
        startBtn.rx.tap.bind { [weak self] in
            self?.startClicked()
        }.disposed(by: disposeBag)
    }
    
    func startClicked() {
        self.countDownStopped.accept(false)
        
        Observable<Int>.interval(1, scheduler: MainScheduler.instance)
        .takeUntil(countDownStopped.asObservable().filter{$0})
            .subscribe{ event in
                // 每次剩余时间减1
                self.leftTime.accept(self.leftTime.value - 1)
                if(self.leftTime.value == 0) {
                    print("倒计时结束！")
                    self.countDownStopped.accept(true)
                    self.leftTime.accept(180)
                }
        }.disposed(by: disposeBag)
    }
    
    
}
