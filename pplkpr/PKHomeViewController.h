//
//  PKHomeViewController.h
//  pplkpr
//
//  Created by Lauren McCarthy on 5/6/13.
//  Copyright (c) 2013 Lauren McCarthy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PKHomeViewController : UIViewController {
  IBOutlet UIButton *arrivingButton;
  IBOutlet UIButton *leavingButton;
}

@property (nonatomic, retain) UIButton *arrivingButton;
@property (nonatomic, retain) UIButton *leavingButton;


- (IBAction)beginReport:(id)sender;

@end


