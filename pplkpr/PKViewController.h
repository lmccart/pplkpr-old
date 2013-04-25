//
//  PKViewController.h
//  pplkpr
//
//  Created by Lauren McCarthy on 4/22/13.
//  Copyright (c) 2013 Lauren McCarthy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PKViewController : UIViewController <UITextFieldDelegate> {
	
	IBOutlet UITextField *whoTextField;
	IBOutlet UITextField *howTextField;
  IBOutlet UISlider *ratingSlider;
  IBOutlet UIButton *submitButton;
	IBOutlet UILabel *label;
	NSString *whoString;
  NSString *howString;
}

@property (nonatomic, retain) UITextField *whoTextField;
@property (nonatomic, retain) UITextField *howTextField;
@property (nonatomic, retain) UISlider *ratingSlider;
@property (nonatomic, retain) UIButton *submitButton;
@property (nonatomic, retain) UILabel *label;
@property (nonatomic, copy) NSString *whoString;
@property (nonatomic, copy) NSString *howString;

- (IBAction)sendReport:(id)sender;
- (void)reset;

@end
