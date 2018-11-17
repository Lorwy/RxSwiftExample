import RxSwift
import RxCocoa


/*
 特征序列（Traits）：
 - Single、Completable、Maybe、Driver、ControlEvent
 - 特征序列（Traits）可看作是Observable的另外版本，他们的区别是：
    - Observable 是能够用于任何上下文环境的通用序列
    - Traits s可以帮我们更准确的描述序列，为我们提供上下文含义、语法糖，能更加优雅的方式书写代码
 */

print("####################### Single #######################")

// 1. Single
// 发出一个元素，或一个 error 事件
// 不会共享状态变化

// 应用场景：执行HTTP请求，返回一个应答或错误。也可用于描述任何只有一个元素的序列
// SingleEvent：枚举

enum DataError: Error {
    case canParseJSON
}

func getPlayList(_ channel: String) -> Single<[String: Any]> {
    return Single<[String: Any]>.create(subscribe: { single in
        let url = "https://douban.fm/j/mine/playlist?"
            + "type=n&channel=\(channel)&from=mainsite"
        let task = URLSession.shared.dataTask(with: URL(string: url)!) { data, _, error in
            if let error = error {
                single(.error(error))
                return
            }
            
            guard let data = data,
                let json = try? JSONSerialization.jsonObject(with: data, options: .mutableLeaves),
                let result = json as? [String: Any] else {
                    single(.error(DataError.canParseJSON))
                    return
                }
            single(.success(result))
        }
        task.resume()
        
        return Disposables.create {
            task.cancel()
        }
    })
}

let disposeBag1 = DisposeBag()

// 使用方式1
getPlayList("0")
    .subscribe { event in
        switch event {
        case .success(let json):
            print("JSON 结果：", json)
        case .error(let error):
            print("发生错误：", error)
        }
}.disposed(by: disposeBag1)

// 使用方式2

getPlayList("1")
    .subscribe(onSuccess: { json in
        print("方式2 JSON结果：",json)
    }, onError: { error in
        print("发生错误：", error)
    })
    .disposed(by: disposeBag1)

// 可以用 asSingle() 方法将 Observablex 序列转为 Single 序列
Observable.of("1").asSingle().subscribe({ print($0) }).disposed(by: disposeBag1)


print("####################### Completable #######################")

// 2. Completable
// 要么只能产生一个 completed 事件，要么产生一个 error 事件
/* 不会发出任何元素
 只会发出一个 completed 事件或者一个 error 事件
 不会共享状态变化 */

// 应用场景：只关心任务是否完成，不需要在意返回结果的情况；如：在退出程序时缓存数据到本地
// CompletableEvent：枚举

enum CacheError: Error {
    case failedCaching
}

// 将数据缓存到本地
func cacheLocally() -> Completable {
    return Completable.create(subscribe: { completable in
        //将数据缓存到本地（这里掠过具体的业务代码，随机成功或失败）
        let success = (arc4random() % 2 == 0)
        guard success else {
            Completable(.error(CacheError.failedCaching))
            return Disposables.create()
        }
        
        completable(.completed)
        return Disposables.create()
    })
}

let disposeBag2 = DisposeBag()

cacheLocally()
    .subscribe { completable in
        switch completable {
        case .completed:
            print("保存成功！")
        case .error(let error):
            print("保存失败：\(error.localizedDescription)")
        }
    }
    .disposed(by: disposeBag2)

cacheLocally()
    .subscribe(onCompleted: {
        print("保存成功！")
    }, onError: { (error) in
        print("保存失败：\(error.localizedDescription)")
    })
    .disposed(by: disposeBag2)


print("####################### Maybe #######################")
// 3. Maybe
// 介于 Single 和 Completable 之间，
// 它要么只能发出一个元素，
// 要么产生一个 completed 事件，
// 要么产生一个 error 事件

// 应用场景：那种可能需要发出一个元素，又可能不需要发出的情况

// MaybeEvent：枚举
//与缓存相关的错误类型
enum StringError: Error {
    case failedGenerate
}

func generateString() -> Maybe<String> {
    return Maybe<String>.create { maybe in
        maybe(.success("成功并发出一个元素"))
        maybe(.completed)
        
        // 失败
//        maybe(.error(StringError.failedGenerate))
        
        return Disposables.create {
            
        }
    }
}

let disposeBag3 = DisposeBag()

generateString()
    .subscribe({ maybe in
        switch maybe {
        case .success(let element):
            print("执行完毕，并获得元素：\(element)")
        case .completed:
            print("执行完毕，且没有任何元素。")
        case .error(let error):
            print("执行失败: \(error.localizedDescription)")
        }
    }).disposed(by: disposeBag3)

// 方式2
generateString()
    .subscribe(onSuccess: { (element) in
        print("执行完毕，并获得元素：\(element)")
    }, onError: { (error) in
        print("执行失败: \(error.localizedDescription)")
    }, onCompleted: {
        print("执行完毕，且没有任何元素。")
    }).disposed(by: disposeBag3)


// asMaybe()

let disposeBag4 = DisposeBag()

Observable.of("1")
    .asMaybe()
    .subscribe({ print($0) })
    .disposed(by: disposeBag4)
