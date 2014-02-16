//
//  JFUpdate.h
//  jfun
//
//  Created by mmm on 14-1-29.
//  Copyright (c) 2014年 miqu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JFUpdate : NSObject
+ (JFUpdate *)sharedInstance;
- (void)updateLocationInfo;
@end
