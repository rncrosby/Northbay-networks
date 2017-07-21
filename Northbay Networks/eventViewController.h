//
//  eventViewController.h
//  Northbay Networks
//
//  Created by Robert Crosby on 7/20/17.
//  Copyright © 2017 fully toasted. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "References.h"
#import "ViewController.h"
#import <MapKit/MapKit.h>

@interface eventViewController : UIViewController
{
    IBOutlet UILabel *blur;
    IBOutlet UILabel *titleText;
    IBOutlet UILabel *weekDay;
    IBOutlet UILabel *monthDate;
    IBOutlet UILabel *time;
    IBOutlet MKMapView *map;
    IBOutlet UIScrollView *scroll;
    IBOutlet UIButton *confirm;
}

- (IBAction)confirm:(id _Nonnull )sender;
- (IBAction)backButton:(id _Nonnull )sender;
@property (nonatomic, nonnull) jobObject *job;
@end
