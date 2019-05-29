//
//  UIButton+Safety.h
//  GPSCollect
//
//  Created by hollysmary on 2019/5/29.
//  Copyright © 2019 hollysmary. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

#define defaultInterval 0.5  //默认时间间隔

@interface UIButton (Safety)
@property (nonatomic, assign) NSTimeInterval timeInterval;
@end

NS_ASSUME_NONNULL_END
