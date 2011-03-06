//
//  JSValidator.h
//  JSValidator
//
//  Created by Tyler Casselman on 3/6/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface JSValidator : NSObject<NSXMLParserDelegate> {
	UIWebView * webView_;
    NSMutableDictionary * scripts_;
	NSString * currentElement_;
	NSMutableDictionary * currentScript_;
}
- (void)setXMLURL:(NSString*)url;
- (id)executeScript:(NSString*)jsId, ...;
@end
