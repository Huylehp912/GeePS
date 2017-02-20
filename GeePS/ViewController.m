//
//  ViewController.m
//  GeePS
//
//  Created by LinuxPlus on 2/16/17.
//  Copyright © 2017 LinuxPlus. All rights reserved.
//

#import "ViewController.h"
#import "MBProgressHUD.h"
@interface ViewController () <CLLocationManagerDelegate>
@property (weak, nonatomic) IBOutlet UIButton *btnLogin;
@property (weak, nonatomic) IBOutlet UILabel *lblLatitude;
@property (weak, nonatomic) IBOutlet UILabel *lblLongitude;
@property (weak, nonatomic) IBOutlet UILabel *lblaltitude;
@property (weak, nonatomic) IBOutlet UILabel *lblSpeed;
@property (strong, nonatomic) CLLocationManager *locationManager;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [_btnLogin setTitle:@"Get GPS Location" forState:UIControlStateNormal];
    [_btnLogin setHidden:YES];
//    if ([self checkRequiredDevice] == true)
        [self startStandardUpdates];
    // Do any additional setup after loading the view, typically from a nib.
}

- (BOOL)checkRequiredDevice {
    if ([CLLocationManager locationServicesEnabled] == true) {
        NSLog(@"Enabled");
        return true;
    } else {
        NSLog(@"Disabled");
        return false;
    }
}
- (void)startStandardUpdates {
    if (_locationManager == nil) {
        _locationManager = [[CLLocationManager alloc] init];
    }
    if ([_locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)])
        [_locationManager requestWhenInUseAuthorization];
    _locationManager.delegate = self;
    _locationManager.desiredAccuracy = kCLLocationAccuracyBest;

    [_locationManager startUpdatingLocation];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}

- (void)startSignificantChangeUpdates {
    if (self.locationManager == nil) {
        self.locationManager = [[CLLocationManager alloc] init];
    }
    if ([_locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)])
        [_locationManager requestWhenInUseAuthorization];
    self.locationManager.delegate = self;
    [self.locationManager startMonitoringSignificantLocationChanges];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)actShowLocation:(id)sender {
    [_lblLatitude setText:@"123"];
    [_lblLongitude setText:@"456"];
}

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"didFailWithError: %@", error);
    UIAlertView *errorAlert = [[UIAlertView alloc]
                               initWithTitle:@"Error" message:@"Failed to Get Your Location" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [errorAlert show];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    CLLocation *location = [locations lastObject];
    NSDate* eventDate = location.timestamp;
    NSTimeInterval interval = [eventDate timeIntervalSinceNow];
    NSLog(@"interval %f\n", abs(interval));
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        if (location != nil) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            NSLog(@"latitude %+.6f, longitude %+.6f\n", location.coordinate.latitude, location.coordinate.longitude);
            [_lblLongitude setText:[NSString stringWithFormat:@"Longitude: %+.6f", location.coordinate.longitude]];
            [_lblLatitude setText:[NSString stringWithFormat:@"Latitude: %+.6f", location.coordinate.latitude]];
            [_lblaltitude setText:[NSString stringWithFormat:@"Altitude: %.0f m", location.altitude]];
            [_lblSpeed setText:[NSString stringWithFormat:@"Speed: %.1f m/s", location.speed]];
        }
    });
//    if (abs(interval) < 5) {
//
//    }
}
@end
