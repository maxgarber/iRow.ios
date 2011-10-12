//
//  Track.h
//  iRow
//
//  Created by David van Leeuwen on 19-09-11.
//  Copyright 2011 strApps. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

@protocol TrackerDelegate <NSObject>

-(void)locationUpdate:(id)sender;

@end

@interface Tracker : NSObject <NSCoding> {
    CLLocationManager * locationManager;
    NSTimer * locationTimer;
    float period;
    id<TrackerDelegate> delegate;
    NSMutableArray * locations;
    NSMutableArray * pins;
}

@property (strong, nonatomic) CLLocationManager * locationManager;
@property (strong, nonatomic) id<TrackerDelegate> delegate;
@property (strong, readonly) NSMutableArray *  locations;
@property (strong, readonly) NSMutableArray *  pins;

-(id)initWithPeriod:(double)period;
-(void)add:(CLLocation*)loc;
-(void)addPin:(NSString*)name atLocation:(CLLocation*)loc;

-(void)startTimer;
-(void)stopTimer;
-(void)reset;
-(CLLocationDistance)totalDistance;
-(CLLocationSpeed)averageSpeed;
-(MKPolyline*)polyLine;
-(CLLocation*)startLocation;
-(CLLocation*)stopLocation;
-(MKCoordinateRegion)region;
-(int)count;

@end
