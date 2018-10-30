//
//  ViewController1.swift
//  RxSwift01
//
//  Created by Lorwy on 2018/10/30.
//  Copyright © 2018 Lorwy. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ViewController1: UIViewController {
    
    
    @IBOutlet weak var label: UILabel!
    
    // 回收的垃圾袋
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        
        // Observable 序列（没隔1秒钟发出一个索引数）
        /*
        let observable = Observable<Int>.interval(1
            , scheduler: MainScheduler.instance)
        
        observable.map({"当前索引数: \($0)"})
            .bind { [weak self] (text) in
                // 收到发出的索引数后显示到label上
                self?.label.text = text
        }.disposed(by: disposeBag)
        */
        
        //#########################################
        // 使用bindTo方法
        /*
        // 观察者
        let observer: AnyObserver<String> = AnyObserver { [weak self] event in
            switch event {
            case .next(let text):
                // 收到发出来的索引数后显示z到label上
                self?.label.text = text
            default:
                break
            }
        }
        // Observable 序列每隔一秒钟 发出一个索引数
        let observable1 = Observable<Int>.interval(1, scheduler: MainScheduler.instance)
        observable1.map({"当前索引数: \($0)"})
        .bind(to: observer)
        .disposed(by: disposeBag)
         */
        
        //####################使用Binder创建观察者#####################
        // 这里用Binder是最好的方式
        // 观察者
        let observer2: Binder<String> = Binder(label) { (view, text) in
            view.text = text
        }
        // Observable 序列
        let observable2 = Observable<Int>.interval(1, scheduler: MainScheduler.instance)
        observable2
        .map({ "当前索引数：\($0)" })
        .bind(to: observer2)
        .disposed(by: disposeBag)
    }
    
    deinit {
        print("deinit")
    }
}
