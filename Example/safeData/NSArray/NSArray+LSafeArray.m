//
//  NSArray+LSafeArray.m
//  safeData_Example
//
//  Created by 杨益凡 on 2024/12/12.
//  Copyright © 2024 jueduibishi. All rights reserved.
//

#import "NSArray+LSafeArray.h"
#import <objc/runtime.h>

@implementation NSArray (LSafeArray)
+ (void)load{
        
    [super load];
        
    // 因为数组是类簇类型的类，集合了几种相似的类，所以要考虑多种情况
    
    // 1,当数组为空的时候，类为__NSArray0
    Method fromEmptyArrayMethod = class_getInstanceMethod(objc_getClass("__NSArray0"), @selector(objectAtIndex:));
    Method toEmptyArrayMethod = class_getInstanceMethod(objc_getClass("__NSArray0"), @selector(xz_empty_objectAtIndex:));
    method_exchangeImplementations(fromEmptyArrayMethod, toEmptyArrayMethod);
    
    // 2,当数组只有一个元素的时候，类为__NSSingleObjectArrayI
    Method fromSingleArrayMethod = class_getInstanceMethod(objc_getClass("__NSSingleObjectArrayI"), @selector(objectAtIndex:));
    Method toSingleArrayMethod = class_getInstanceMethod(objc_getClass("__NSSingleObjectArrayI"), @selector(xz_signle_objectAtIndex:));
    method_exchangeImplementations(fromSingleArrayMethod, toSingleArrayMethod);

    // 3,当不可变数组有多个元素的时候，类为__NSArrayI
    Method fromArrayMehod = class_getInstanceMethod(objc_getClass("__NSArrayI"), @selector(objectAtIndex:));
    Method toArrayMethod = class_getInstanceMethod(objc_getClass("__NSArrayI"), @selector(xz_objectAtIndex:));
    method_exchangeImplementations(fromArrayMehod, toArrayMethod);
    
    // 4,当可变数组有多个元素的时候，类为__NSArrayM
    Method fromMutableArrayMethod = class_getInstanceMethod(objc_getClass("__NSArrayM"), @selector(objectAtIndex:));
    Method toMutableArrayMethod = class_getInstanceMethod(objc_getClass("__NSArrayM"), @selector(xz_mutable_objectAtIndex:));
    method_exchangeImplementations(fromMutableArrayMethod, toMutableArrayMethod);
}

#pragma mark - 可变数组:类为__NSArrayM
- (id)xz_mutable_objectAtIndex:(NSUInteger)index{
    
    // 数组为空或索引超出范围时，进行规避越界行为
    if (!self.count || index >= self.count) {
        
        @try{
            
            return [self xz_mutable_objectAtIndex:index];
        }
        @catch(NSException *exception){
            
            NSLog(@"数组越界method:%s\n,exception:%@",__func__,exception);

            return nil;
        }
    }
    
    return [self xz_mutable_objectAtIndex:index];
}


#pragma mark - 不可变数组:类为__NSArrayI
- (id)xz_objectAtIndex:(NSUInteger)index{
    
    // 数组为空或索引超出范围时，进行规避越界行为
    if (!self.count || index >= self.count) {
        
        @try{
            
            return [self xz_objectAtIndex:index];
        }
        @catch(NSException *exception){
            
            NSLog(@"数组越界method:%s\n,exception:%@",__func__,exception);

            return nil;
        }
    }
    
    return [self xz_objectAtIndex:index];
}


#pragma mark - 单个元素数组:类为__NSSingleObjectArrayI
- (id)xz_signle_objectAtIndex:(NSUInteger)index{
    
    // 数组为空或索引超出范围时，进行规避越界行为
    if (!self.count || index >= self.count) {
        
        @try{
            
            return [self xz_signle_objectAtIndex:index];
        }
        @catch(NSException *exception){
            
            NSLog(@"数组越界method:%s\n,exception:%@",__func__,exception);

            return nil;
        }
    }
    
    return [self xz_signle_objectAtIndex:index];
}


#pragma mark - 空数组:类为__NSArray0
- (id)xz_empty_objectAtIndex:(NSUInteger)index{
    
    // 数组为空或索引超出范围时，进行规避越界行为
    if (!self.count || index >= self.count) {
        
        @try{
            
            return [self xz_empty_objectAtIndex:index];
        }
        @catch(NSException *exception){
            
            NSLog(@"数组越界method:%s\n,exception:%@",__func__,exception);
            
            return nil;
        }
    }
    
    return [self xz_empty_objectAtIndex:index];
}
@end
