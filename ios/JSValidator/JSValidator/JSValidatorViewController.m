//
//  JSValidatorViewController.m
//  JSValidator
//
//  Created by Tyler Casselman on 3/6/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "JSValidatorViewController.h"
#import "JSValidator.h"
@implementation JSValidatorViewController

- (void)dealloc
{
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
	validator_ = [[JSValidator alloc] init];
	[validator_ setXMLURL:@"http://localhost/jsvalidator/php/js.xml"];
	NSArray * jsIds = [NSArray arrayWithObjects:@"1", @"2", @"3", nil];
	NSString * output = @"";
	for (NSString * jsId in jsIds) {
		NSString * result = [validator_ executeScript:jsId, @"3", @"4", nil];
		output = [NSString stringWithFormat:@"%@ Script #: %@ result: %@\n", output, jsId, result];
	}
	output_.text = output;
	

}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
