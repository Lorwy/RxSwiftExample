import RxSwift

//###################创建观察者方法######################
// 观察者1： AnyOberver、 Binder

//##################《一》直接在subscribe、bind方法中创建观察者#######################

// 1. 在 subscribe 方法中创建
let observable = Observable.of("A", "B", "C")

observable.subscribe(onNext: { (element) in
    print(element)
}, onError: { (error) in
    print(error)
}, onCompleted: {
    print("completed")
}).dispose()

// 2. 在 bind 方法中创建
// 参见ViewController1.swift中的例子
let disposeBag = DisposeBag()

let observable1 = Observable<Int>.interval(1, scheduler: MainScheduler.instance)


//##################《二》使用 AnyObserver 创建观察者#######################

// 1. 配合 subscribe 方法使用

// 观察者
let observer: AnyObserver<String> = AnyObserver { event in
    switch event {
    case .next(let data):
        print(data)
    case .error(let error):
        print(error)
    case .completed:
        print("completed")
    }
}

observable.subscribe(observer)


// 2. 配合 bindTo 方法使用
// 参见ViewController1.swift中的例子

//##################《三》使用 Binder创建观察者#######################
/*
 （1）相较于AnyObserver 的大而全，Binder 更专注于特定的场景。Binder 主要有以下两个特征：
 不会处理错误事件
 确保绑定都是在给定 Scheduler 上执行（默认 MainScheduler）
 （2）一旦产生错误事件，在调试环境下将执行 fatalError，在发布环境下将打印错误信息。
 */

// 参见ViewController1.swift中的例子
