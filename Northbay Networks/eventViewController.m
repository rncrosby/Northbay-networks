//
//  eventViewController.m
//  Northbay Networks
//
//  Created by Robert Crosby on 7/20/17.
//  Copyright © 2017 fully toasted. All rights reserved.
//

#import "eventViewController.h"

@interface eventViewController ()

@end

@implementation eventViewController

- (void)viewDidLoad {
    [References createLine:self.view xPos:0 yPos:blur.frame.origin.y+blur.frame.size.height inFront:TRUE];
    [References cornerRadius:map radius:8.0f];
    scroll.contentSize = CGSizeMake([References screenWidth], [self.view viewWithTag:4].frame.origin.y + 1000);
    scroll.frame = CGRectMake(0, 0, [References screenWidth], [References screenHeight]);
    [References blurView:blur];
    titleText.text = _job.company;
    NSArray *plainTime = [_job.plainTime componentsSeparatedByString:@"."];
    weekDay.text = plainTime[0];
    monthDate.text = plainTime[1];
    time.text = plainTime[2];
    [super viewDidLoad];
    [self pullAddress];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)pullAddress {
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder geocodeAddressString:_job.address
                 completionHandler:^(NSArray* placemarks, NSError* error){
                     if (placemarks && placemarks.count > 0) {
                         CLPlacemark *topResult = [placemarks objectAtIndex:0];
                         MKPlacemark *placemark = [[MKPlacemark alloc] initWithPlacemark:topResult];
                         
                         MKCoordinateRegion region = map.region;
                         region.center = placemark.region.center;
                         region.span.longitudeDelta /= 24.0;
                         region.span.latitudeDelta /= 24.0;
                         
                         [map setRegion:region animated:YES];
                         [map addAnnotation:placemark];
                     }
                 }
     ];
}

- (IBAction)confirm:(id _Nonnull)sender {

}

- (IBAction)backButton:(id _Nonnull )sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end