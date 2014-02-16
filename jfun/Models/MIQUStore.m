//
//  MIQUStore.m
//  jfun
//
//  Created by z y on 13-7-11.
//  Copyright (c) 2013年 MIQU. All rights reserved.
//

#import "MIQUStore.h"

@implementation MIQUStore
@synthesize address,description,links,name,phone,photos,price,rating,storeId,category;
- (MIQUStore *)initWithName:(NSString *)nm address:(NSString *)addr phone:(NSString *)ph description:(NSString *)desrp price:(NSNumber *)prc rating:(NSNumber *)rat storeId:(NSNumber *)sId categoryStr:(CategoryType)cate{
    if (self = [super init]) {
        [self setName:nm];
        [self setAddress:addr];
        [self setPhone:ph];
        [self setPrice:prc];
        [self setDescription:desrp];
        [self setPhotos:[NSMutableArray array]];
        [self setLinks:[NSMutableArray array]];
        [self setRating:rat];
        [self setStoreId:sId];
        [self setCategory:cate];
    }
    return self;
}
- (void)addPhoto:(NSString *)photoUrl{
    [self.photos addObject:photoUrl];
}
- (void)addLink:(NSString *)linkUrl{
    [self.links addObject:linkUrl];
}
@end
