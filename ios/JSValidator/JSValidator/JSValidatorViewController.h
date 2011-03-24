//
//  JSValidatorViewController.h
//  JSValidator
//
//  Created by Tyler Casselman on 3/6/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JSValidator.h"
@interface JSValidatorViewController : UIViewController {
	IBOutlet UITextView * output_;
	JSValidator * validator_;
}

@end
