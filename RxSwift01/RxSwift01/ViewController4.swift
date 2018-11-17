//
//  ViewController4.swift
//  RxSwift01
//
//  Created by Lorwy on 2018/11/13.
//  Copyright © 2018 Lorwy. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

// Driver
/*（
 1）Driver 可以说是最复杂的 trait，它的目标是提供一种简便的方式在 UI 层编写响应式代码。

（2）如果我们的序列满足如下特征，就可以使用它：

- 不会产生 error 事件
- 一定在主线程监听（MainScheduler）
- 共享状态变化（shareReplayLatestWhileConnected）
 */

// 应用场景：
// - 通过 CoreData 模型驱动 UI
// - 使用一个 UI 元素值（绑定）来驱动另一个 UI 元素值

class ViewController4: UIViewController {
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var tableview: UITableView!
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        let results = textField.rx.text
//            .throttle(0.3, scheduler: MainScheduler.instance) //在主线程中操作，0.3秒内值若多次改变，取最后一次
//            .flatMapLatest { query in //筛选出空值, 拍平序列
////                fetchAutoCompleteItems(query) //向服务器请求一组结果
//        }
//        
//        //将返回的结果绑定到显示结果数量的label上
//        results
//            .map { "\($0.count)" }
//            .drive(label.rx.text) // 这里使用 drive 而不是 bindTo
//            .disposed(by: disposeBag)
//        
//        //将返回的结果绑定到tableView上
//        results
//            .drive(tableview.rx.items(cellIdentifier: "Cell")) { //  同样使用 drive 而不是 bindTo
//                (_, result, cell) in
//                cell.textLabel?.text = "\(result)"
//            }
//            .disposed(by: disposeBag)
    }
    
}
