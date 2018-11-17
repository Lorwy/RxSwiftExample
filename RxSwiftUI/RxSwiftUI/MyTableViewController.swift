//
//  MyTableViewController.swift
//  RxSwiftUI
//
//  Created by Lorwy on 2018/11/15.
//  Copyright © 2018 Lorwy. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa


class MyTableViewController: UIViewController {
    
    @IBOutlet weak var tableview: UITableView!
    let disposeBag = DisposeBag()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let items = Observable.just([
            "文本输入框的用法",
            "开关按钮的用法",
            "进度条的用法",
            "文本标签的用法",
            ])
        items.bind(to: tableview.rx.items){ (tableView, row , element) in
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
            cell.textLabel?.text = "\(row): \(element)"
            return cell
            }.disposed(by: disposeBag)
        
        
        tableview.rx.itemSelected.subscribe(onNext: { indexPath in
            print("选中项的indexPath为：\(indexPath)")
        }).disposed(by: disposeBag)
        
        tableview.rx.modelSelected(String.self).subscribe(onNext: { item in
            print("选中项的标题为：\(item)")
        }).disposed(by: disposeBag)
        
        //获取被取消选中项的索引
        tableview.rx.itemDeselected.subscribe(onNext: { indexPath in
            print("被取消选中项的indexPath为：\(indexPath)")
        }).disposed(by: disposeBag)
        
        //获取被取消选中项的内容
        tableview.rx.modelDeselected(String.self).subscribe(onNext: { item in
            print("被取消选中项的的标题为：\(item)")
        }).disposed(by: disposeBag)
        
        tableview.rx.itemMoved.subscribe(onNext: {
            sourceIndexPath, destinationIndexPath in
            print("移动项原来的indexPath为：\(sourceIndexPath)")
            print("移动项现在的indexPath为：\(destinationIndexPath)")
        }).disposed(by: disposeBag)
        
        tableview.rx.itemInserted.subscribe(onNext: { indexPath in
            print("插入项的indexPath为：\(indexPath)")
        }).disposed(by: disposeBag)
        
        tableview.rx.itemAccessoryButtonTapped.subscribe(onNext: { indexPath in
            print("尾部项的indexPath为：\(indexPath)")
        }).disposed(by: disposeBag)
    }
}
