//
//  createEventViewController.m
//  Northbay Networks
//
//  Created by Robert Crosby on 7/17/17.
//  Copyright © 2017 fully toasted. All rights reserved.
//

#import "createEventViewController.h"

@interface createEventViewController ()

@end

@implementation createEventViewController

- (void)viewDidLoad {
    items = [[NSMutableArray alloc] init];
    durationNumber = 0.25;
    isDelivery = YES;
    oldValue = 0;
    durationScroll.contentSize = CGSizeMake(1200, durationScroll.frame.size.height);
    durationScroll.contentOffset = CGPointMake(600, 0);
    lastX = 600;
    scroll.contentSize = CGSizeMake([References screenWidth], [self.view viewWithTag:4].frame.origin.y + 1000);
    scroll.frame = CGRectMake(0, 0, [References screenWidth], [References screenHeight]);
    [References cornerRadius:map radius:8.0f];
    [References cornerRadius:duration radius:8.0f];
    [References blurView:blur];
    [References createLine:self.view xPos:0 yPos:blur.frame.origin.y+blur.frame.size.height inFront:TRUE];
    [super viewDidLoad];
    UIDatePicker *datePicker = [[UIDatePicker alloc]init];
    [datePicker setDatePickerMode:UIDatePickerModeDateAndTime];
    [datePicker setDate:[NSDate date]];
    [datePicker addTarget:self action:@selector(updateTextField:) forControlEvents:UIControlEventValueChanged];
    UIToolbar* keyboardDoneButtonView = [[UIToolbar alloc] init];
    keyboardDoneButtonView.barStyle = UIBarStyleDefault;
    keyboardDoneButtonView.translucent = YES;
    keyboardDoneButtonView.tintColor = nil;
    [keyboardDoneButtonView sizeToFit];
    UIBarButtonItem* doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Done"
                                                                    style:UIBarButtonItemStyleDone target:self
                                                                   action:@selector(pickerDoneClicked:)];
    [doneButton setTintColor:[[[UIApplication sharedApplication] delegate] window].tintColor];
    UIBarButtonItem *flex = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    [keyboardDoneButtonView setItems:[NSArray arrayWithObjects:flex,doneButton,flex, nil]];
    
    date.inputAccessoryView = keyboardDoneButtonView;
    [date setInputView:datePicker];
    
    // Do any additional setup after loading the view.
}

- (IBAction)pickerDoneClicked:(id)sender {
    [date resignFirstResponder];
}

-(void)changeDateFromLabel:(id)sender
{
    [date resignFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if (textField.tag == 3) {
        dateDone.alpha = 1;
    } else if (textField.tag == 4) {
        [UIView animateWithDuration:1 animations:^ {
            [scroll setContentOffset:CGPointMake(0, [self.view viewWithTag:4].frame.origin.y-100) animated:NO];
        }];
        
    }
    return YES;
}

-(bool)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    if (textField.tag == 2) {
        NSString *location =textField.text;
        CLGeocoder *geocoder = [[CLGeocoder alloc] init];
        [geocoder geocodeAddressString:location
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
    if (textField.tag == 4) {
        if (textField.text.length > 0) {
            [items addObject:textField.text];
            [itemTable reloadData];
            itemTable.frame = CGRectMake(itemTable.frame.origin.x, itemTable.frame.origin.y, itemTable.frame.size.width, 36*items.count);
            [textField setText:@""];
        }
    }
    return YES;
}

-(void)updateTextField:(id)sender
{
    UIDatePicker *picker = (UIDatePicker*)date.inputView;
    NSDateFormatter * formatter =  [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"eee, MM/dd"];
    NSString *dateString = [formatter stringFromDate:picker.date];
    [formatter setDateFormat:@"h:mm a"];
    NSString *timeString = [formatter stringFromDate:picker.date];
    [formatter setDateFormat:@"MM/dd"];
    dateText = [formatter stringFromDate:picker.date];
    [formatter setDateFormat:@"HH"];
    NSString *hourStart = [formatter stringFromDate:picker.date];
    [formatter setDateFormat:@"mm"];
    NSString *minuteStart = [formatter stringFromDate:picker.date];
    startHour = hourStart.doubleValue;
    startMinutes = minuteStart.doubleValue;
    date.text = [NSString stringWithFormat:@"%@ at %@",dateString,timeString];
}

- (IBAction)durationStep:(UIStepper*)sender {
    if (sender.value > oldValue) {
        if (duration.frame.size.width <= 220) {
            for (int a = 0; a < 20; a++) {
                duration.frame = CGRectMake(duration.frame.origin.x, duration.frame.origin.y, duration.frame.size.width+1, duration.frame.size.height);
            }
        }
        
    } else {
        if (duration.frame.size.width > 44) {
            for (int a = 0; a < 20; a++) {
                duration.frame = CGRectMake(duration.frame.origin.x, duration.frame.origin.y, duration.frame.size.width-1, duration.frame.size.height);
            }
        }
    }
    duration.text = [self timeConvert];
    oldValue = [sender value];
}

- (IBAction)cancel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)create:(id)sender {
    [References fadeIn:progress];
    [References fadeLabelText:titleLabel newText:@"Creating Event..."];
    [progress setProgress:0.5 animated:YES];
    CKRecordID *recordID = [[CKRecordID alloc] initWithRecordName:[NSString stringWithFormat:@"%i",arc4random() %500]];
    CKRecord *postRecord = [[CKRecord alloc] initWithRecordType:@"Events" recordID:recordID];
    postRecord[@"type"] = @"DELIVERY";
    postRecord[@"person"] = @"Rob";
    postRecord[@"address"] = address.text;
    postRecord[@"company"] = company.text;
    postRecord[@"date"] = dateText;
    postRecord[@"hour"] = [NSNumber numberWithDouble:startHour];
    postRecord[@"minutes"] = [NSNumber numberWithDouble:startMinutes];
    postRecord[@"duration"] = [NSNumber numberWithDouble:durationNumber];
    postRecord[@"info"] = @"Info";
    CKDatabase *publicDatabase = [[CKContainer defaultContainer] publicCloudDatabase];
    [publicDatabase saveRecord:postRecord completionHandler:^(CKRecord *record, NSError *error) {
        if(error) {
            NSLog(@"%@",error.localizedDescription);
        } else {
            [References fadeLabelText:titleLabel newText:@"Event Created"];
            [progress setProgress:1 animated:YES];
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 0.5 * NSEC_PER_SEC);
            
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                [References fadeOut:progress];
                [self dismissViewControllerAnimated:YES completion:nil];
                
            });
        }
    }];
}

- (IBAction)dateDone:(id)sender {
    UIDatePicker *picker = (UIDatePicker*)date.inputView;
    eventDate = picker.date;
    dateDone.alpha = 0;
    [date resignFirstResponder];
}

- (IBAction)changeType:(UISegmentedControl *)sender {
    if ([sender selectedSegmentIndex] == 1) {
        [sender setTintColor:[References colorFromHexString:@"#2A9D8F"]];
        duration.backgroundColor = [References colorFromHexString:@"#2A9D8F"];
        [durationStep setTintColor:[References colorFromHexString:@"#2A9D8F"]];
        [createButton setTitleColor:[References colorFromHexString:@"#2A9D8F"] forState:UIControlStateNormal];
        [cancelButton setTitleColor:[References colorFromHexString:@"#2A9D8F"] forState:UIControlStateNormal];
    }
    if ([sender selectedSegmentIndex] == 0) {
        [sender setTintColor:[References colorFromHexString:@"#324376"]];
        duration.backgroundColor = [References colorFromHexString:@"#324376"];
        [durationStep setTintColor:[References colorFromHexString:@"#324376"]];
        [createButton setTitleColor:[References colorFromHexString:@"#324376"] forState:UIControlStateNormal];
        [cancelButton setTitleColor:[References colorFromHexString:@"#324376"] forState:UIControlStateNormal];
    }
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if ((int)scrollView.contentOffset.x > lastX) {
        if (duration.frame.size.width >= 44) {
            duration.frame = CGRectMake(duration.frame.origin.x, duration.frame.origin.y, duration.frame.size.width-5, duration.frame.size.height);
            }
    } else {
        if (duration.frame.size.width <= 241) {
            duration.frame = CGRectMake(duration.frame.origin.x, duration.frame.origin.y, duration.frame.size.width+5, duration.frame.size.height);;
        }
    }
    durationStep.value = 50;
    lastX = (int)scrollView.contentOffset.x;
    duration.text = [self timeConvert];
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    scrollView.contentOffset = CGPointMake(600, 0);
}

-(NSString*)timeConvert {
    int width = duration.frame.size.width;
    if (width <= 40) {
        durationNumber = 15;
        return @"00:15";
    } else if (width > 40 && width <= 60) {
        durationNumber = 30;
        return @"00:30";
    }
    else if (width > 60 && width <= 80) {
        durationNumber = 45;
        return @"00:45";
        
    }
    else if (width > 80 && width <= 100) {
        durationNumber = 60;
        return @"01:00";
    }
    else if (width > 100 && width <= 120) {
        durationNumber = 75;
        return @"01:15";
    }
    else if (width > 120 && width <= 140) {
        durationNumber = 90;
        return @"01:30";
    }
    else if (width > 140 && width <= 180) {
        durationNumber = 120;
        return @"02:00";
    }
    else if (width > 180 && width <= 200) {
        durationNumber = 135;
        return @"02:15";
    }
    else if (width > 180 && width <= 220) {
       durationNumber = 150;
        return @"02:30";
    }
    else if (width > 220 && width <= 239) {
        durationNumber = 180;
        return @"03:00";
    }
    else {
        durationNumber = 240;
        return @"All Day";
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 36;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (items.count == 0) {
        return 1;
    } else {
        return items.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"itemsCell";
    
    itemsCell *cell = (itemsCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"itemsCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    if (items.count > 0) {
            cell.itemText.text = items[indexPath.row];
    }

    
    return cell;
}
@end
