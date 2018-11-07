import RxSwift


// 1. 可链接的l序列
// （1）可连接的序列和一般序列不同在于：有订阅时不会立刻开始发送事件消息，只有当调用 connect()之后才会开始发送值。
// （2）可连接的序列可以让所有的订阅者订阅后，才开始发出事件消息，从而保证我们想要的所有订阅者都能接收到事件消息。

let interval = Observable<Int>.interval(1, scheduler: MainScheduler.instance)

_ = interval.subscribe(onNext:{ print("订阅1：\($0)")})

public func delay(_ delay: Double, closure: @escaping () -> Void) {
    DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
        closure()
    }
}

delay(5) {
    _ = interval.subscribe(onNext: { print("订阅2：\($0)") })
}
