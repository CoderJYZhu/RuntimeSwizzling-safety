//
//  NSObject+Swizzling.h
//  GPSCollect
//
//  Created by hollysmary on 2019/5/29.
//  Copyright © 2019 hollysmary. All rights reserved.
//

#import <Foundation/Foundation.h>

#ifdef DEBUG
#define JYLog(...) printf("%s 第%d行: %s\n\n",[JYString UTF8String] ,__LINE__, [[NSString stringWithFormat:__VA_ARGS__] UTF8String]);
#endif

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (Swizzling)

+ (void)swizzleSelector:(SEL)originalSelector withSwizzledSelector:(SEL)swizzledSelector;

@end

NS_ASSUME_NONNULL_END
