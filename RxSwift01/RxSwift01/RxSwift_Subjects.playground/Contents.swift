import RxSwift

// 4种Subjects

// 1. PublishSubject
let disposeBag = DisposeBag()

// 创建一个PublishSubject
let subject = PublishSubject<String>()

// 由于subject当前没有订阅者，所以这条信息不回输出
subject.onNext("111")

// 第一次订阅
subject.subscribe(onNext: { (string) in
    print("PublishSubject 第1次订阅：", string)
},onCompleted: {
    print("PublishSubject 第1次订阅： onCompleted")
}).disposed(by: disposeBag)

subject.onNext("222")

// 第二次订阅
subject.subscribe(onNext: { (string) in
    print("PublishSubject 第2次订阅：", string)
},onCompleted: {
    print("PublishSubject 第2次订阅： onCompleted")
}).disposed(by: disposeBag)

subject.onNext("333")

subject.onCompleted()

subject.onNext("444")

//subject完成后它的所有订阅（包括结束后的订阅），都能收到subject的.completed事件，
// 第三次订阅
subject.subscribe(onNext: { (string) in
    print("PublishSubject 第3次订阅：", string)
},onCompleted: {
    print("PublishSubject 第3次订阅： onCompleted")
}).disposed(by: disposeBag)


// 2. BehaviorSubject
let disposeBag2 = DisposeBag()

let subject2 = BehaviorSubject(value: "111")

subject2.subscribe { event in
    print("BehaviorSubject 第1次订阅：",event)
}.disposed(by: disposeBag2)

subject2.onNext("222")

subject2.onError(NSError(domain: "local", code: 0, userInfo: nil))

subject2.subscribe { event in
    print("BehaviorSubject 第2次订阅：", event)
}.disposed(by: disposeBag2)

// 3. ReplaySubject
let disposeBag3 = DisposeBag()

let subject3 = ReplaySubject<String>.create(bufferSize: 2)

subject3.onNext("111")
subject3.onNext("222")
subject3.onNext("333")

subject3.subscribe { event in
    print("ReplaySubject 第1次订阅：", event)
}.disposed(by: disposeBag3)

subject3.onNext("444")

subject3.subscribe { event in
    print("ReplaySubject 第2次订阅：", event)
}.disposed(by: disposeBag3)

subject3.onCompleted()

subject3.subscribe { event in
    print("ReplaySubject 第3次订阅：", event)
}.disposed(by: disposeBag3)


// 4. Variable
let disposeBag4 = DisposeBag()
let variable = Variable("111")
variable.value = "222"
variable.asObservable().subscribe {
    print("Variable 第1次订阅：", $0)
}.disposed(by: disposeBag4)

variable.value = "333"
variable.asObservable().subscribe {
    print("Variable 第2次订阅：", $0)
}.disposed(by: disposeBag4)

variable.value = "444"
// 当这个方法执行完毕后，这个 Variable 对象就会被销毁，
// 同时它也就自动地向它的所有订阅者发出.completed 事件
