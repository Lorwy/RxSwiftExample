import RxSwift

// 创建Observable序列

// 1. just() 方法
// （1）该方法通过传入一个默认值来初始化。
let observable = Observable<Int>.just(5)

// 2. of() 方法
//（1）该方法可以接受可变数量的参数（必需要是同类型的）
let observable1 = Observable.of("A", "B", "C")

// 3. from() 方法
//（1）该方法需要一个数组参数。
let observable2 = Observable.from(["A", "B", "C"])

// 4. empty() 方法
// 创建一个空内容的Observable序列
let observable3 = Observable<Int>.empty()

// 5. never() 方法
// 该方法创建一个永远不会发出 Event（也不会终止）的 Observable 序列。
let observable4 = Observable<Int>.never()

// 6. error() 方法
// 该方法创建一个不做任何操作，而是直接发送一个错误的 Observable 序列。
enum MyErorr: Error {
    case A
    case B
}

let observable5 = Observable<Int>.error(MyErorr.A)

// 7 range() 方法
// （1）该方法通过指定起始和结束数值，创建一个以这个范围内所有值作为初始值的Observable序列。
// （2）下面样例中，两种方法创建的 Observable 序列都是一样的。
let observable6 = Observable.range(start: 1, count: 5)
let observable7 = Observable.of(1, 2, 3, 4, 5)

// 8. repeatElement() 方法
// 该方法创建一个可以无限发出给定元素的 Event的 Observable 序列（永不终止）。
let observable8 = Observable.repeatElement(1)

// 9. generate() 方法
//（1）该方法创建一个只有当提供的所有的判断条件都为 true 的时候，才会给出动作的 Observable 序列。
//（2）下面样例中，两种方法创建的 Observable 序列都是一样的。
let observable9 = Observable.generate(
    initialState: 0,
    condition: { $0 <= 10 },
    iterate: {$0 + 2}
)
let observable9_1 = Observable.of(0, 2, 4, 6, 8, 10)

// 10. create() 方法
// （1）该方法接受一个 block 形式的参数，任务是对每一个过来的订阅进行处理。

// 这个block 有一个回调参数observer就是订阅这个Observable对象的订阅者
// 当一个订阅者订阅这个Observable对象的时候，就会将订阅者作为参数传入这个block来执行一些内容
let observable10 = Observable<String>.create { (observer) -> Disposable in
    // 对订阅者发出了.next时间，且携带了一个数据"lorwy.github.io"
    observer.onNext("lorwy.github.io")
    // 对订阅者发出了.completed事件
    observer.onCompleted()
    // 因为一个订阅行为会有一个Disposable类型的返回值，所以结尾一定要return一个Disposable
    return Disposables.create()
}

// 测试
observable10.subscribe {
    print($0)
}

// 11. deferred() 方法
// （1）该个方法相当于是创建一个 Observable 工厂，通过传入一个 block 来执行延迟 Observable序列创建的行为，
// 而这个 block 里就是真正的实例化序列对象的地方。

// 用于标记是奇数，还是偶数
var isOdd = true

//使用deferred()方法延迟Observable序列的初始化，通过传入的block来实现Observable序列的初始化并且返回。
let factory : Observable<Int> = Observable.deferred {
    // 让每次执行这个blockd时候都会让奇数、偶数进行交替
    isOdd = !isOdd
    
    // 根据isOdd参数，决定创建并返回的是奇数Observable、还是偶数Observable
    if isOdd {
        return Observable.of(1, 3, 5, 7, 9)
    } else {
        return Observable.of(2, 4, 6, 8, 10)
    }
}

// 第一次订阅测试
factory.subscribe { event in
    //print("\(isOdd)", event)
}

// 第二次订阅
factory.subscribe { event in
    //print("\(isOdd)", event)
}

// 12. interval() 方法
// （1）这个方法创建的 Observable 序列每隔一段设定的时间，会发出一个索引数的元素。而且它会一直发送下去。
// （2）下面方法让其每 1 秒发送一次，并且是在主线程（MainScheduler）发送。
//let observable12 = Observable<Int>.interval(1, scheduler: MainScheduler.instance)
//observable12.subscribe { event in
//    print(event)
//}

// 13. timer() 方法
// （1）这个方法有两种用法，一种是创建的 Observable序列在经过设定的一段时间后，产生唯一的一个元素。
// 5秒钟后发出唯一的一个元素0
let observable13 = Observable<Int>.timer(5, scheduler: MainScheduler.instance)
observable13.subscribe { event in
    print(event)
}

// （2）另一种是创建的 Observable 序列在经过设定的一段时间后，每隔一段时间产生一个元素。
// 延时5秒钟后，每隔一秒发出一个元素
let observable13_1 = Observable<Int>.timer(5, period: 1, scheduler: MainScheduler.instance)
observable13_1.subscribe { event in
    print(event)
}
