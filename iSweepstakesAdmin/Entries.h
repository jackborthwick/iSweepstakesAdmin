//
//  Entries.h
//  iSweepstakesAdmin
//
//  Created by Jack Borthwick on 7/1/15.
//  Copyright (c) 2015 Jack Borthwick. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Entries : NSObject

@property (nonatomic, strong) NSString    *entryFirstName;
@property (nonatomic, strong) NSString    *entryLastName;
@property (nonatomic, strong) NSString    *entryEmail;
@property (nonatomic, strong) NSString    *entryPhone;
@property (nonatomic, strong) NSString    *entryCity;
@property (nonatomic, strong) NSString    *entryState;
@property (nonatomic, assign) BOOL        *entryWinBool;
@property (nonatomic, strong) NSDate      *entryDate;
@property (nonatomic, strong) NSString    *entryId;

@end
