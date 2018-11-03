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
8. 过滤操作符
   - filter（输入过滤条件来过滤）
   - distinctUntilChanged（过滤掉联系重复的事件）
   - single（限制只发送一次事件）
   - elementAt（处理指定位置的事件）
   - ignoreElements（忽略所有元素，只发error或completed）
   - take（只发送前n个事件，达到n个后就发送completed事件）
   - takeLast（只发送后n个事件）
   - skip（跳过前n个事件）
   - Sample（根据notifier Observable来取source Observable中最新事件来发送）
   - debounce（过滤高频产生的元素）
