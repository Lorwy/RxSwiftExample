//
//  UILabelViewController.swift
//  RxSwiftUI
//
//  Created by Lorwy on 2018/11/14.
//  Copyright © 2018 Lorwy. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class UILabelViewController: UIViewController {
    
    @IBOutlet weak var label: UILabel!
    
    @IBOutlet weak var lablel2: UILabel!
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // 将数据绑定到text属性上（普通文本）
        let timer = Observable<Int>.interval(0.1, scheduler: MainScheduler.instance)
        
        // 将时间格式化成字符串绑定到label上
        timer.map{
            String(format: "%0.2d:%0.2d.%0.1d", arguments:[($0 / 600) % 600, ($0 % 600 ) / 10, $0 % 10])
        }
        .bind(to: label.rx.text)
        .disposed(by: disposeBag)
        
        // 设置富文本
        timer.map(formatTimeInterval)
        .bind(to: lablel2.rx.attributedText)
        .disposed(by: disposeBag)
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
