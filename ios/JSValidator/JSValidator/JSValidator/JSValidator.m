//
//  JSValidator.m
//  JSValidator
//
//  Created by Tyler Casselman on 3/6/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "JSValidator.h"

@interface JSValidator ()
- (NSString*)createHTMLForId:(NSString*)jsId, ...;
@end

@implementation JSValidator

- (void)setXMLURL:(NSString*)url
{	

	NSXMLParser * parser = [[NSXMLParser alloc] initWithContentsOfURL:[NSURL URLWithString:url]];
	[parser setDelegate:self];
	[parser parse];
}

- (id)executeScript:(NSString*)jsId, ...
{
	va_list args;
	va_start(args, jsId);
	NSString * html = [self createHTMLForId:jsId, args];
	va_end(args);
	webView_ = [[UIWebView alloc] init];
	NSString * retVal = [webView_ stringByEvaluatingJavaScriptFromString:html];
	return retVal;
}
	 
- (NSString*)createHTMLForId:(NSString*)jsId, ...
{
	va_list args;
	va_start(args, jsId);
	NSDictionary * script = [scripts_ objectForKey:jsId];
	NSArray * paramNames = [script objectForKey:@"params"];
	NSString * params = [NSString string];
	int i = 0;
	for(NSString * arg = jsId; arg != nil; arg = va_arg(args, NSString *))
	{
		if(i > 0)
		{
			params = [params stringByAppendingFormat:@"%@=%@;",[paramNames objectAtIndex:i - 1], arg];
		}
		i++;
	}
	
	NSString * scriptText = [NSString stringWithFormat:@"%@%@", params, [script objectForKey:@"script"]];

	
	return scriptText;
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qualifiedName attributes:(NSDictionary *)attributeDict
{
	currentElement_ = [elementName retain];
	if([elementName isEqualToString:@"scripts"])
	{
		scripts_ = [[NSMutableDictionary alloc] init];
	}else if([elementName isEqualToString:@"row"])
	{
		currentScript_ = [[NSMutableDictionary alloc] init];
	}else if([elementName isEqualToString:@"params"])
	{
		[currentScript_ setObject:[NSMutableArray array] forKey:@"params"];
	}
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
	if([currentElement_ isEqualToString:@"row"])
	{
		[currentScript_ release];
	}
	[currentElement_ release];
	currentElement_ = nil;
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
	NSString * value = [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
	if([currentElement_ isEqualToString:@"id"])
	{
		[currentScript_ setObject:value forKey:@"id"];
		[scripts_ setObject:currentScript_ forKey:value];
	}else if([currentElement_ isEqualToString:@"script"])
	{
		[currentScript_ setObject:value forKey:@"script"];
	}else if([currentElement_ isEqualToString:@"param"])
	{
		[[currentScript_ objectForKey:@"params"] addObject:value];
	}
	
}


- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
	return NO;
}

@end
