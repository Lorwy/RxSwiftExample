//
//  UITextFieldViewController.swift
//  RxSwiftUI
//
//  Created by Lorwy on 2018/11/14.
//  Copyright © 2018 Lorwy. All rights reserved.
//


import UIKit
import RxSwift
import RxCocoa

class UITextFieldViewController: UIViewController {
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var textField2: UITextField!
    @IBOutlet weak var charCountLabel: UILabel!
    @IBOutlet weak var submitBtn: UIButton!
    
    
    @IBOutlet weak var num1TextField: UITextField!
    @IBOutlet weak var num2TextField: UITextField!
    @IBOutlet weak var outputNumLabel: UILabel!
    
    @IBOutlet weak var textView: UITextView!
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
// 1，监听单个 textField 内容的变化（textView 同理）
        
//        textField.rx.text.orEmpty.asObservable()
//            .subscribe(onNext: {
//                print("您输入的是：\($0)")
//            })
//            .disposed(by: disposeBag)
        
        // 用change事件跟上面一样的效果
//        textField.rx.text.orEmpty.changed
//            .subscribe(onNext: {
//                print("您输入的是：\($0)")
//            })
//            .disposed(by: disposeBag)
        
        
// 2，将内容绑定到其他控件上
        // 当文本框内容改变
        let input = textField.rx.text.orEmpty.asDriver()  // 将普通序列转换为 Driver
            .throttle(0.3) // 在主线程中操作，0.3秒内值若多次改变，取最后一次
        
        // 内容绑定到另一个输入框中
        input.drive(textField2.rx.text)
            .disposed(by: disposeBag)
        
        // 内容绑定到label上
        input.map{
                "当前字数: \($0.count)"
            }.drive(charCountLabel.rx.text)
            .disposed(by: disposeBag)
        
        // 根据内容字数决定按钮是否可用
        input.map({ $0.count > 5})
            .drive(submitBtn.rx.isEnabled)
            .disposed(by: disposeBag)
        
        
// 3.同时监听多个 textField 内容的变化（textView 同理）
        Observable.combineLatest(num1TextField.rx.text.orEmpty,
                                 num2TextField.rx.text.orEmpty) {
                                    textValue1, textValue2 -> String in
                                    return "您输入的号码是：\(textValue1)-\(textValue2)"
        }
        .map({$0})
        .bind(to: outputNumLabel.rx.text)
        .disposed(by: disposeBag)
        
// 4，事件监听
        /*
         editingDidBegin：开始编辑（开始输入内容）
         editingChanged：输入内容发生改变
         editingDidEnd：结束编辑
         editingDidEndOnExit：按下 return 键结束编辑
         allEditingEvents：包含前面的所有编辑相关事件
         */
        // 在num1按下return键时自动到num2
        num1TextField.rx.controlEvent(.editingDidEndOnExit).subscribe(onNext: {
            [weak self] (_) in
            self?.num2TextField.becomeFirstResponder()
        }).disposed(by: disposeBag)
        // 在num2按下return键就收起键盘
        num2TextField.rx.controlEvent(.editingDidEndOnExit).subscribe(onNext:{
            [weak self] (_) in
            self?.num2TextField.resignFirstResponder()
        }).disposed(by: disposeBag)
        
        
// 5. 附：UITextView 独有的方法

        /*
         didBeginEditing：开始编辑
         didEndEditing：结束编辑
         didChange：编辑内容发生改变
         didChangeSelection：选中部分发生变化
         */
        
        textView.rx.didBeginEditing
            .subscribe(onNext: {
                print("开始编辑")
            }).disposed(by: disposeBag)
        
        textView.rx.didEndEditing
            .subscribe(onNext: {
                print("结束编辑")
            }).disposed(by: disposeBag)
        
        textView.rx.didChange
            .subscribe(onNext: {
                print("内容发生改变")
            }).disposed(by: disposeBag)
        
        textView.rx.didChangeSelection
            .subscribe(onNext: {
                print("选中部分发生变化")
            }).disposed(by: disposeBag)

    }
    
    
}
