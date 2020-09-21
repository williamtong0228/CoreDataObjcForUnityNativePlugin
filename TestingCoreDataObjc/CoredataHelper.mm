//
//  CoredataHelper.m
//  TestingCoreDataObjc
//
//  Created by William Tong on 17/9/2020.
//  Copyright © 2020 William Tong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "CoredataHelper.h"
#import <UIKit/UIKit.h>

@interface CoredataHelper()
@property (nonatomic) NSPersistentStoreCoordinator *persistentCoordinator;
//
//
//@property (readonly, strong)NSPersistentContainer *persistentContainer;
//@property NSManagedObjectContext *moc;
//
//-(void)saveContext;
//-(void)addToPremium;
//-(void)testingNewDataModel:(NSManagedObjectModel*)model;
@end

@implementation CoredataHelper
//@synthesize persistentContainer = _persistentContainer;
@synthesize moc, testMoc, persistentCoordinator;


//- (NSPersistentContainer *)persistentContainer {
//    // The persistent container for the application. This implementation creates and returns a container, having loaded the store for the application to it.
//    @synchronized (self) {
//        if (_persistentContainer == nil) {
//            _persistentContainer = [[NSPersistentContainer alloc] initWithName:@"FreekickR"];
//            [_persistentContainer loadPersistentStoresWithCompletionHandler:^(NSPersistentStoreDescription *storeDescription, NSError *error) {
//                if (error != nil) {
//                    // Replace this implementation with code to handle the error appropriately.
//                    // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
//
//                    /*
//                     Typical reasons for an error here include:
//                     * The parent directory does not exist, cannot be created, or disallows writing.
//                     * The persistent store is not accessible, due to permissions or data protection when the device is locked.
//                     * The device is out of space.
//                     * The store could not be migrated to the current model version.
//                     Check the error message to determine what the actual problem was.
//                    */
//                    NSLog(@"Unresolved error %@, %@", error, error.userInfo);
//                    abort();
//                }
//            }];
//        }
//    }
//
//    return _persistentContainer;
//}

-(id)init{
    self = [super init];
    
    return  self;
}
//-(NSPersistentStoreCoordinator*)persistentCoordinator{
//    if (_persistentCoordinator == nil) {
//        NSManagedObjectModel* model = [self initializeModel];
//        _persistentCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:model];
//    }
//    return _persistentCoordinator;
//}
#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *moc = self.persistentContainer.viewContext;
    NSError *error = nil;
    if ([moc hasChanges] && ![moc save:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, error.userInfo);
        abort();
    }
}



-(NSManagedObjectModel*) initializeModel{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    
//    NSString *mainBundlePath = [[NSBundle mainBundle] bundlePath];
    NSString *modelName = @"AppDataModel.mmodel";
    NSString *pathToModel = [documentsDirectory stringByAppendingPathComponent:modelName];
    
    NSError *err;
    
    //debug
    NSFileManager *filemgr = [NSFileManager defaultManager];
    NSArray *files = [filemgr contentsOfDirectoryAtPath:documentsDirectory error:&err];
    NSLog(@"app files before %@ ", files);
//    NSArray *resources = [filemgr contentsOfDirectoryAtPath:mainBundlePath error:&err];
//    NSLog(@"app files before  bundle files %@ ", resources);
    //debug end

    
    NSManagedObjectModel *model = nil;
    if([[NSFileManager defaultManager] fileExistsAtPath:pathToModel]){
        NSLog(@"model file found.");
        NSData *dataForModel = [NSData dataWithContentsOfFile:pathToModel];
        model = [NSKeyedUnarchiver unarchivedObjectOfClass:[NSManagedObjectModel class] fromData:dataForModel error:&err];
        
    }else{
        NSLog(@"model file not found.");
    }
    
    if (model == nil) {
        model = [[NSManagedObjectModel alloc] init];
        
        NSMutableArray *entities = [[NSMutableArray alloc] init];
        NSMutableArray *attributes = [[NSMutableArray alloc] init];
        
        NSEntityDescription *newEntity = [[NSEntityDescription alloc] init];
        
        [newEntity setName:@"UserStatus"];
        
        NSLog(@"Entity initialized.");
        
        NSAttributeDescription *isPremiumAtt = [[NSAttributeDescription alloc] init];
        [isPremiumAtt setName:@"premium"];
        [isPremiumAtt setAttributeType:NSStringAttributeType];
        [isPremiumAtt setOptional:NO];
        [attributes addObject:isPremiumAtt];
        
        
        NSAttributeDescription *saveVer = [[NSAttributeDescription alloc] init];
        [saveVer setName:@"ver"];
        [saveVer setAttributeType:NSStringAttributeType];
        [saveVer setOptional:NO];
        [attributes addObject:saveVer];
        
        
        
        [newEntity setProperties:attributes];
        
        [entities addObject:newEntity];
        [model setEntities:entities];
        
        NSError *savingErr;
        
        NSData *modelData = [NSKeyedArchiver archivedDataWithRootObject:model requiringSecureCoding:NO error:&err];
//        [modelData writeToFile:pathToModel atomically:YES];
        [modelData writeToFile:pathToModel options:NSDataWritingAtomic error:&savingErr];
        BOOL savingStatus = [modelData writeToFile:pathToModel options:NSDataWritingAtomic error:&savingErr];
        if (!savingStatus) {
            NSLog(@"Check saving status %@ ",savingErr);
        }
        
        NSLog(@"model file created at path %@", pathToModel);
//        NSLog(@"app files after %@ ", resources);
        
        if([[NSFileManager defaultManager] fileExistsAtPath:pathToModel]){
            NSLog(@"model file found.");
           
            
        }else{
            NSLog(@"Failed to create momd file.");
        }
    }
    
    return  model;
    
}

-(NSManagedObjectContext*) createManagedObjectContext{
    NSManagedObjectModel* model = [self initializeModel];
    persistentCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:model];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    NSString *nameForSQLiteStore = @"AppDataDb.sqlite";
    NSString *pathToSQLiteStore = [documentsDirectory stringByAppendingPathComponent: nameForSQLiteStore];
    NSURL *urlFromPath = [NSURL fileURLWithPath:pathToSQLiteStore isDirectory:NO];
    NSError *err;
    NSLog(@"Checking persistentCoordinator setup.");
    NSLog(@"Print path %@", urlFromPath);
    if (![persistentCoordinator addPersistentStoreWithType:NSSQLiteStoreType
                                             configuration:@"PF_DEFAULT_CONFIGURATION_NAME"
                                                       URL:urlFromPath
                                                   options:nil
                                                     error:&err]) {
        NSLog(@"persistentCoordinator setup error %@.", err);
        return nil;
       
    }else{
        
        testMoc = [[NSManagedObjectContext alloc] initWithConcurrencyType:(NSPrivateQueueConcurrencyType)];
        [testMoc setRetainsRegisteredObjects:YES];
        [testMoc setMergePolicy:[[NSMergePolicy alloc] initWithMergeType:NSMergeByPropertyObjectTrumpMergePolicyType]];
        [testMoc setPersistentStoreCoordinator:persistentCoordinator];
    }
    
    NSLog(@"Ready to return ManagedObjectContext.");
    return testMoc;
}

+(void)addToPremium{
//    NSManagedObjectContext *moc = self.persistentContainer.viewContext;
    CoredataHelper *helper = [[CoredataHelper alloc] init];
    NSLog(@"helper initialized.");
    NSManagedObjectContext *moc = [helper createManagedObjectContext];
    NSLog(@"Check moc %@", moc);
    NSError *error = nil;
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"UserStatus"];
    NSArray *results = [moc executeFetchRequest:request error:&error];
    int premiumCount = 0;
    int verCount  = 0;
    int highScore = 0;
    if(results.count > 0){
        for(NSManagedObject *obj in results){
            int isPremium = [[obj valueForKey:@"premium"] intValue];
//            int isNoAds = [[obj valueForKey:@"noAds"] intValue];
//            int score = [[obj valueForKey:@"score"] intValue];
            
//            if (score >= highScore) {
//                highScore = score;
//            }
//            if (isNoAds == [@"1" intValue]) {
//                noAdsCount += 1;
//            }
//
            NSString *version = [obj valueForKey:@"ver"];
            
            if (isPremium == [@"1" intValue]) {
                premiumCount += 1;
            }
            
            if ([version isEqualToString: @"1.0"]) {
                verCount += 1;
            }
        }
        
    }
    
    NSManagedObject *newRecord = [NSEntityDescription insertNewObjectForEntityForName:@"UserStatus" inManagedObjectContext:moc];
    
    if (premiumCount > 0) {
        [newRecord setValue:@"1" forKey:@"premium"];
    }else{
        [newRecord setValue:@"1" forKey:@"premium"]; //test
    }
    
    if (verCount == 0) {
        [newRecord setValue:@"1.0" forKey:@"ver"]; //test
    }else{
        [newRecord setValue:@"1.0" forKey:@"ver"]; //test
    }
    
//    if (noAdsCount > 0) {
//        [newRecord setValue:@"1" forKey:@"noAds"];
//    }else{
//        [newRecord setValue:@"0" forKey:@"noAds"];
//    }
    
//    [newRecord setValue:[NSString stringWithFormat:@"%d",highScore ] forKey:@"score"];
    
    
    
    if (results.count > 6) {
        [moc deleteObject:results[results.count - 1]];
    }
    
    NSError *err;
    
    if(![moc save:&err]){
        NSLog(@"Failed to save data %@", err.localizedDescription);
    }
    
    for(NSManagedObject *obj in results){
        NSLog(@"%@",[obj valueForKey:@"premium"]);
        NSLog(@"%@",[obj valueForKey:@"ver"]);
    }
    
}

+(void)addNewEntity{
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    
//    NSString *mainBundlePath = [[NSBundle mainBundle] bundlePath];
    NSString *modelName = @"AppDataModel.mmodel";
    NSString *pathToModel = [documentsDirectory stringByAppendingPathComponent:modelName];
}
@end

extern "C"
{
    void _WriteRecord(){
        [CoredataHelper addToPremium];
    }
}
