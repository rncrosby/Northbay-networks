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
    [References cornerRadius:signatureView radius:8.0f];
    [References cornerRadius:confirm radius:8.0f];
    scroll.contentSize = CGSizeMake([References screenWidth], [self.view viewWithTag:5].frame.origin.y + [self.view viewWithTag:5].frame.size.height + 8);
    scroll.frame = CGRectMake(0, 0, [References screenWidth], [References screenHeight]);
    [References blurView:blur];
    titleText.text = _job.company;
    NSArray *plainTime = [_job.plainTime componentsSeparatedByString:@"."];
    weekDay.text = plainTime[0];
    monthDate.text = plainTime[1];
    time.text = plainTime[2];
    [super viewDidLoad];
    [self pullAddress];
    if (_job.isComplete.intValue == 0) {
        EAGLContext *context = [[EAGLContext alloc]initWithAPI:kEAGLRenderingAPIOpenGLES2];
        sign = [[PPSSignatureView alloc] initWithFrame:CGRectMake(0, 0, signatureView.frame.size.width, signatureView.frame.size.width) context:context];
        GLKViewController *glkView = [[GLKViewController alloc] init];
        glkView.view = sign;
        [signatureView addSubview:glkView.view];
    } else {
        UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, signatureView.frame.size.width, signatureView.frame.size.height)];
        signatureView.frame = CGRectMake(signatureView.frame.origin.x, signatureView.frame.origin.y, signatureView.frame.size.width, signatureView.frame.size.height/2);
        confirm.frame = CGRectMake(confirm.frame.origin.x, confirm.frame.origin.y-signatureView.frame.size.height, confirm.frame.size.width, confirm.frame.size.height);
        [confirm setBackgroundColor:[References colorFromHexString:@"#009688"]];
        [confirm setTitle:@"View Invoice" forState:UIControlStateNormal];
        [image setContentMode:UIViewContentModeRedraw];
        [image setImage:[self decodeBase64ToImage:_job.signature]];
        [signatureView addSubview:image];
        [signatureView bringSubviewToFront:image];
    }
    
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
    if (_job.isComplete.intValue == 1) {
        [References toastMessage:@"Coming Soon" andView:self];
    } else {
    NSLog(@"%@",[self base64String:sign.signatureImage]);
    _record[@"signature"] = [self base64String:sign.signatureImage];
     _record[@"isComplete"] = [NSNumber numberWithBool:YES];
    CKModifyRecordsOperation *modifyRecords= [[CKModifyRecordsOperation alloc]
                                              initWithRecordsToSave:[[NSArray alloc] initWithObjects:_record, nil] recordIDsToDelete:nil];
    modifyRecords.savePolicy=CKRecordSaveAllKeys;
    modifyRecords.qualityOfService=NSQualityOfServiceUserInitiated;
    modifyRecords.modifyRecordsCompletionBlock=
    ^(NSArray * savedRecords, NSArray * deletedRecordIDs, NSError * operationError){
        //   the completion block code here
        dispatch_async(dispatch_get_main_queue(), ^(void){
            [References toastMessage:@"Delivery Complete!" andView:self];
            });
    };
    CKContainer *defaultContainer = [CKContainer defaultContainer];
    [[defaultContainer publicCloudDatabase] addOperation:modifyRecords];
    }
}

 - (NSString *)base64String :(UIImage*)image{
    return [UIImagePNGRepresentation(image) base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
}

- (UIImage *)decodeBase64ToImage:(NSString *)strEncodeData {
    NSData *data = [[NSData alloc]initWithBase64EncodedString:strEncodeData options:NSDataBase64DecodingIgnoreUnknownCharacters];
    return [UIImage imageWithData:data];
}

- (IBAction)backButton:(id _Nonnull )sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 36;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (_job.items.count == 0) {
        return 1;
    } else {
        table.frame = CGRectMake(table.frame.origin.x, table.frame.origin.y, table.frame.size.width, 36*_job.items.count);
        return _job.items.count;
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
    cell.backgroundColor = [UIColor clearColor];
    if (_job.items.count > 0) {
        cell.itemText.text = _job.items[indexPath.row];
        
    }
    
    
    return cell;
}
@end
