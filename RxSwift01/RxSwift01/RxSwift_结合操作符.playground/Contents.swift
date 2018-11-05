import RxSwift

// 结合操作（或者称合并操作）指的是将多个 Observable 序列进行组合，拼装成一个新的 Observable 序列。

print("##############startWith##############")

// 1. startWith
// 该方法会在 Observable 序列开始之前插入一些事件元素。即发出事件消息之前，会先发出这些预先插入的事件消息。
let disposeBag1 = DisposeBag()

Observable.of("2", "3")
    .startWith("1")
    .startWith("0")
    .subscribe(onNext: { print($0) })
    .disposed(by: disposeBag1)

print("##############merge##############")
// 2. merge
// 该方法可以将多个（两个或两个以上的）Observable 序列合并成一个 Observable序列。
let disposeBag2 = DisposeBag()

let subject1 = PublishSubject<Int>()
let subject2 = PublishSubject<Int>()

Observable.of(subject1, subject2)
    .merge()
    .subscribe(onNext: { print($0) })
    .disposed(by: disposeBag2)

subject1.onNext(20)
subject1.onNext(40)
subject1.onNext(60)
subject2.onNext(1)
subject1.onNext(80)
subject1.onNext(100)
subject2.onNext(1)


print("############## zip ##############")

// 3. zip
// 该方法可以将多个（两个或两个以上的）Observable 序列压缩成一个 Observable 序列。
// 而且它会等到每个 Observable 事件一一对应地凑齐之后再合并。

let disposeBag3 = DisposeBag()

let subject3_1 = PublishSubject<Int>()
let subject3_2 = PublishSubject<String>()

Observable.zip(subject3_1, subject3_2) {
        "\($0)+\($1)"
    }
    .subscribe(onNext: { print($0) })
    .disposed(by: disposeBag3)

subject3_1.onNext(1)
subject3_2.onNext("A")
subject3_1.onNext(2)
subject3_2.onNext("B")
subject3_2.onNext("C")
subject3_2.onNext("D")
subject3_1.onNext(3)
subject3_1.onNext(4)
subject3_1.onNext(5)


print("############## combineLastest ##############")

// 4. combineLatest
// 该方法同样是将多个（两个或两个以上的）Observable 序列元素进行合并。
// 但与 zip 不同的是，每当任意一个 Observable 有新的事件发出时，
// 它会将每个 Observable 序列的最新的一个事件元素进行合并。

// 会产生总事件 - 1次事件
let disposeBag4 = DisposeBag()

let subject4_1 = PublishSubject<Int>()
let subject4_2 = PublishSubject<String>()

Observable.combineLatest(subject4_1, subject4_2) {
        "\($0) + \($1)"
    }
    .subscribe(onNext: { print($0) })
    .disposed(by: disposeBag4)

subject4_1.onNext(1)
subject4_2.onNext("A")
subject4_1.onNext(2)
subject4_2.onNext("B")
subject4_2.onNext("C")
subject4_2.onNext("D")
subject4_1.onNext(3)
subject4_1.onNext(4)
subject4_1.onNext(5)

print("############## withLatestFrom ##############")

// 5. withLatestFrom
// 该方法将两个 Observable 序列合并为一个。
// 每当 self 队列发射一个元素时，便从第二个序列中取出最新的一个值。

let disposeBag5 = DisposeBag()

let subject5_1 = PublishSubject<String>()
let subject5_2 = PublishSubject<String>()

subject5_1.withLatestFrom(subject5_2)
    .subscribe(onNext: { print($0) })
    .disposed(by: disposeBag5)

subject5_1.onNext("A")
subject5_2.onNext("1")
subject5_1.onNext("B")
subject5_1.onNext("C")
subject5_2.onNext("2")
subject5_1.onNext("D")

print("############## switchLatest ##############")
// 6. switchLatest
// switchLatest 有点像其他语言的switch 方法，可以对事件流进行转换。
// 比如本来监听的 subject1，我可以通过更改 variable 里面的 value 更换事件源。
// 变成监听 subject2。

let disposeBag6 = DisposeBag()

let subject6_1 = BehaviorSubject(value: "A")
let subject6_2 = BehaviorSubject(value: "1")

let variable = Variable(subject6_1)

variable.asObservable()
    .switchLatest()
    .subscribe(onNext: { print($0) })
    .disposed(by: disposeBag6)

subject6_1.onNext("B")
subject6_1.onNext("C")

// 改变事件源
variable.value = subject6_2
subject6_1.onNext("D")
subject6_2.onNext("2")

variable.value = subject6_1
subject6_2.onNext("3")
subject6_1.onNext("E")
