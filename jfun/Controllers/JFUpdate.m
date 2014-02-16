//
//  JFUpdate.m
//  jfun
//
//  Created by mmm on 14-1-29.
//  Copyright (c) 2014年 miqu. All rights reserved.
//

#import "JFUpdate.h"
static JFUpdate *_sharedUpdate = nil;
@implementation JFUpdate
+ (JFUpdate *)sharedInstance{
    @synchronized(self)
    {
        if (_sharedUpdate == nil)
        {
            _sharedUpdate = [[self alloc] init];
        }
    }
    return _sharedUpdate;
}
+ (id)allocWithZone:(NSZone *)zone
{
    @synchronized(self)
    {
        if (_sharedUpdate == nil)
        {
            _sharedUpdate = [super allocWithZone:zone];
            return _sharedUpdate;
        }
    }
    return nil;
}
-(void)updateLocationInfo{
    NSArray *locations = [[MIQUUserInput new] stringsForAllLocation];
    [[NSUserDefaults standardUserDefaults] setValue:locations forKey:DEFAULT_NAME_LOCATION_ARRAY];
}
@end
