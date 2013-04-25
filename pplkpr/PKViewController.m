//
//  PKViewController.m
//  pplkpr
//
//  Created by Lauren McCarthy on 4/22/13.
//  Copyright (c) 2013 Lauren McCarthy. All rights reserved.
//

#import "PKViewController.h"


@implementation PKViewController

@synthesize textField;
@synthesize label;
@synthesize string;

- (void)viewDidLoad {
  // When the user starts typing, show the clear button in the text field.
  textField.clearButtonMode = UITextFieldViewModeWhileEditing;
  // When the view first loads, display the placeholder text that's in the
  // text field in the label.
  label.text = textField.placeholder;
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
	[textField release];
	[label release];
  [super dealloc];
}


- (void)updateString {
	
	// Store the text of the text field in the 'string' instance variable.
	self.string = textField.text;
  // Set the text of the label to the value of the 'string' instance variable.
	label.text = self.string;
}


- (BOOL)textFieldShouldReturn:(UITextField *)theTextField {
	// When the user presses return, take focus away from the text field so that the keyboard is dismissed.
	if (theTextField == textField) {
		[textField resignFirstResponder];
    // Invoke the method that changes the greeting.
    [self updateString];
	}
	return YES;
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
  // Dismiss the keyboard when the view outside the text field is touched.
  [textField resignFirstResponder];
  // Revert the text field to the previous value.
  textField.text = self.string;
  [super touchesBegan:touches withEvent:event];
}





@end
