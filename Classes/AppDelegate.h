//
//  AppDelegate.h
//  DDD
//
//  Created by kata on 10/05/10.
//  Copyright katax 2010. All rights reserved.
//

@interface AppDelegate : NSObject <UIApplicationDelegate> {
    
    UIWindow *window;
    UINavigationController *navigationController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UINavigationController *navigationController;

@end

