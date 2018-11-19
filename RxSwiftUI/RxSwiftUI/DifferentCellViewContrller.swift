//
//  DifferentCellViewContrller.swift
//  RxSwiftUI
//
//  Created by Lorwy on 2018/11/19.
//  Copyright © 2018 Lorwy. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

class DifferentCellViewContrller: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    let disposeBag = DisposeBag()
    
    var dataSource: RxTableViewSectionedReloadDataSource<MySection1>?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 初始化数据
        let sections = Observable.just([
            MySection1(header: "我是第一个分区", items: [
                .TitleImageSectionItem(title: "图片数据1", color: UIColor.red),
                .TitleImageSectionItem(title: "图片数据2", color: UIColor.orange),
                .TitleSwitchSectionItem(title: "开关数据1", enabled: true)
                ]),
            MySection1(header: "我是第二个分区", items: [
                .TitleSwitchSectionItem(title: "开关数据2", enabled: false),
                .TitleSwitchSectionItem(title: "开关数据3", enabled: false),
                .TitleImageSectionItem(title: "图片数据3", color: UIColor.brown)
                ])
            ])
        
        //创建数据源
        let dataSource = RxTableViewSectionedReloadDataSource<MySection1>(
            // 设置单元格
            configureCell: { (dataSource, tableView, indexPath, item) -> UITableViewCell in
                switch dataSource[indexPath] {
                case let .TitleImageSectionItem(title, color):
                    let cell = tableView.dequeueReusableCell(withIdentifier: "titleImageCell", for: indexPath)
                    (cell.viewWithTag(1) as! UILabel).text = title
                    (cell.viewWithTag(2) as! UIImageView).backgroundColor  = color
                    return cell
                    
                case let .TitleSwitchSectionItem(title, enabled):
                    let cell = tableView.dequeueReusableCell(withIdentifier: "titleSwitchCell", for: indexPath)
                    (cell.viewWithTag(1) as! UILabel).text = title
                    (cell.viewWithTag(2) as! UISwitch).isOn  = enabled
                    return cell
                }
            },
//            // 设置分区头部标题
//            titleForHeaderInSection: { ds, index in
//                return ds.sectionModels[index].header
//            }
            
            titleForFooterInSection: { ds, index in
                return "共有\(ds.sectionModels[index].items.count)个数据"
            }
        )
        
        self.dataSource = dataSource
        
        // 绑定单元格数据
        sections.bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        // 设置代理
        tableView.rx.setDelegate(self)
            .disposed(by: disposeBag)
    }
    
}

extension DifferentCellViewContrller : UITableViewDelegate {
    // 设置单元格高度
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let _ = dataSource?[indexPath],
        let _ = dataSource?[indexPath.section]
            else {
            return 0.0
        }
        return 60
    }
    
    // 返回分区头部视图
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.black
        let titleLabel = UILabel()
        titleLabel.text = self.dataSource?[section].header
        titleLabel.textColor = UIColor.white
        titleLabel.sizeToFit()
        titleLabel.center = CGPoint(x: self.view.frame.width / 2, y: 20)
        headerView.addSubview(titleLabel)
        
        return headerView
    }
    
    // 分区头部高度
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
}


enum SectionItem {
    case TitleImageSectionItem(title: String, color: UIColor)
    case TitleSwitchSectionItem(title: String, enabled: Bool)
}

struct MySection1 {
    var header: String
    var items: [SectionItem]
}

extension MySection1 : SectionModelType {
    typealias Item = SectionItem
    
    init(original: MySection1, items: [Item]) {
        self = original
        self.items = items
    }
}
