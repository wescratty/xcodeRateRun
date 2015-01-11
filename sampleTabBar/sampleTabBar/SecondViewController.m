//
//  LocationViewController.m
//  sampleTabBar
//
//  Created by Wes Cratty on 1/2/15.
//  Copyright (c) 2015 Wes Cratty. All rights reserved.
//

#import "SecondViewController.h"
#import <Corelocation/CoreLocation.h>
#import "AppDelegate.h"

static int iterations =0;

@interface SecondViewController ()
<CLLocationManagerDelegate>
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (weak, nonatomic) IBOutlet UILabel *latitude;
@property (weak, nonatomic) IBOutlet UILabel *longitude;
@property (weak, nonatomic) IBOutlet UILabel *seconds;
@property (weak, nonatomic) IBOutlet UILabel *speed;

- (IBAction)buttonPressed:(UIButton*)sender;

@end

@implementation SecondViewController

{
    CLLocationManager *manager;
    CLGeocoder *geocoder;
    CLPlacemark *placmark;
    
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    manager = [[CLLocationManager alloc] init];
    geocoder = [[CLGeocoder alloc] init];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)buttonPressed:(UIButton*)sender {
    
    if ([[sender currentTitle] isEqualToString:@"Start"]) {
        NSLog(@"Pressed start");
        manager.delegate = self;
        if ([manager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
            [manager requestWhenInUseAuthorization];
            //[manager NSLocationWhenInUseUsageDescription];
        }
        manager.desiredAccuracy = kCLLocationAccuracyBest;
        [manager startUpdatingLocation];
        
        
        
    }
    else if ([[sender currentTitle] isEqualToString:@"Stop"]) {
        NSLog(@"Pressed stop");
        [manager stopUpdatingLocation];
        
        
        //}
    }else if ([[sender currentTitle] isEqualToString:@"Reset Data"]) {
        NSLog(@"Pressed Reset Data");
        //int arraySize =[[NSArray sharedInstance] count];
        //        for (int i=0; i<[[NSArray sharedInstance] count]; i++) {
        //            [[NSArray sharedInstance] removeObjectAtIndex:i];
        //        }
        while (0<[[NSArray sharedInstance] count]) {
            int arraySize =(int)[[NSArray sharedInstance] count];
            [[NSArray sharedInstance] removeObjectAtIndex:arraySize-1];
        }
        self.seconds.text =[NSString stringWithFormat:@"%lu",(unsigned long)[[NSArray sharedInstance] count] ];
    }
    
}
//
//#pragma mark CLLocationManagerDelegate Mthods

-(void) locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    NSLog(@"Error: %@",error);
    NSLog(@"Failed to get location :(");
    
}

-(void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation    {
    NSLog(@"Location: %@", newLocation);
    CLLocation *currentLocation = newLocation;
    double speed = newLocation.speed;
    NSLog(@"Speed =%f", speed);
    
    [[NSArray sharedInstance] addObject:[NSNumber numberWithDouble:speed]];
    
    
    iterations++;
    
    if (currentLocation != nil){
        
        self.latitude.text = [NSString stringWithFormat:@"%.8f", currentLocation.coordinate.latitude];
        
        self.longitude.text = [NSString stringWithFormat:@"%.8f", currentLocation.coordinate.longitude];
        //[[NSArray sharedInstance] count]
        self.seconds.text =[NSString stringWithFormat:@"%lu",(unsigned long)[[NSArray sharedInstance] count]-1 ];
        self.speed.text = [NSString stringWithFormat:@"%@", [NSNumber numberWithDouble:speed]];
    }
    [geocoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray *placemarks, NSError *error) {
        if (error == nil && [placemarks count]>0) {
            placemarks = [placemarks lastObject];
            
            
        }else{
            NSLog(@"%@",error.debugDescription);
        }
    }];
    
}

@end

