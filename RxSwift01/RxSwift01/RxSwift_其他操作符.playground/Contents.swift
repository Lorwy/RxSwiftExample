import RxSwift


print("###################delay#################")
// 1. delay
// 将 Observable 的所有元素都拖延一段时间发送出来
let disposeBag1 = DisposeBag()

Observable.of(1, 2, 1)
    .delay(3, scheduler: MainScheduler.instance)
    .subscribe(onNext: { print("delay:\($0)") })
    .disposed(by: disposeBag1)


print("###################delaySubscription#################")
// 2. delaySubscription
// 使用该操作符可以进行延时订阅。即经过所设定的时间后，才对 Observable 进行订阅操作
let disposeBag2 = DisposeBag()

Observable.of(1, 2, 1)
    .delaySubscription(3, scheduler: MainScheduler.instance)
    .subscribe(onNext:{ print("delaySubscription:\($0)") })
    .disposed(by: disposeBag2)


print("################### materialize #################")

// 3. materialize
// 该操作符可以将序列产生的事件，转换成元素
// materialize 操作符会将 Observable 产生的这些事件全部转换成元素，然后发送出来
let disposeBag3 = DisposeBag()

Observable.of(1, 2, 1)
    .materialize()
    .subscribe(onNext: { print("materialize:\($0)") })
    .disposed(by: disposeBag3)


print("################### dematerialize #################")

// 4. dematerialize
// 作用和 materialize 正好相反，它可以将 materialize 转换后的元素还原

let disposeBag4 = DisposeBag()

Observable.of(1, 2, 1)
    .materialize()
    .dematerialize()
    .subscribe(onNext: { print("dematerialize:\($0)") })
    .disposed(by: disposeBag4)

print("################### timeout #################")
// 5. timeout
// 若源 Observable 在规定时间内没有发任何出元素，就产生一个超时的 error 事件

let disposeBag5 = DisposeBag()
let times = [
    ["value": 1, "time": 0],
    ["value": 2, "time": 0.5],
    ["value": 3, "time": 1.5],
    ["value": 4, "time": 4],
    ["value": 5, "time": 5]
]

Observable.from(times)
    .flatMap({ item in
        return Observable.of(Int(item["value"]!))
            .delaySubscription(Double(item["time"]!),
                               scheduler: MainScheduler.instance)
    })
    .timeout(2, scheduler: MainScheduler.instance)
    .subscribe(onNext:{ element in
        print(element)
    }, onError:{ error in
        print(error)
    }).disposed(by: disposeBag5)

print("################### using #################")

// 6. using
// 使用 using 操作符创建 Observable 时，同时会创建一个可被清除的资源，
// 一旦 Observable终止了，那么这个资源就会被清除掉了。

// 参见 ViewController3.swift


