//
//  createEventViewController.h
//  Northbay Networks
//
//  Created by Robert Crosby on 7/17/17.
//  Copyright © 2017 fully toasted. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "References.h"
#import <MapKit/MapKit.h>
#import "jobObject.h"
#import <CloudKit/CloudKit.h>
#import "itemsCell.h"

@interface createEventViewController : UIViewController <UITextViewDelegate,UITextFieldDelegate,UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource>{
    NSMutableArray *items;
    __weak IBOutlet UILabel *blur;
    __weak IBOutlet UIScrollView *scroll;
    __weak IBOutlet MKMapView *map;
    __weak IBOutlet UITextField *company;
    __weak IBOutlet UITextField *address;
    __weak IBOutlet UITextField *date;
    __weak IBOutlet UIButton *dateDone;
    NSDate *eventDate;
    __weak IBOutlet UILabel *duration;
    __weak IBOutlet UIScrollView *durationScroll;
    __weak IBOutlet UILabel *durationTime;
    __weak IBOutlet UIStepper *durationStep;
    int lastX,oldValue;
    BOOL isDelivery;
    __weak IBOutlet UIButton *createButton;
    __weak IBOutlet UIButton *cancelButton;
    NSString *dateText,*plainText;
    NSString *monthDateIndex;
    double durationNumber,startHour,startMinutes;
    __weak IBOutlet UIProgressView *progress;
    __weak IBOutlet UILabel *titleLabel;
    __weak IBOutlet UITableView *itemTable;
}
- (IBAction)durationStep:(UIStepper*)sender;
- (IBAction)cancel:(id)sender;
- (IBAction)create:(id)sender;
- (IBAction)dateDone:(id)sender;
- (IBAction)changeType:(UISegmentedControl *)sender;

@end
