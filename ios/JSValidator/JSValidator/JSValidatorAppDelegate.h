//
//  JSValidatorAppDelegate.h
//  JSValidator
//
//  Created by Tyler Casselman on 3/6/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JSValidatorViewController;

@interface JSValidatorAppDelegate : NSObject <UIApplicationDelegate> {

}

@property (nonatomic, retain) IBOutlet UIWindow *window;

@property (nonatomic, retain) IBOutlet JSValidatorViewController *viewController;

@end
