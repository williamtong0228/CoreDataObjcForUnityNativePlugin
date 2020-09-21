//
//  ViewController.m
//  TestingCoreDataObjc
//
//  Created by William Tong on 17/9/2020.
//  Copyright © 2020 William Tong. All rights reserved.
//

#import "ViewController.h"
#import "CoredataHelper.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (IBAction)addRecordAndPrint:(id)sender {
    [self addToPremium];
    
    
}
-(void)addToPremium{
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
@end
