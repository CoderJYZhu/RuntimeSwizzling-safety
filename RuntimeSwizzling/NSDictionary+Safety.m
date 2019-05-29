//
//  NSDictionary+Safety.m
//  GPSCollect
//
//  Created by hollysmary on 2019/5/29.
//  Copyright © 2019 hollysmary. All rights reserved.
//

#import "NSDictionary+Safety.h"
#import <objc/runtime.h>
#import "NSObject+Swizzling.h"


@implementation NSDictionary (Safety)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [objc_getClass("__NSPlaceholderDictionary") swizzleSelector:@selector(initWithObjects:forKeys:count:) withSwizzledSelector:@selector(safe_initWithObjects:forKeys:count:)];
        [objc_getClass("__NSPlaceholderDictionary") swizzleSelector:@selector(dictionaryWithObjects:forKeys:count:) withSwizzledSelector:@selector(safe_dictionaryWithObjects:forKeys:count:)];
    });
}

+ (instancetype)safe_dictionaryWithObjects:(const id [])objects forKeys:(const id<NSCopying> [])keys count:(NSUInteger)cnt {
    id safeObjects[cnt];
    id safeKeys[cnt];
    NSUInteger j = 0;
    for (NSUInteger i = 0; i < cnt; i++) {
        id key = keys[i];
        id obj = objects[i];
        if (!key) {
            continue;
        }
        if (!obj) {
            obj = [NSNull null];
            JYLog(@"字典value为空 %s",__FUNCTION__);
        }
        safeKeys[j] = key;
        safeObjects[j] = obj;
        j++;
    }
    return [self safe_dictionaryWithObjects:safeObjects forKeys:safeKeys count:j];
}

- (instancetype)safe_initWithObjects:(const id [])objects forKeys:(const id<NSCopying> [])keys count:(NSUInteger)cnt {
    id safeObjects[cnt];
    id safeKeys[cnt];
    NSUInteger j = 0;
    for (NSUInteger i = 0; i < cnt; i++) {
        id key = keys[i];
        id obj = objects[i];
        if (!key) {
            continue;
        }
        if (!obj) {
            obj = [NSNull null];
            JYLog(@"字典value为空 %s",__FUNCTION__);
        }
        safeKeys[j] = key;
        safeObjects[j] = obj;
        j++;
    }
    return [self safe_initWithObjects:safeObjects forKeys:safeKeys count:j];
}

@end

@implementation NSMutableDictionary (Safety)

+(void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        [objc_getClass("__NSDictionaryM") swizzleSelector:@selector(setValue:forKey:) withSwizzledSelector:@selector(safeSetValue:forKey:)];
        [objc_getClass("__NSDictionaryM") swizzleSelector:@selector(setObject:forKey:) withSwizzledSelector:@selector(safeSetObject:forKey:)];
        [objc_getClass("__NSDictionaryM") swizzleSelector:@selector(removeObjectForKey:) withSwizzledSelector:@selector(safeRemoveObjectForKey:)];
        
    });
}
- (void)safeSetValue:(id)value forKey:(NSString *)key
{
    if (key == nil || value == nil || [key isEqual:[NSNull null]] || [value isEqual:[NSNull null]]) {
        JYLog(@"%s call -safeSetValue:forKey:, key或vale为nil或null", __FUNCTION__);
        return;
    }
    
    [self safeSetValue:value forKey:key];
}

- (void)safeSetObject:(id)anObject forKey:(id<NSCopying>)aKey
{
    if (aKey == nil || anObject == nil || [anObject isEqual:[NSNull null]]) {
        JYLog(@"%s call -safeSetObject:forKey:, key或vale为nil或null", __FUNCTION__);
        return;
    }
    
    [self safeSetObject:anObject forKey:aKey];
}

- (void)safeRemoveObjectForKey:(id)aKey
{
    if (aKey == nil || [aKey isEqual:[NSNull null]] ) {
        JYLog(@"%s call -safeRemoveObjectForKey:, aKey为nil或null", __FUNCTION__);
        return;
    }
    [self safeRemoveObjectForKey:aKey];
}

@end

@implementation NSNull (Safety)


+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self swizzleSelector:@selector(methodSignatureForSelector:) withSwizzledSelector:@selector(safe_methodSignatureForSelector:)];
        [self swizzleSelector:@selector(forwardInvocation:) withSwizzledSelector:@selector(safe_forwardInvocation:)];
    });
}

- (NSMethodSignature *)safe_methodSignatureForSelector:(SEL)aSelector {
    NSMethodSignature *sig = [self safe_methodSignatureForSelector:aSelector];
    if (sig) {
        return sig;
    }
    return [NSMethodSignature signatureWithObjCTypes:@encode(void)];
}

- (void)safe_forwardInvocation:(NSInvocation *)anInvocation {
    NSUInteger returnLength = [[anInvocation methodSignature] methodReturnLength];
    if (!returnLength) {
        // nothing to do
        return;
    }
    
    // set return value to all zero bits
    char buffer[returnLength];
    memset(buffer, 0, returnLength);
    
    [anInvocation setReturnValue:buffer];
}

@end
