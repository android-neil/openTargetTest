//
//  NSObject+Open.m
//  openTargetTest
//
//  Created by qinglin bi on 2019/1/7.
//  Copyright © 2019年 qinglin bi. All rights reserved.
//

#import "NSObject+Open.h"

@implementation NSObject (Open)

- (id )bql_invoke:(NSString *)selector {
    
    return bqlBase_invoke(self, selector, nil, NO);
}
- (id )bql_invoke:(NSString *)selector arguments:(NSArray *)arguments {
    
    NSAssert(arguments == nil || [arguments isKindOfClass:[NSArray class]], @"please set a correct arguments");
    return bqlBase_invoke(self, selector, arguments, NO);
}
- (id )bql_invokeMethod:(NSString *)selector {
    
    return bqlBase_invoke(self, selector, nil, YES);
}
- (id )bql_invokeMethod:(NSString *)selector arguments:(NSArray *)arguments {
    
    return bqlBase_invoke(self, selector, arguments, YES);
}
id bqlBase_invoke(id class, NSString *selector, NSArray *arguments, BOOL method) {
    
    SEL sel = NSSelectorFromString(selector);
    NSMethodSignature *signature = nil;
    if(method) {
        signature = [[class class] methodSignatureForSelector:sel];
    }
    else {
        signature = [[class class] instanceMethodSignatureForSelector:sel];
    }
    if(!signature) return nil;
    
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
    invocation.target = class;
    invocation.selector = sel;
    if(arguments) {
        [arguments enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            // 索引从2开始,0、1已被占用,分别是:target、selector
            NSUInteger index = idx + 2;
            [invocation setArgument:&obj atIndex:index];
        }];
    }
    [invocation invoke];
    
    // 返回值类型 '@'是id类型,'v'为无返回,其他可视为基本数值类型(更详细的类型请查阅资料)
    const char *returnType = [signature methodReturnType];
    id result = nil;
    switch (returnType[0]) {
        case '@': {
            id __unsafe_unretained _result = nil;
            [invocation getReturnValue:&_result];
            result = _result;
        }
            break;
        case 'v': {
            return nil;
        }
            break;
            
        default: {
            NSInteger _result = 0;
            [invocation getReturnValue:&_result];
            result = @(_result);
        }
            break;
    }
    return result;
}

@end
