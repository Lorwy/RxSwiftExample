//
//  ViewController.swift
//  RxSwiftUI
//
//  Created by Lorwy on 2018/11/14.
//  Copyright © 2018 Lorwy. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ViewController: UIViewController {
    
    let disposeBag = DisposeBag()

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // 初始化数据
        let items = Observable.just([
                ItemModel.init(action: "UILabelViewController", value: "UILabel"),
                ItemModel.init(action: "UITextFieldViewController", value: "UITextField+UITextView"),
                ItemModel.init(action: "UIButtonViewController", value: "UIButton+UIBarButtonItem"),
                ItemModel.init(action: "UISwitchViewController", value: "UISwitch+UISegmentedControl"),
                ItemModel.init(action: "UIActivityIndicatorViewController", value: "UIActivityIndicatorView+UISlider+UIStepper"),
                ItemModel.init(action: "TwoWayBindingViewController", value: "双向绑定"),
                ItemModel.init(action: "UIGestureRecognizerViewController", value: "UIGestureRecognizer"),
                ItemModel.init(action: "UIDatePickerViewController", value: "UIDatePicker"),
                ItemModel.init(action: "MyTableViewController", value: "tableView基本用法"),
                ItemModel.init(action: "RxDataSourcesViewController", value: "RxDataSources"),
                ItemModel.init(action: "RefreshDataViewController", value: "刷新数据+搜索过滤"),
            ])
        
        // 设置单元格数据
        items.bind(to: tableView.rx.items){ (tableView, row, element) in
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")!
            cell.textLabel?.text = "\(row+1). \(element.value!)"
            return cell
        }.disposed(by: disposeBag)
        
        // 获取选中索引
        tableView.rx.itemSelected.subscribe(onNext: { indexPath in
            print("选中项的indexpath为：\(indexPath)")
        }).disposed(by: disposeBag)
        
        // 获取选中项的内容
        tableView.rx.modelSelected(ItemModel.self).subscribe(onNext:{ item in
            print("选中项的标题为：\(item.value!)")
            self.performSegue(withIdentifier: item.action!, sender: item.value)
        }).disposed(by: disposeBag)
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        segue.destination.title = sender as! String?
    }
}

class ItemModel {
    var action : String!
    var value : String!
    init(action: String!, value: String!) {
        self.action = action
        self.value = value
    }
}
