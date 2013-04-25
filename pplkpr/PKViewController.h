//
//  PKViewController.h
//  pplkpr
//
//  Created by Lauren McCarthy on 4/22/13.
//  Copyright (c) 2013 Lauren McCarthy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PKViewController : UIViewController <UITextFieldDelegate> {
	
	IBOutlet UITextField *textField;
	IBOutlet UILabel *label;
	NSString *string;
}

@property (nonatomic, retain) UITextField *textField;
@property (nonatomic, retain) UILabel *label;
@property (nonatomic, copy) NSString *string;

- (void)updateString;

@end
