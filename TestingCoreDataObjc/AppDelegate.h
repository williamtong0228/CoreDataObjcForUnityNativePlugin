//
//  AppDelegate.h
//  TestingCoreDataObjc
//
//  Created by William Tong on 17/9/2020.
//  Copyright © 2020 William Tong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (readonly, strong) NSPersistentContainer *persistentContainer;

//- (void)saveContext;


@end

