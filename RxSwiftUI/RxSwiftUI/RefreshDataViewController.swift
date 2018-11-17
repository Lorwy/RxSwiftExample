//
//  RefreshDataViewController.swift
//  RxSwiftUI
//
//  Created by Lorwy on 2018/11/16.
//  Copyright © 2018 Lorwy. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import RxDataSources

class RefreshDataViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var refreshButton: UIBarButtonItem!
    @IBOutlet weak var searchBar: UISearchBar!
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let randomResult = refreshButton.rx.tap.asObservable()
            .startWith(()) //加这个为了让一开始就能自动请求一次数据
            .flatMapLatest(getRandomResult)
            .flatMap(filterResult)
            .share(replay: 1)
        
        // 创建数据源
        let dataSource = RxTableViewSectionedReloadDataSource
            <SectionModel<String, Int>>(configureCell: { (datasource, tb, indexPath, element) -> UITableViewCell in
                let cell = tb.dequeueReusableCell(withIdentifier: "cell")!
                cell.textLabel?.text = "条目\(indexPath.row): \(element)"
                return cell
        })
        
        randomResult.bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
    }
    
    // 获取随机数据
    func getRandomResult() -> Observable<[SectionModel<String, Int>]> {
        print("正在请求数据......")
        let items = (0 ..< 5).map{_ in
            Int(arc4random())
        }
        let observable = Observable.just([SectionModel(model: "S", items: items)])
        return observable.delay(2, scheduler: MainScheduler.instance)
    }
    
    // 过滤数据
    func filterResult(data:[SectionModel<String, Int>]) -> Observable<[SectionModel<String, Int>]> {
        return self.searchBar.rx.text.orEmpty
            .flatMapLatest {
                query -> Observable<[SectionModel<String, Int>]> in
                print("正在筛选数据：（条件为： \(query)）")
                if query.isEmpty {
                    return Observable.just(data)
                }
                
                else {
                    var newData: [SectionModel<String, Int>] = []
                    for sectionModel in data {
                        let items = sectionModel.items.filter{
                            "\($0)".contains(query)
                        }
                        newData.append(SectionModel(model: sectionModel.model, items: items))
                    }
                    return Observable.just(newData)
                }
            }
    }
    
}
