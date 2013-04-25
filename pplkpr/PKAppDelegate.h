//
//  PKAppDelegate.h
//  pplkpr
//
//  Created by Lauren McCarthy on 4/22/13.
//  Copyright (c) 2013 Lauren McCarthy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

#import "PKViewController.h"


@class PKViewController;

@interface PKAppDelegate : UIResponder <UIApplicationDelegate, CLLocationManagerDelegate> {
  IBOutlet UIWindow *window;
  PKViewController *pkViewController;
  CLLocationManager *locationManager;
}

@property (nonatomic, retain) UIWindow *window;
@property (nonatomic, retain) PKViewController *pkViewController;
@property (nonatomic, retain) CLLocationManager *locationManager;

- (void)stopUpdatingLocation:(NSString *)state;

@end
