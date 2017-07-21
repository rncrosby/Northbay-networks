//
//  ViewController.h
//  Northbay Networks
//
//  Created by Robert Crosby on 7/5/17.
//  Copyright © 2017 fully toasted. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "jobObject.h"
#import "References.h"
#import <CloudKit/CloudKit.h>
#import "eventViewController.h"

@interface ViewController : UIViewController {
    NSMutableArray *events,*eventRecords;
    __weak IBOutlet UIScrollView *todayView;
    __weak IBOutlet UILabel *blur;
    __weak IBOutlet UILabel *bottomBlur;
    __weak IBOutlet UIButton *menu;
    __weak IBOutlet UIButton *plus;
    __weak IBOutlet UIButton *refresh;
    UIAlertController *toast;
    __weak IBOutlet UIProgressView *progressBar;
    __weak IBOutlet UILabel *titleBar;
}
- (IBAction)refresh:(id)sender;


@end

