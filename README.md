# 前言

* * *


**在钟颖大神的JSBox中有个模块叫Launch Center，核心实现功能是点击图标就会跳转到目标应用（如果已安装的话），我有点儿不相信他是用正常方式实现的~😝😆😆，真的很佩服他，JSBox真的是屌炸天的应用，大家可以试试（不是广告，人家根本不认识我，纯粹是崇拜）**


**好了，进入正题，iOS应用正儿八经的进行应用跳转的方法我就不说了，这里介绍的是两种”非正常“方法进行应用间跳转。**
* * *

### 准备工作
 * **```NSInvocation```**
 * **[私有api](https://github.com/nst/iOS-Runtime-Headers)**


### **1.通过应用 bundle id 打开目标应用**
**在[这个](https://github.com/nst/iOS-Runtime-Headers/blob/fbb634c78269b0169efdead80955ba64eaaa2f21/Frameworks/CoreServices.framework/LSApplicationWorkspace.h)头文件中能看到这样一个函数：**

```- (bool)openApplicationWithBundleID:(id)arg1;```

**从字面意思就知道啦！通过传入一个bundle id去打开这个应用。利用```NSInvocation```通过构造```LSApplicationWorkspace```实例，调用```openApplicationWithBundleID```，参数就是对应的bundle id**

**示例代码**

```
id LSApplication = NSClassFromString(@"LSApplicationWorkspace");
id workspace = [LSApplication bql_invokeMethod:@"defaultWorkspace"];
[workspace bql_invoke:@"openApplicationWithBundleID:" arguments:@[@"com.biqinglin.ivideo"]];
```

### **2.通过临时注册scheme白名单打开目标应用(iOS10以后)**
**我们知道正常情况下，应用间跳转可通过在配置文件中增加目标应用的scheme的方式去实现，我要说的就是利用这点，只不过我是通过临时注册而非应用内配置的方式，这样就达到足够灵活的目的，不用修改任何线上代码即可实现新增哪些需要跳转的目标应用**

**同样的，这个函数你可以在这个[头文件](https://github.com/nst/iOS-Runtime-Headers/blob/fbb634c78269b0169efdead80955ba64eaaa2f21/Frameworks/CoreServices.framework/LSApplicationRestrictionsManager.h)中找到**

```- (void)setWhitelistedBundleIDs:(id)arg1;```

**示例代码**

```
id LSApplication = NSClassFromString(@"LSApplicationRestrictionsManager");
id shared = [LSApplication bql_invokeMethod:@"sharedInstance"];
[shared bql_invoke:@"setWhitelistedBundleIDs:" arguments:@[@"com.biqinglin.ivideo://"]];

[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"com.biqinglin.ivideo://"] options:@{} completionHandler:^(BOOL success) {
    // 如果!success就重新注册一下，不过我测试发现注册一次，所有app都能通过该函数唤起scheme打开
}];
```


**以上两种方式都亲测有效，并成功上架到app store，虽然如此但还是希望慎用，毕竟违反了苹果爸爸的游戏规则**
