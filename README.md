# RxSwiftExample
RxSwift 使用例子

1. 可观察序列Observable的创建方法
2. Observable订阅和事件监听、销毁
3. 观察者：AnyObserver、Binder 的创建
4. 自定义可绑定属性
   - 方式1：通过对UI类进行扩展
   - 方式2：通过对Reactive类进行扩展
5. 使用RxSwift自带的可以绑定属性（观察者，就不用自己再去创建观察者了）
6. Subjects订阅者的使用
   - PublishSubject
   - BehaviorSubject
   - ReplaySubject
   - Variable
7. 变换操作符
   - buffer
   - window
   - map
   - flatMap（已废弃，改用compactMap）
   - flatMapLatest
   - concatMap
   - scan
   - groupBy
