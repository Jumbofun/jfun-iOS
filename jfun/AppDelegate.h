//
//  AppDelegate.h
//  jfun
//
//  Created by 冒主人～ on 13-12-6.
//  Copyright (c) 2013年 miqu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MIQUSNS.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end
