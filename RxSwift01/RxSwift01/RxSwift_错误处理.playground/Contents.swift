import RxSwift

// 错误处理操作符可以用来帮助我们对 Observable 发出的 error 事件做出响应，或者从错误中恢复。

enum MyError: Error {
    case A
    case B
}


print("################# catchErrorJustReturn #################")
// 1. catchErrorJustReturn
// 当遇到 error 事件的时候，就返回指定的值，然后结束

let disposeBag1 = DisposeBag()

let sequenceThatFails = PublishSubject<String>()

sequenceThatFails
    .catchErrorJustReturn("错误")
    .subscribe(onNext: { print($0) })
    .disposed(by: disposeBag1)

sequenceThatFails.onNext("a")
sequenceThatFails.onNext("b")
sequenceThatFails.onNext("c")
sequenceThatFails.onError(MyError.A)
sequenceThatFails.onNext("d")

print("################# catchError #################")
// 2. catchError
// 该方法可以捕获 error，并对其进行处理
// 同时还能返回另一个 Observable 序列进行订阅（切换到新的序列）
let disposeBag2 = DisposeBag()
let sequenceThatFails2 = PublishSubject<String>()
let recoverySequence = Observable.of("1", "2", "3")

sequenceThatFails2
    .catchError { (error) -> Observable<String> in
        print("Error: \(error)")
        return recoverySequence
    }
    .subscribe(onNext: { print($0) })
    .disposed(by: disposeBag2)

sequenceThatFails2.onNext("a")
sequenceThatFails2.onNext("b")
sequenceThatFails2.onNext("c")
sequenceThatFails2.onError(MyError.A)
sequenceThatFails2.onNext("d")

print("################# retry #################")
// 3. retry
// 使用该方法当遇到错误的时候，会重新订阅该序列。
// 比如遇到网络请求失败时，可以进行重新连接。
// 默认重试一次

let disposeBag3 = DisposeBag()
var count = 1

let sequenceThatErrors3 = Observable<String>.create({ observer in
    observer.onNext("a")
    observer.onNext("b")
    
    // 让第一个订阅时发生错误
    if count == 1 {
        observer.onError(MyError.A)
        print("Error encountered")
        count += 1
    }else if count == 2 {
        observer.onError(MyError.A)
        print("Error encountered")
        count += 1
    }
    
    observer.onNext("c")
    observer.onNext("d")
    
    return Disposables.create()
})

sequenceThatErrors3
    .retry(3)
    .subscribe(onNext: { print($0) })
    .disposed(by: disposeBag3)

