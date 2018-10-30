//
//  ViewController.swift
//  RxSwift01
//
//  Created by Lorwy on 2018/10/29.
//  Copyright © 2018 Lorwy. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa


class ViewController: UIViewController {

    @IBOutlet weak var tableview: UITableView!
    
    let musicListViewModel = MusicListViewModel()
    
    // 负责对象销毁
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // 将数据绑定到tableview上
        musicListViewModel.data
            .bind(to: tableview.rx.items(cellIdentifier: "musicCell")) {_, music, cell in
                cell.textLabel?.text = music.name
                cell.detailTextLabel?.text = music.singer
            }.disposed(by: disposeBag)
        
        // tableview点击响应
        tableview.rx.modelSelected(Music.self).subscribe(onNext: { (music) in
            print("你选中的歌曲信息[\(music)]")
        }).disposed(by: disposeBag)
    }

    
}

