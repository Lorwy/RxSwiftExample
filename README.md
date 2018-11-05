# RxSwiftExample
RxSwift 使用例子

1. 可观察序列Observable的创建方法
   - just （通过传入一个默认值来初始化）
   - of （接受可变数量的参数，必须是同类型）
   - from （一个数组的参数）
   - empty （创建一个空的可观察序列）
   - never （不会发送Event，也不会终止的序列）
   - error （直接发送一个error的序列）
   - range （通过制定起始值和结束值创建一个以这个范围值为初始值的序列）
   - repeatElement （无限发给定元素Event的序列）
   - generate （只有当提供的判断条件都为 true 的时候，才会给出动作的序列）
   - create （接受一个block参数，对每一个订阅进行处理）
   - deferred （创建一个Observable工厂，传入block来延迟创建序列）
   - interval （创建一个间隔设定时间发出一个索引数的序列）
   - timer 
      - 经过设定时间A后产生唯一一个元素
      - 经过设定时间A后每间隔B时间产生一个元素

2. Observable订阅和事件监听、销毁
   - subscribe
   - subscribe(onNext:{ })

3. 观察者：AnyObserver、Binder 的创建
   - 直接z在subscribe中创建观察者
   - 直接在bind方法中创建观察者
   - 使用AnyObserver配合subscribe创建
   - 使用AnyObserver配合bindTo创建
   - 使用Binder创建

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

9. 条件和布尔操作符
   - amb（多个可观察序列，只取第一个发出元素或事件的序列来发出元素）
   - takeWhile（满足条件就发送，不满足条件一出就completed）
   - takeUntil（一直处理，直到notifier发出值或complete通知时才结束）
   - skipWhile（满足条件就跳过，一出现不满足条件的从此就不再跳过）
   - skipUntil（一直跳过，知道notifier发出值或complete通知时才开始处理）

10. 结合操作符
    - startWith（序列开始之前插入一些事件元素，头部插队的感觉）
    - merge（将多个序列合并成一个，顺序按产生先后）
    - zip（将多个序列压缩成一个，顺序是一一对应发送）
    - combineLatest（跟zip类似，区别是：当前产生的那个与另外的最新的那个结合）
    - withLatestFrom（序列A发送元素时就从B中去最新的来发出，跟过滤操作符Sample类似）
    - switchLatest（变换观察目标，每次切换会将那个目标未发送的事件处理）
