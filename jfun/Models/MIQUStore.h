//
//  MIQUStore.h
//  jfun
//
//  Created by z y on 13-7-11.
//  Copyright (c) 2013年 MIQU. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MIQUStore : NSObject{
    
}
@property (nonatomic,strong) NSNumber *storeId;
@property (nonatomic,strong) NSString *name;
@property (nonatomic,strong) NSString *address;
@property (nonatomic,strong) NSString *phone;
@property (nonatomic,strong) NSString *description;
@property (nonatomic,strong) NSNumber *price;
@property (nonatomic,strong) NSMutableArray *photos;
@property (nonatomic,strong) NSMutableArray *links;
@property (nonatomic,strong) NSNumber *rating;
@property (nonatomic) CategoryType category;

- (MIQUStore *)initWithName:(NSString *)nm address:(NSString *)addr phone:(NSString *)ph description:(NSString *)desrp price:(NSNumber *)prc rating:(NSNumber *)rat storeId:(NSNumber *)sId categoryStr:(CategoryType)cate;
- (void)addPhoto:(NSString *)photoUrl;
- (void)addLink:(NSString *)linkUrl;
@end
