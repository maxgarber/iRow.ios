//
//  TrackViewController.h
//  iRow
//
//  Created by David van Leeuwen on 13-11-11.
//  Copyright (c) 2011 strApps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import <MessageUI/MessageUI.h>

#import "Settings.h"
#import "Track.h"
#import "TrackData.h"
#import "ErgometerViewController.h"
#import "MMapViewController.h"
#import "SelectRowerViewControllerDelegate.h"
#import "Stroke.h"
#import "ExportSelector.h"

@interface TrackViewController : UITableViewController <UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource, UITableViewDelegate, UITableViewDataSource, UIActionSheetDelegate, SelectRowerViewControllerDelegate> {
    UIBarButtonItem * leftBarItem;
    Settings * settings;
    TrackData * trackData;
    Track * track;
    Stroke * stroke;
    ErgometerViewController * evc;
    MMapViewController * mvc;
    BOOL editing;
    NSFetchedResultsController * frcBoats, *frcRowers;
    UITextField * boatTextView;
    UITableViewCell * rowersCell;
    double minSpeed;
    UILabel * distanceLabel, * minSpeedLabel, * timeLabel, * aveSpeedLabel, * aveStrokeFreqLabel;
    ExportSelector * exportSelector;
}

@property (strong, nonatomic) Track * track;
@property (strong, nonatomic) UILabel *distanceLabel, * minSpeedLabel, * timeLabel, * aveSpeedLabel, * aveStrokeFreqLabel;

@end
