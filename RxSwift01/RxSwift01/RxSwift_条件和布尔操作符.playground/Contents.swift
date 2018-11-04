import RxSwift


// 条件和布尔操作会根据条件发射或变换 Observables，或者对他们做布尔运算。

print("##############amb#############")
// 1. amb
// 当传入多个 Observables 到 amb 操作符时，它将取第一个发出元素或产生事件的 Observable，
// 然后只发出它的元素。并忽略掉其他的 Observables。

let disposeBag1 = DisposeBag()

let subject1 = PublishSubject<Int>()
let subject2 = PublishSubject<Int>()
let subject3 = PublishSubject<Int>()

subject1
    .amb(subject2)
    .amb(subject3)
    .subscribe(onNext:{print($0)})
    .disposed(by: disposeBag1)

subject2.onNext(1)
subject1.onNext(20)
subject2.onNext(2)
subject1.onNext(40)
subject3.onNext(0)
subject2.onNext(3)
subject1.onNext(60)
subject3.onNext(0)
subject3.onNext(0)

// 结果 ： 1 2 3

print("#############takeWhile##############")
// 2. takeWhile
// 该方法依次判断 Observable 序列的每一个值是否满足给定的条件。
// 当第一个不满足条件的值出现时，它便自动完成。

let disposeBag2 = DisposeBag()

Observable.of(2, 3, 4, 5, 6)
    .takeWhile({ $0 < 4 })
    .subscribe(onNext: { print($0) })
    .disposed(by: disposeBag2)


print("#############takeUntil##############")
// 3. takeUntil
// 除了订阅源 Observable 外，通过 takeUntil 方法我们还可以监视另外一个 Observable， 即 notifier。
// 如果 notifier 发出值或 complete 通知，那么源 Observable 便自动完成，停止发送事件。

let disposeBag3 = DisposeBag()
let source = PublishSubject<String>()
let notifier = PublishSubject<String>()

source.takeUntil(notifier)
    .subscribe(onNext: { print($0) })
    .disposed(by: disposeBag3)

source.onNext("a")
source.onNext("b")
source.onNext("c")
source.onNext("d")

// notifier一发送消息，source就停止接收
notifier.onNext("z")

source.onNext("e")
source.onNext("f")
source.onNext("g")

print("#############skipWhile##############")
// 4. skipWhile
// 该方法用于跳过前面所有满足条件的事件。
// 一旦遇到不满足条件的事件，之后就不会再跳过了。

let disposeBag4 = DisposeBag()
Observable.of(2, 3, 4, 5, 6)
    .skipWhile({ $0 < 4 })
    .subscribe(onNext: { print($0) })
    .disposed(by: disposeBag4)

print("#############skipUntil##############")
// 5. skipUntil
// 同上面的 takeUntil 一样，skipUntil 除了订阅源 Observable 外，
// 通过 skipUntil方法我们还可以监视另外一个 Observable， 即 notifier 。

// 与 takeUntil 相反的是。源 Observable 序列事件默认会一直跳过，
// 直到 notifier 发出值或 complete 通知。

let disposeBag5 = DisposeBag()

let source5 = PublishSubject<Int>()
let notifier5 = PublishSubject<Int>()

source5.skipUntil(notifier5)
    .subscribe(onNext: { print($0) })
    .disposed(by: disposeBag5)

source5.onNext(1)
source5.onNext(2)
source5.onNext(3)
source5.onNext(4)
source5.onNext(5)

// notifier 发送消息后就立马开始接受消息

notifier5.onNext(6)

source5.onNext(6)
source5.onNext(7)
source5.onNext(8)

// 仍然接收消息
notifier5.onNext(0)

source5.onNext(9)


