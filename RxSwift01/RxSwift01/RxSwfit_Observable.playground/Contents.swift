import RxSwift

// Observable订阅、事件监听、订阅销毁

// 有了 Observable，我们还要使用 subscribe() 方法来订阅它，接收它发出的 Event。

// 第一种方法
// （1）我们使用 subscribe() 订阅了一个Observable 对象，该方法的 block 的回调参数就是被发出的 event 事件，我们将其直接打印出来。
let observable = Observable.of("A", "B", "C")
observable.subscribe { event in
    print(event)
}.dispose()
// 打印结果显示：
// 初始化 Observable 序列时设置的默认值都按顺序通过 .next 事件发送出来。
// 当 Observable 序列的初始数据都发送完毕，它还会自动发一个 .completed 事件出来
observable.subscribe { event in
    print(event.element as Any)
}.dispose()

//（1）RxSwift 还提供了另一个 subscribe方法，它可以把 event 进行分类：
observable.subscribe(onNext: { (element) in
    print(element)
}, onError: { (error) in
    print(error)
}, onCompleted: {
    print("completed")
}, onDisposed: {
    print("disposed")
}).dispose()

// k也可以只处理onNext
observable.subscribe(onNext: { (element) in
    print(element)
}).dispose()


// 监听事件的生命周期
observable
    .do(onNext: { element in
        print("Intercepted Next：", element)
    }, onError: { error in
        print("Intercepted Error：", error)
    }, onCompleted: {
        print("Intercepted Completed")
    }, onDispose: {
        print("Intercepted Disposed")
    })
    .subscribe(onNext: { element in
        print(element)
    }, onError: { error in
        print(error)
    }, onCompleted: {
        print("completed")
    }, onDisposed: {
        print("disposed")
    }).dispose()

// DisposeBag 垃圾袋
// .dispose(by : 创建的那个垃圾袋)


