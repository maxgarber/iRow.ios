//
//  Track.h
//  iRow
//
//  Created by David van Leeuwen on 13-10-11.
//  Copyright 2011 strApps. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

@interface TrackData : NSObject <NSCoding> {
    NSMutableArray * locations;
    NSMutableArray * pins;
}
@property (strong, readonly) NSMutableArray *  locations;
@property (strong, readonly) NSMutableArray *  pins;

-(void)add:(CLLocation*)loc;
-(void)addPin:(NSString*)name atLocation:(CLLocation*)loc;
-(void)reset;

-(CLLocationDistance)totalDistance;
-(CLLocationSpeed)averageSpeed;
-(MKPolyline*)polyLine;
-(CLLocation*)startLocation;
-(CLLocation*)stopLocation;
-(MKCoordinateRegion)region;
-(int)count;

@end
