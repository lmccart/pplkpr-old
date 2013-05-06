//
//  PKFirstViewController.m
//  fff
//
//  Created by Lauren McCarthy on 5/6/13.
//  Copyright (c) 2013 Lauren McCarthy. All rights reserved.
//

#import "PKHomeViewController.h"
#import "PKAppDelegate.h"



@implementation PKHomeViewController


@synthesize arrivingButton;
@synthesize leavingButton;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
      self.title = NSLocalizedString(@"First", @"First");
      self.tabBarItem.image = [UIImage imageNamed:@"first"];
    }
    return self;
}
							
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
  [arrivingButton release];
  [leavingButton release];
  [super dealloc];
}


- (IBAction)beginReport:(id)sender {
  PKAppDelegate *appDelegate = (PKAppDelegate*) [[UIApplication sharedApplication] delegate];
  [appDelegate.tabBarController setSelectedIndex:1];
  appDelegate.reportViewController.mode = [sender tag];
}

@end

