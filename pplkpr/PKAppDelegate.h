//
//  PKAppDelegate.h
//  pplkpr
//
//  Created by Lauren McCarthy on 4/22/13.
//  Copyright (c) 2013 Lauren McCarthy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <FacebookSDK/FacebookSDK.h>

#import "PKViewController.h"
#import "FPViewController.h"


@class PKViewController;
@class FPViewController;

@interface PKAppDelegate : UIResponder <UIApplicationDelegate, CLLocationManagerDelegate> {
  IBOutlet UIWindow *window;
  UINavigationController *navigationController;
  PKViewController *pkViewController;
  FPViewController *fpViewController;
  CLLocationManager *locationManager;
}

@property (nonatomic, retain) UIWindow *window;
@property (nonatomic, retain) UINavigationController *navigationController;
@property (nonatomic, retain) PKViewController *pkViewController;
@property (nonatomic, retain) FPViewController *fpViewController;
@property (nonatomic, retain) CLLocationManager *locationManager;

- (void)stopUpdatingLocation:(NSString *)state;

@end
