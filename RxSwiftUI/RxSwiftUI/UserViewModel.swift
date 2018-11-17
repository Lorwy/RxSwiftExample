//
//  UserViewModel.swift
//  RxSwiftUI
//
//  Created by Lorwy on 2018/11/14.
//  Copyright © 2018 Lorwy. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

struct UserViewModel {
    let username = BehaviorRelay<String>(value:"guest")
    
//    func getUserInfo() -> BehaviorRelay<String> {
//        return self.username.asObservable()
//                .map{ $0 == "lorwy" ? "您是高级用户" : "您是普通用户"}
//                .share(replay:1)
//    }
}
