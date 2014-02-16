//
//  JSONObject.h
//  jfun
//
//  Created by mmm on 14-2-5.
//  Copyright (c) 2014年 miqu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JSONObject : NSObject<NSCopying,NSCoding>


- (instancetype)initWithDictionary:(NSDictionary *)dictionary;
@end
