//
//  CoredataHelper.h
//  TestingCoreDataObjc
//
//  Created by William Tong on 17/9/2020.
//  Copyright © 2020 William Tong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
@interface CoredataHelper : NSObject


@property (readonly, strong)NSPersistentContainer *persistentContainer;
@property (readonly, strong)NSPersistentStoreCoordinator *persistentCoordinator;
@property NSManagedObjectContext *moc , *testMoc;

//-(void)saveContext;
-(NSManagedObjectContext*) createManagedObjectContext;
////-(void)createNewDataModel;
+(void)addToPremium;
@end
