//
//  PKViewController.m
//  pplkpr
//
//  Created by Lauren McCarthy on 4/22/13.
//  Copyright (c) 2013 Lauren McCarthy. All rights reserved.
//

#import "PKViewController.h"


@implementation PKViewController

@synthesize whoTextField;
@synthesize howTextField;
@synthesize ratingSlider;
@synthesize submitButton;
@synthesize label;
@synthesize whoString;
@synthesize howString;

- (void)viewDidLoad {
  // When the user starts typing, show the clear button in the text field.
  whoTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
  howTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
  // When the view first loads, display the placeholder text that's in the
  // text field in the label.
  label.text = whoTextField.placeholder;
  [super viewDidLoad];
}

/*
 * The view hierarchy for this controller has been torn down. This usually happens in response to low memory notifications.
 * All IBOutlets should be released by setting their property to nil in order to free up as much memory as possible.
 * This is also a good place to release other variables that can be recreated when needed.
 */
- (void)viewDidUnload {
}

- (void)dealloc {
	[whoTextField release];
	[howTextField release];
  [ratingSlider release];
  [submitButton release];
	[whoString release];
  [howString release];
  [super dealloc];
}


- (IBAction)sendReport:(id)sender {
	
	// Store the text of the text field in the 'string' instance variable.
	self.whoString = whoTextField.text;
	self.howString = howTextField.text;
  // Set the text of the label to the value of the 'string' instance variable.

  
  NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:@"http://pplkpr.nodejitsu.com/report?who=%@&how=%@&rating=%f", whoTextField.text, howTextField.text, ratingSlider.value]];
  NSURLRequest *theRequest=[NSURLRequest requestWithURL:URL
                                            cachePolicy:NSURLRequestUseProtocolCachePolicy
                                        timeoutInterval:60.0];
  
 
  // create the connection with the request
  // and start loading the data
  NSURLConnection *theConnection=[[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
  if (theConnection) {
    // Create the NSMutableData to hold the received data.
    // receivedData is an instance variable declared elsewhere.
    //label.text = [[NSString alloc] initWithData:[[NSMutableData data] retain] encoding:NSUTF8StringEncoding];
    label.text = @"success";
    [self reset];
  } else {
    // Inform the user that the connection failed.
    label.text = @"fail";
  }
  
}

- (void)reset {
  whoTextField.text = @"";
  howTextField.text = @"";
  self.whoString = @"";
  self.howString = @"";
  ratingSlider.value = 0.5;
}

- (BOOL)textFieldShouldReturn:(UITextField *)theTextField {
	if (theTextField == whoTextField) {
		[whoTextField resignFirstResponder];
	} else if (theTextField == howTextField) {
    [howTextField resignFirstResponder];
  }
	return YES;
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
  [whoTextField resignFirstResponder];
  whoTextField.text = self.whoString;
  [howTextField resignFirstResponder];
  howTextField.text = self.howString;
  [super touchesBegan:touches withEvent:event];
}




@end
