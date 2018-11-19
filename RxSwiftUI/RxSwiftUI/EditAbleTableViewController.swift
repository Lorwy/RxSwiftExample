//
//  EditAbleTableViewController.swift
//  RxSwiftUI
//
//  Created by Lorwy on 2018/11/17.
//  Copyright © 2018 Lorwy. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

// 定义各种操作命令
enum TableEditingCommand {
    case setItems(items: [String]) // 设置表格数据
    case addItem(item: String) // 新增数据
    case moveItem(from: IndexPath, to: IndexPath) // 移动数据
    case deleteItem(IndexPath) // 删除数据
}

// 定义表格对应的ViewModel
struct TableViewModel {
    // 表格数据项
    fileprivate var items: [String]
    
    init(items: [String] = []) {
        self.items = items
    }
    
    // 执行相应的命令，并返回最终的结果
    func execute(command: TableEditingCommand) -> TableViewModel {
        switch command {
        case .setItems(let items):
            print("设置表格数据")
            return TableViewModel(items: items)
        case .addItem(let item) :
            print("新增数据")
            var items = self.items
            items.append(item)
            return TableViewModel(items: items)
        case .moveItem(let from, let to):
            print("移动数据项目")
            var items = self.items
            items.insert(items.remove(at: from.row), at: to.row)
            return TableViewModel(items: items)
        case .deleteItem(let indexPath):
            print("删除x数据项")
            var items = self.items
            items.remove(at: indexPath.row)
            return TableViewModel(items: items)
            
        }
    }
}

class EditAbleTableViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var refreshButton: UIBarButtonItem!
    @IBOutlet weak var addButton: UIBarButtonItem!
    @IBOutlet weak var editButton: UISwitch!
    
    
    let disposeBag = DisposeBag()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let initialVM = TableViewModel()
        
        // 刷新数据命令
        let refreshCommand = refreshButton.rx.tap.asObservable()
            .startWith(()) // 页面初始话的时候加载一次数据
            .flatMap(getRandomResult)
            .map(TableEditingCommand.setItems)
        
        // 新增条目命令
        let addCommand = addButton.rx.tap.asObservable()
            .map{ "\(arc4random())" }
            .map(TableEditingCommand.addItem)
        
        // 启用编辑状态
        editButton.rx.isOn.asObservable()
            .bind(to: tableView.rx.isEditAble)
            .disposed(by: disposeBag)
        
        
        // 移动命令
        let movedCommand = tableView.rx.itemMoved
            .map(TableEditingCommand.moveItem)
        
        // 删除命令
        let deleteCOmmand = tableView.rx.itemDeleted
            .map(TableEditingCommand.deleteItem)
        
        // 绑定单元格数据
        Observable.of(refreshCommand, addCommand, movedCommand, deleteCOmmand)
            .merge()
            .scan(initialVM) { (vm: TableViewModel, command: TableEditingCommand)
                -> TableViewModel in
                return vm.execute(command: command)
            }
            .startWith(initialVM)
            .map{
                [AnimatableSectionModel(model: "", items: $0.items)]
            }
            .share(replay:1)
            .bind(to: tableView.rx.items(dataSource: ViewController.dataSource()))
            .disposed(by: disposeBag)
    }
    
    // 获取随机数据
    func getRandomResult() -> Observable<[String]> {
        print("生成随机数据")
        let items = (0 ..< 5).map { _ in
            "\(arc4random())"
        }
        return Observable.just(items)
    }
    
}


extension ViewController {
    // 创建表格数据源
    static func dataSource() -> RxTableViewSectionedAnimatedDataSource<AnimatableSectionModel<String,String>> {
        return RxTableViewSectionedAnimatedDataSource(
            // 设置插入、删除、移动单元格的动画效果
            animationConfiguration: AnimationConfiguration(insertAnimation: .top, reloadAnimation: .fade, deleteAnimation: .left),
            configureCell: {
                (dataSource, tv, indexPath, element) in
                let cell = tv.dequeueReusableCell(withIdentifier: "cell")!
                cell.textLabel?.text = "条目\(indexPath.row): \(element)"
                return cell
        },
            canEditRowAtIndexPath:{_ , _ in
                return true
        },
            canMoveRowAtIndexPath: {_ , _ in
                return true
        }
        )
    }
}


extension Reactive where Base : UITableView {
    public var isEditAble: Binder<Bool> {
        return Binder(self.base) { tablview , isEditAble in
            tablview.setEditing(isEditAble, animated: true)
            
        }
    }
}
