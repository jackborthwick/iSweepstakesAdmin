//
//  ViewController.m
//  iSweepstakesAdmin
//
//  Created by Jack Borthwick on 7/1/15.
//  Copyright (c) 2015 Jack Borthwick. All rights reserved.
//

#import "ViewController.h"
#import <Parse/Parse.h>
#import "Entries.h"
@interface ViewController ()

@property (nonatomic, strong) NSMutableArray                *entryArray;
@property (nonatomic, strong) IBOutlet UITableView          *tableView;
@property (nonatomic, strong) IBOutlet UISegmentedControl   *sortControl;
@property (nonatomic,strong) IBOutlet UIView                *menuView;
@property (nonatomic, strong) IBOutlet UIDatePicker         *startDatePicker;
@property (nonatomic, strong) IBOutlet UIDatePicker         *endDatePicker;
@property (nonatomic, strong) NSMutableArray                *eligibleToWinMutArray;
@property (nonatomic, strong) Entries                       *winner;


@end

@implementation ViewController

#pragma mark - animation methods

- (IBAction)toggleMenuView:(id)sender {
    NSLog(@"toggle");
    if(_menuView.hidden) {
        [_menuView setHidden:false];
        [UIView animateWithDuration:0.5 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            [_menuView setFrame:CGRectMake(_menuView.frame.origin.x, 65.0, _menuView.frame.size.width, _menuView.frame.size.height)];
        }completion:nil];
    }
    else {
        [UIView animateWithDuration:0.5 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            [_menuView setFrame:CGRectMake(_menuView.frame.origin.x, -1*_menuView.frame.size.height, _menuView.frame.size.width, _menuView.frame.size.height)];
        }completion:^(BOOL finished){
            [_menuView setHidden:true];
        }];
    }
    [_tableView reloadData];
}


#pragma mark - interactivity methods

- (IBAction)sortControlSelected:(id)sender {
    NSLog(@"sort chosen: %i",_sortControl.selectedSegmentIndex);
    NSSortDescriptor *lastNameSorter = [[NSSortDescriptor alloc] initWithKey:@"entryLastName" ascending:YES selector:@selector(caseInsensitiveCompare:)];
    NSSortDescriptor *stateSorter = [[NSSortDescriptor alloc] initWithKey:@"entryState" ascending:YES selector:@selector(caseInsensitiveCompare:)];
    NSSortDescriptor *citySorter = [[NSSortDescriptor alloc] initWithKey:@"entryCity" ascending:YES selector:@selector(caseInsensitiveCompare:)];
    NSSortDescriptor *dateSorter = [[NSSortDescriptor alloc] initWithKey:@"entryDate" ascending:NO];
    NSArray *sortDescriptors = [[NSArray alloc]init];
    if (_sortControl.selectedSegmentIndex == 0) {
        sortDescriptors = [NSArray arrayWithObject: lastNameSorter];
        [_eligibleToWinMutArray sortUsingDescriptors:sortDescriptors];
    }
    else if (_sortControl.selectedSegmentIndex == 1) {
        sortDescriptors = [NSArray arrayWithObjects: stateSorter,citySorter,nil];
        [_eligibleToWinMutArray sortUsingDescriptors:sortDescriptors];
    }
    else if (_sortControl.selectedSegmentIndex == 2) {
        sortDescriptors = [NSArray arrayWithObject: dateSorter];
        [_eligibleToWinMutArray sortUsingDescriptors:sortDescriptors];
    }
    [_tableView reloadData];

}

- (IBAction)selectNewWinner:(id)sender {
    NSDate *startDate = _startDatePicker.date;
    NSDate *endDate = _endDatePicker.date;
    _eligibleToWinMutArray = [[NSMutableArray alloc] init];
    for (Entries *contestant in _entryArray) {
        if (([contestant.entryDate compare:startDate] == NSOrderedDescending) && ([contestant.entryDate compare:endDate] == NSOrderedAscending) && !contestant.entryWinBool) {
            [_eligibleToWinMutArray addObject:contestant];
        }
    }
    int randomWordIndex = arc4random_uniform((uint32_t)_eligibleToWinMutArray.count);
    _winner = _eligibleToWinMutArray[randomWordIndex];
    PFObject *winner = [PFObject objectWithoutDataWithClassName:@"Entries" objectId:_winner.entryId];
    [winner setObject:[NSNumber numberWithBool:YES] forKey:@"entryWinBool"];
    [winner save];
    [self toggleMenuView:nil];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"%@ %@",_winner.entryFirstName, _winner.entryLastName]
                                                    message:@"THEY WIN THEY WIN"
                                                   delegate:self
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];

}

- (IBAction)selectAnyWinner:(id)sender {
    NSDate *startDate = _startDatePicker.date;
    NSDate *endDate = _endDatePicker.date;
    _eligibleToWinMutArray = [[NSMutableArray alloc] init];
    for (Entries *contestant in _entryArray) {
        if (([contestant.entryDate compare:startDate] == NSOrderedDescending) && ([contestant.entryDate compare:endDate] == NSOrderedAscending)) {
            [_eligibleToWinMutArray addObject:contestant];
        }
    }
    int randomWordIndex = arc4random_uniform((uint32_t)_eligibleToWinMutArray.count);
    _winner = _eligibleToWinMutArray[randomWordIndex];
    PFObject *winner = [PFObject objectWithoutDataWithClassName:@"Entries" objectId:_winner.entryId];
    [winner setObject:[NSNumber numberWithBool:YES] forKey:@"entryWinBool"];
    [winner save];
    [self toggleMenuView:nil];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"%@ %@",_winner.entryFirstName, _winner.entryLastName]
                                                    message:@"THEY WIN THEY WIN"
                                                   delegate:self
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
}

#pragma mark - tableview methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _eligibleToWinMutArray.count;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellId = @"Cell";
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellId];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellId];
        cell.textLabel.textColor = [UIColor purpleColor];
    }

    cell.textLabel.text = [NSString stringWithFormat:@"%@ %@", [[_eligibleToWinMutArray objectAtIndex:indexPath.row]entryFirstName] , [[_eligibleToWinMutArray objectAtIndex:indexPath.row]entryLastName]];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@, %@", [[_eligibleToWinMutArray objectAtIndex:indexPath.row]entryCity] , [[_eligibleToWinMutArray objectAtIndex:indexPath.row]entryState]];
    return cell;
}

#pragma mark - lifecycle methods

- (void)viewDidLoad {
    [super viewDidLoad];
    PFQuery *logItemQuery = [PFQuery queryWithClassName:@"Entries"];
    _entryArray = [[NSMutableArray alloc]init];
    [logItemQuery addAscendingOrder:@"dateSent"];
    [logItemQuery setLimit:1000];
    [logItemQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error){
        for (PFObject *logItem in objects) {
            Entries *current = [[Entries alloc]init];
            current.entryDate = [logItem objectForKey:@"entryDate"];
            current.entryFirstName = [logItem objectForKey:@"entryFirstName"];
            current.entryLastName = [logItem objectForKey:@"entryLastName"];
            current.entryState = [logItem objectForKey:@"entryState"];
            current.entryCity = [logItem objectForKey:@"entryCity"];
            current.entryWinBool = [[logItem objectForKey:@"entryWinBool"]boolValue];
            current.entryId = [logItem objectId];
            [_entryArray addObject:current];
            _eligibleToWinMutArray = _entryArray;
            [_tableView reloadData];
        }
    }];
    _startDatePicker.date = [NSDate dateWithTimeIntervalSinceNow:((-86400)*30)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
