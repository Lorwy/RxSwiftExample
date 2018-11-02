import RxSwift

//#############变换操作符(Transforming Observables)############
// 变换操作指的是对原始的 Observable 序列进行一些转换，类似于 Swift 中 CollectionType 的各种转换。

// 1. buffer

let disposeBag = DisposeBag()

let subject = PublishSubject<String>()

// 每缓存3个元素则组合起来一起发出
// 如果1秒钟内不够3个，也会发出（有几个发几个，一个都没有的话就发空数组[]）

subject
   .buffer(timeSpan: 1, count: 3, scheduler: MainScheduler.instance)
   .subscribe(onNext: { print($0) })
   .disposed(by: disposeBag)

subject.onNext("a")
subject.onNext("b")
subject.onNext("c")


subject.onNext("1")
subject.onNext("2")
subject.onNext("3")

// 2. window
/*
与buffer相似，但buffer是周期性的将缓存的元素发出来
window是周期性的将元素集合以 Observable的形态发出来
buffer : 等元素搜集完毕后发出
window : 实时发出元素序列
*/

let subject2 = PublishSubject<String>()
subject2
   .window(timeSpan: 1, count: 3, scheduler: MainScheduler.instance)
   .subscribe(onNext: {
       print("subscribe: \($0)")
       $0.asObservable()
           .subscribe(onNext: { print($0) })
           .disposed(by: disposeBag)
   })
   .disposed(by: disposeBag)

subject2.onNext("a")
subject2.onNext("b")
subject2.onNext("c")


subject2.onNext("1")
subject2.onNext("2")
subject2.onNext("3")


// 3. map
// 通过传入一个函数闭包l把原来的Observable序列变为一个新的Observable序列
let disposeBag3 = DisposeBag()

Observable.of(1, 2, 3)
   .map({ $0 * 10 })
   .subscribe(onNext: {print($0) })
   .disposed(by: disposeBag3)

// 4. flatMap

let disposeBag4 = DisposeBag()

let subject4_1 = BehaviorSubject(value: "flatMap A")
let subject4_2 = BehaviorSubject(value: "flatMap 1")

let variable = Variable(subject4_1)

variable.asObservable()
    .flatMap( { $0 })
    .subscribe(onNext: { print($0) })
    .disposed(by: disposeBag4)

subject4_1.onNext("flatMap B")
variable.value = subject4_2
subject4_2.onNext("flatMap 2")
subject4_1.onNext("flatMap C")

// 结果A B 1 2 C

// 5. flatMapLatest
// flatMapLatest与flatMap 的唯一区别是：flatMapLatest只会接收最新的value 事件。
let disposeBag4_2 = DisposeBag()

let subject4_2_1 = BehaviorSubject(value: "flatMapLatest A")
let subject4_2_2 = BehaviorSubject(value: "flatMapLatest 1")

let variable2 = Variable(subject4_2_1)

variable2.asObservable()
    .flatMapLatest( { $0 })
    .subscribe(onNext: { print($0) })
    .disposed(by: disposeBag4)

subject4_2_1.onNext("flatMapLatest B")
variable2.value = subject4_2_2
subject4_2_2.onNext("flatMapLatest 2")
subject4_2_1.onNext("flatMapLatest C")

// 结果 A B 1 2

// 6. concatMap
// concatMap 与 flatMap 的唯一区别是：
// * 当前一个 Observable 元素发送完毕后，后一个Observable 才可以开始发出元素。
// * 或者说等待前一个 Observable 产生完成事件后，才对后一个 Observable 进行订阅。
let disposeBag4_3 = DisposeBag()

let subject4_3_1 = BehaviorSubject(value: "concatMap A")
let subject4_3_2 = BehaviorSubject(value: "concatMap 1")

let variable3 = Variable(subject4_3_1)

variable3.asObservable()
    .concatMap( { $0 })
    .subscribe(onNext: { print($0) })
    .disposed(by: disposeBag4_3)

subject4_3_1.onNext("concatMap B")
variable3.value = subject4_3_2
subject4_3_2.onNext("concatMap 2")
subject4_3_1.onNext("concatMap C")
subject4_3_1.onCompleted() // 只有前一个序列结束后才能接收下一个序列

// 7. scan
// scan 就是先给一个初始化的数，然后不断的拿前一个结果和最新的值进行处理操作。
let disposeBag7 = DisposeBag()

//Observable.of(1, 2, 3, 4, 5)
//    .scan(0) { acum, elem in
//        acum + elem
//    }
//    .subscribe(onNext: {print($0)})
//    .disposed(by: disposeBag7)

Observable.of(1, 2, 3, 4, 5)
    .scan(0) { (A, B)in
        A + B
    }.subscribe(onNext: {print($0)})
    .disposed(by: disposeBag7)

// 8. groupBy
// groupBy 操作符将源 Observable 分解为多个子 Observable，然后将这些子 Observable 发送出来。
// 也就是说该操作符会将元素通过某个键进行分组，然后将分组后的元素序列以 Observable 的形态发送出来

let disposeBag8 = DisposeBag()

// 将奇数、偶数分成两组
Observable<Int>.of(0, 1, 2, 3, 4, 5).groupBy { (element) -> String in
    return element % 2 == 0 ? "偶数" : "奇数"
}.subscribe({ event in
    switch event {
    case .next(let group):
        group.asObservable().subscribe({ event in
            print("key: \(group.key)  event:\(event)")
        }).disposed(by: disposeBag8)
    default:
        print("")
    }
}).disposed(by: disposeBag8)
