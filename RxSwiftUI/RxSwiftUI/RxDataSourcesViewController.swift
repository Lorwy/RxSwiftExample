//
//  RxDataSourcesViewController.swift
//  RxSwiftUI
//
//  Created by Lorwy on 2018/11/16.
//  Copyright © 2018 Lorwy. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

class RxDataSourcesViewController: UIViewController, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self;
        
        // 方式一：使用自带的Section
        /*let items = Observable.just([
            SectionModel(model: "1", items: [
                "UILable的用法",
                "UIText的用法",
                "UIButton的用法"
                ]),
            SectionModel(model: "2", items: [
                "UILable的用法",
                "UIText的用法",
                "UIButton的用法"
                ])
            ])
        
        let dataSource = RxTableViewSectionedReloadDataSource
            <SectionModel<String, String>>(configureCell: {
                (dataSource, tv, indexPath, element) in
                let cell = tv.dequeueReusableCell(withIdentifier: "cell")!
                cell.textLabel?.text = "\(indexPath.row): \(element)"
                return cell
            })
        
        items.bind(to: tableView.rx.items(dataSource: dataSource))
        .disposed(by: disposeBag)*/
        
        // 方式二：使用自定义的Section
        
        let sections = Observable.just([
            MySection(header: "基本控件", items: [
                "UILable的用法",
                "UIText的用法",
                "UIButton的用法"
                ]),
            MySection(header: "高级控件", items: [
                "UITableView的用法",
                "UICollectionViews的用法"
                ])
            ])
        
        let dataSource = RxTableViewSectionedAnimatedDataSource<MySection>(
            configureCell: { (ds, tv, ip, item) -> UITableViewCell in
                let cell = tv.dequeueReusableCell(withIdentifier: "cell")
                    ?? UITableViewCell(style: .default, reuseIdentifier: "cell")
                cell.textLabel?.text = "\(ip.row): \(item)"
                return cell
            }
        )
        
        dataSource.titleForHeaderInSection = {
            ds, index in
            return ds.sectionModels[index].header
        }
        
        // 绑定单元格数据
        sections.bind(to: tableView.rx.items(dataSource: dataSource))
        .disposed(by: disposeBag)
    }
    
    
//    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        return 20;
//    }
}


// 自定义Section
struct MySection {
    var header: String
    var items: [Item]
}

extension MySection: AnimatableSectionModelType {
    typealias Item = String
    
    var identity: String {
        return header
    }
    
    init(original: MySection, items: [Item]) {
        self = original
        self.items = items
    }
}
