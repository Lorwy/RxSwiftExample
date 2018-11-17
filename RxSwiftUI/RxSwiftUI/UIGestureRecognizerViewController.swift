//
//  UIGestureRecognizerViewController.swift
//  RxSwiftUI
//
//  Created by Lorwy on 2018/11/15.
//  Copyright © 2018 Lorwy. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa


class UIGestureRecognizerViewController: UIViewController {
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let swipe = UISwipeGestureRecognizer()
        swipe.direction = .up
        self.view.addGestureRecognizer(swipe)
        
        // 手势响应
//        swipe.rx.event
//            .subscribe(onNext: {[weak self] recognizer in
//                // 滑动起点
//                let point = recognizer.location(in: recognizer.view)
//                self?.showAlert(title: "向上滑动", message: "\(point.x) \(point.y)")
//            } )
//            .disposed(by: disposeBag)
        
        // 第二种响应方法
        swipe.rx.event
            .bind { [weak self] recognizer in
                let point = recognizer.location(in: recognizer.view)
                self?.showAlert(title: "向上滑动", message: "\(point.x) \(point.y)")
            }.disposed(by: disposeBag)
    }
    
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "确定", style: .cancel))
        self.present(alert, animated: true)
    }
    
}
