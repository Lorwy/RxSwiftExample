//
//  TwoWayBindingViewController.swift
//  RxSwiftUI
//
//  Created by Lorwy on 2018/11/14.
//  Copyright © 2018 Lorwy. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa


class TwoWayBindingViewController: UIViewController {
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var resultLabel: UILabel!
    
    var userVM = UserViewModel()
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 双向绑定
//        userVM.username.asObservable()
//            .bind(to: textField.rx.text)
//            .disposed(by: disposeBag)
//
//        textField.rx.text.orEmpty
//            .bind(to: userVM.username)
//            .disposed(by: disposeBag)
        
        // 使用操作符来双向绑定
        _ = self.textField.rx.textInput <->  self.userVM.username
        
        textField.rx.value.asObservable()
            .bind(to: resultLabel.rx.text)
            .disposed(by: disposeBag)
        
//        userVM.getUserInfo()
//            .bind(to: resultLabel.rx.text)
//            .disposed(by: disposeBag)
    }
    
}
