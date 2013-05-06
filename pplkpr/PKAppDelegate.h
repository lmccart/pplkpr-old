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

#import "PKHomeViewController.h"
#import "PKReportViewController.h"

@class PKHomeViewController;
@class PKReportViewController;

@interface PKAppDelegate : UIResponder <UIApplicationDelegate, CLLocationManagerDelegate, UITabBarControllerDelegate> {
  IBOutlet UIWindow *window;
  PKHomeViewController *homeViewController;
  PKReportViewController *reportViewController;
  UITabBarController *tabBarController;
  CLLocationManager *locationManager;
}

@property (nonatomic, retain) UIWindow *window;
@property (nonatomic, retain) PKHomeViewController *homeViewController;
@property (nonatomic, retain) PKReportViewController *reportViewController;
@property (strong, nonatomic) UITabBarController *tabBarController;
@property (nonatomic, retain) CLLocationManager *locationManager;

- (void)stopUpdatingLocation:(NSString *)state;

@end
