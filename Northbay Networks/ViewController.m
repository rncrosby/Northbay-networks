//
//  ViewController.m
//  Northbay Networks
//
//  Created by Robert Crosby on 7/5/17.
//  Copyright © 2017 fully toasted. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () {
    NSMutableArray *jobs;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [References blurView:blur];
    [References createLine:self.view xPos:0 yPos:blur.frame.origin.y+blur.frame.size.height inFront:TRUE];
    //[References blurView:bottomBlur];
    //[References createLine:self.view xPos:0 yPos:bottomBlur.frame.origin.y inFront:TRUE];
    
    [super viewDidLoad];
    [References tintUIButton:menu color:[References colorFromHexString:@"#324376"]];
    [References tintUIButton:plus color:[References colorFromHexString:@"#324376"]];
    [References tintUIButton:refresh color:[References colorFromHexString:@"#324376"]];
    [self getEvents];
    // Do any additional setup after loading the view, typically from a nib.
}

-(NSString *)string:(NSString*)string ByReplacingACharacterAtIndex:(int)i byCharacter:(NSString*)StringContainingAChar{
    
    return [string stringByReplacingCharactersInRange:NSMakeRange(i, 1) withString:StringContainingAChar];
    
}

-(void)createHours {
    NSArray *words = [[NSArray alloc] initWithObjects:@"1 AM", @"2 AM",@"3 AM", @"4 AM", @"5 AM", @"6 AM", @"7 AM",@"8 AM",@"9 AM",@"10 AM",@"11 AM",@"Noon",@"1 PM",@"2 PM", @"3 PM", @"4 PM", @"5 PM",@"6 PM", @"7 PM", @"8 PM", @"9 PM", @"10 PM", @"11 PM", nil];
    for (int a = 0; a < words.count; a++) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 100*a, 35, 8)];
        label.textColor = [[UIColor blackColor] colorWithAlphaComponent:0.5f];
        [References createLine:todayView xPos:label.frame.origin.x+label.frame.size.width+8 yPos:label.frame.origin.y+(label.frame.size.height/2) inFront:FALSE];
        label.font = [UIFont boldSystemFontOfSize:9];
        label.textAlignment = NSTextAlignmentRight;
        label.text = words[a];
        [todayView addSubview:label];
    }
    todayView.contentSize = CGSizeMake([References screenWidth], 100*words.count);
    [todayView setContentOffset:CGPointMake(0,525)];
}

-(void)createEvent:(jobObject*)job andIndex:(int)index{
    int minutes = 0;
    if (job.minutes == 0) {
        minutes = 0;
    } else {
        minutes = (job.minutes.intValue)/60;
    }
    int y = ((100*job.hour.intValue-1)+5) + (100*minutes) + 5-99;
    float height = (job.duration.doubleValue*1.6666666)-10;
    UILabel *card = [[UILabel alloc] initWithFrame:CGRectMake(8+35, y, [References screenWidth]-8-35-8, height)];
    UIButton *button = [[UIButton alloc] initWithFrame:card.frame];
    [button addTarget:self action:@selector(openEvent:) forControlEvents:UIControlEventTouchUpInside];
    [button setTitle:@"" forState:UIControlStateNormal];
    [button setTag:index];
    [todayView addSubview:button];
    card.backgroundColor = [References colorFromHexString:@"#324376"];
    UILabel *shadowCard = [[UILabel alloc] initWithFrame:CGRectMake(8+35+5, y+5, [References screenWidth]-8-35-8-10, height-10)];
    [References cornerRadius:card radius:8.0f];
    shadowCard.backgroundColor = [UIColor whiteColor];
    [References lightCardShadow:shadowCard];
    [todayView addSubview:shadowCard];
    [todayView sendSubviewToBack:shadowCard];
    [todayView addSubview:card];
    [todayView bringSubviewToFront:card];
    [todayView bringSubviewToFront:button];
    if (height > 25) {
        UILabel *person = [[UILabel alloc] initWithFrame:CGRectMake(card.frame.origin.x+4, card.frame.origin.y+(card.frame.size.height/2)-15, card.frame.size.width-8, 20)];
        person.textColor = [UIColor whiteColor];
        person.font = [UIFont boldSystemFontOfSize:15];
        person.textAlignment = NSTextAlignmentLeft;
        person.text = job.person;
        [todayView addSubview:person];
        [todayView bringSubviewToFront:person];
        UILabel *subline = [[UILabel alloc] initWithFrame:CGRectMake(card.frame.origin.x+4, card.frame.origin.y+(card.frame.size.height/2)+5, card.frame.size.width-8, 10)];
        subline.textColor = [UIColor whiteColor];
        subline.font = [UIFont boldSystemFontOfSize:9];
        subline.textAlignment = NSTextAlignmentLeft;
        subline.text = job.address;
        [todayView addSubview:subline];
        [todayView bringSubviewToFront:subline];
        UIImageView *forward = [[UIImageView alloc] initWithFrame:CGRectMake(card.frame.origin.x+card.frame.size.width-30, card.frame.origin.y+(card.frame.size.height/2)-12, 20, 25)];
        [forward setImage:[UIImage imageNamed:@"forward.png"]];
        [todayView addSubview:forward];
        [todayView bringSubviewToFront:forward];
    }
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 4;
}

-(void)getEvents {
    [References fadeIn:progressBar];
    [References fadeLabelText:titleBar newText:@"Pulling Schedule..."];
    [progressBar setProgress:0.5 animated:YES];
    for (UIView *v in todayView.subviews) {
        if (![v isKindOfClass:[UIImageView class]]) {
            [v removeFromSuperview];
        }
    }
    [self createHours];
    //NSString *string = [NSString stringWithFormat:@"person = '%@'",username.text];
    NSString *string = @"TRUEPREDICATE";
    CKContainer *defaultContainer = [CKContainer defaultContainer];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:string];
    CKDatabase *publicDatabase = [defaultContainer publicCloudDatabase];
    CKQuery *query = [[CKQuery alloc] initWithRecordType:@"Events" predicate:predicate];
    [publicDatabase performQuery:query inZoneWithID:nil completionHandler:^(NSArray *results, NSError *error) {
        if (!error) {
            if (results.count == 0) {
                [progressBar setProgress:1 animated:YES];
                dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 0.5 * NSEC_PER_SEC);
                
                dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                    [References fadeOut:progressBar];
                    [References fadeLabelText:titleBar newText:@"Today"];
                    
                });
            } else {
            events = [[NSMutableArray alloc] init];
            for (int a = 0; a < results.count; a++) {
                CKRecord *record = results[a];
                NSNumber *hour = [record valueForKey:@"hour"];
                NSNumber *minutes = [record valueForKey:@"minutes"];
                NSNumber *duration = [record valueForKey:@"duration"];
                jobObject *job = [[jobObject alloc] initWithType:[record valueForKey:@"type"] andPerson:[record valueForKey:@"person"] andAddress:[record valueForKey:@"address"] andCompany:[record valueForKey:@"company"] andDate:[record valueForKey:@"seconds"] andHour:hour andMinutes:minutes andDuration:duration andInfo:[record valueForKey:@"info"] andDateIndex:[record valueForKey:@"dateIndex"] andPlainTime:[record valueForKey:@"plainTime"]];
                [events addObject:job];
                dispatch_async(dispatch_get_main_queue(), ^(void){
                    for (int a = 0; a < events.count; a++) {
                        [self createEvent:events[a] andIndex:a];
                    }
                        [progressBar setProgress:1 animated:YES];
                    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 0.5 * NSEC_PER_SEC);
                    
                    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                        [References fadeOut:progressBar];
                        [References fadeLabelText:titleBar newText:@"Today"];
                        [progressBar setProgress:0];
                    });
                    
                    
                    
                     });
            }
            }
        } else {
            NSLog(@"%@",error.localizedDescription);
        }
    }];
}

- (IBAction)refresh:(id)sender {
    [self getEvents];
}

-(void)openEvent:(UIButton *)sender
{
    int index = (int)sender.tag;
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    eventViewController *viewController = (eventViewController *)[storyboard instantiateViewControllerWithIdentifier:@"eventViewController"];
    viewController.job = events[index];
    [self presentViewController:viewController animated:YES completion:nil];
}
@end
