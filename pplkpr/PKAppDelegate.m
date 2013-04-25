//
//  PKAppDelegate.m
//  pplkpr
//
//  Created by Lauren McCarthy on 4/22/13.
//  Copyright (c) 2013 Lauren McCarthy. All rights reserved.
//

#import "PKAppDelegate.h"
#import <CoreLocation/CoreLocation.h>

@implementation PKAppDelegate


@synthesize window;
@synthesize pkViewController;
@synthesize locationManager;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
  
  // Set up the view controller
	PKViewController *aViewController = [[PKViewController alloc] initWithNibName:@"HelloWorld" bundle:[NSBundle mainBundle]];
	self.pkViewController = aViewController;
	[aViewController release];
  
  [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackOpaque];
	
	// Add the view controller's view as a subview of the window
	UIView *controllersView = [pkViewController view];
	[window addSubview:controllersView];
	[window makeKeyAndVisible];
  
  if ([CLLocationManager locationServicesEnabled]) {
    
    if (nil == locationManager)
      locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    
    /*locationManager.desiredAccuracy = kCLLocationAccuracyKilometer;
    locationManager.distanceFilter = 0; // movement threshold for new events
    [locationManager startUpdatingLocation];*/
    
    [locationManager startMonitoringSignificantLocationChanges];
    
  } else {
    
    UIAlertView *servicesDisabledAlert = [[UIAlertView alloc] initWithTitle:@"Location Services Disabled" message:@"You currently have all location services for this device disabled. Please enable them in Settings." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [servicesDisabledAlert show];
    [servicesDisabledAlert release];
    
  }
  return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
  // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
  // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
  // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
  // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
  // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
  // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
  // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
  [locationManager stopMonitoringSignificantLocationChanges];
}


- (void)dealloc {
	[pkViewController release];
	[window release];
  [locationManager release];
  [super dealloc];
}


// Delegate method from the CLLocationManagerDelegate protocol.
- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray *)locations {
  NSLog(@"update\n");
  // If it's a relatively recent event, turn off updates to save power
  CLLocation* location = [locations lastObject];
  NSDate* eventDate = location.timestamp;
  NSTimeInterval howRecent = [eventDate timeIntervalSinceNow];
  //if (abs(howRecent) < 15.0) {
    // If the event is recent, do something with it.
    NSLog(@"latitude %+.6f, longitude %+.6f\n",
          location.coordinate.latitude,
          location.coordinate.longitude);
  
    
    UILocalNotification * theNotification = [[UILocalNotification alloc] init];
    theNotification.alertBody = [NSString stringWithFormat:@"Background location %.06f %.06f %@" , location.coordinate.latitude, location.coordinate.longitude, location.timestamp];
    theNotification.alertAction = @"Ok";
    
    theNotification.fireDate = [NSDate dateWithTimeIntervalSinceNow:1];
    
    [[UIApplication sharedApplication] scheduleLocalNotification:theNotification];
  //}
  
}


- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
  // The location "unknown" error simply means the manager is currently unable to get the location.
  if ([error code] != kCLErrorLocationUnknown) {
    [self stopUpdatingLocation:NSLocalizedString(@"Error", @"Error")];
  }
}

- (void)stopUpdatingLocation:(NSString *)state {
  [locationManager stopMonitoringSignificantLocationChanges];
  locationManager.delegate = nil;
}

- (void)didReceiveLocalNotification:(UILocalNotification *)notification {
  NSLog(@"did you move?");
}


@end
