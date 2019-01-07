//
//  NSObject+Open.h
//  openTargetTest
//
//  Created by qinglin bi on 2019/1/7.
//  Copyright © 2019年 qinglin bi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (Open)

- (id )bql_invoke:(NSString *)selector;
- (id )bql_invoke:(NSString *)selector arguments:(NSArray *)arguments;
- (id )bql_invokeMethod:(NSString *)selector;
- (id )bql_invokeMethod:(NSString *)selector arguments:(NSArray *)arguments;

@end

