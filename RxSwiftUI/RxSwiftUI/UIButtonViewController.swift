//
//  UIButtonViewController.swift
//  RxSwiftUI
//
//  Created by Lorwy on 2018/11/14.
//  Copyright © 2018 Lorwy. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class UIButtonViewController: UIViewController {
    
    @IBOutlet weak var btn1: UIButton!
    @IBOutlet weak var btn2: UIButton!
    @IBOutlet weak var btn3: UIButton!
    @IBOutlet weak var switch1: UISwitch!
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
// 1，按钮点击响应
        
//        btn1.rx.tap
//            .subscribe(onNext: {
//                [weak self] in
//                self?.showMessage("按钮被点击了")
//            })
//            .disposed(by: disposeBag)
        
        btn1.rx.tap
            .bind {
                [weak self] in
                self?.showMessage("按钮被点击了")
            }
            .disposed(by: disposeBag)
        
        
// 2，按钮标题（title）的绑定
        let timer = Observable<Int>.interval(1, scheduler: MainScheduler.instance)
        
//        timer.map{"计数\($0)"}
//          .bind(to: btn1.rx.title(for: .normal))
//          .disposed(by: disposeBag)
        
// 3，按钮富文本标题（attributedTitle）的绑定
        
//        timer.map(formatTimeInterval)
//            .bind(to: btn1.rx.attributedTitle())
//            .disposed(by: disposeBag)
        
// 4，按钮图标（image）的绑定
        //根据索引数选择对应的按钮图标，并绑定到button上
//        timer.map({
//            let name = $0%2 == 0 ? "back" : "forward"
//            return UIImage(named: name)!
//            })
//            .bind(to: btn1.rx.image())
//            .disposed(by: disposeBag)

        
// 5，按钮背景图片（backgroundImage）的绑定
        //根据索引数选择对应的按钮背景图，并绑定到button上
//        timer.map{ UIImage(named: "\($0%2)")! }
//            .bind(to: button.rx.backgroundImage())
//            .disposed(by: disposeBag)

        
// 6，按钮是否可用（isEnabled）的绑定

        switch1.rx.isOn
        .bind(to: btn1.rx.isEnabled)
        .disposed(by: disposeBag)
        
        
// 7，按钮是否选中（isSelected）的绑定
        
        btn1.isEnabled = true
        
        // 强制解包，避免后面需要处理可选类型
        let btns = [btn1, btn2, btn3].map{$0!}
        
        //创建一个可观察序列，它可以发送最后一次点击的按钮（也就是我们需要选中的按钮）
        let selectedButton = Observable.from(btns.map{ btn in
            btn.rx.tap.map{ btn }
        }).merge()
        
        for btn in btns {
            selectedButton.map{ $0 == btn }
                .bind(to: btn.rx.isSelected)
                .disposed(by: disposeBag)
        }

    }
    
    func showMessage(_ text: String) {
        let alertController = UIAlertController(title: text, message: nil, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "确定", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    // 将数字转成对应的富文本
    func formatTimeInterval(ms: NSInteger) -> NSMutableAttributedString {
        let string = String(format: "%0.2d:%0.2d.%0.1d", arguments: [(ms / 600) % 600, (ms % 600 ) / 10, ms % 10])
        let attributeString = NSMutableAttributedString(string: string)
        attributeString.addAttribute(NSAttributedString.Key.font,
                                     value: UIFont(name: "HelveticaNeue-Bold", size: 28)!,
                                     range: NSMakeRange(0, 5))
        attributeString.addAttribute(NSAttributedString.Key.foregroundColor,
                                     value: UIColor.white,
                                     range: NSMakeRange(0, 5))
        
        attributeString.addAttribute(NSAttributedString.Key.backgroundColor,
                                     value: UIColor.gray,
                                     range: NSMakeRange(0, 5))
        return attributeString
    }
    
}
