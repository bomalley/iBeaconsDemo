//
//  ReceiverViewController.m
//  iBeaconsDemo
//
//  Created by Bryan O'Malley on 2/11/15.
//  Copyright (c) 2015 Axeva. All rights reserved.
//

#import "Data.h"
#import "ReceiverViewController.h"

@interface ReceiverViewController () {
    CLBeaconRegion *beaconRegion;
    CLLocationManager *locationManager;

    NSArray *foundBeacons;
}

@end

@implementation ReceiverViewController



//*******************************************

#pragma mark - View Lifecycle

//*******************************************


//*******************************************
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear: animated];

    [self setupBeaconListener];
}

//*******************************************
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear: animated];

    [self shutDownBeaconListener];
}

//*******************************************
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

    [self shutDownBeaconListener];
}


//*******************************************

#pragma mark - Private Methods

//*******************************************


//*******************************************
- (void)shutDownBeaconListener {
    if (locationManager) {
        [locationManager stopRangingBeaconsInRegion: beaconRegion];
        [locationManager stopMonitoringForRegion: beaconRegion];
        
        locationManager = nil;
        beaconRegion = nil;
    }
}

//*******************************************
- (void)setupBeaconListener {
    locationManager = [[CLLocationManager alloc] init];
    [locationManager setDelegate: self];

    // Request authorization to listen for Beacons – new in iOS 8
    if ([locationManager respondsToSelector: @selector(requestWhenInUseAuthorization)]) {
        [locationManager requestWhenInUseAuthorization];
    }
    
    NSUUID *uuid = [[NSUUID alloc] initWithUUIDString: [Data proximityUUID]];
    
    beaconRegion = [[CLBeaconRegion alloc] initWithProximityUUID: uuid identifier: @"com.axeva.ibeacons"];
    [beaconRegion setNotifyEntryStateOnDisplay: YES];
    [locationManager startMonitoringForRegion: beaconRegion];
}


//*******************************************

#pragma mark - Core Location Delegate Methods

//*******************************************


//*******************************************
- (void)locationManager:(CLLocationManager *)manager didDetermineState:(CLRegionState)state forRegion:(CLRegion *)region {
    NSLog(@"Determine state");
}

//*******************************************
- (void)locationManager:(CLLocationManager *)manager didStartMonitoringForRegion:(CLRegion *)region {
    [manager startRangingBeaconsInRegion: beaconRegion];
}

//*******************************************
- (void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region {
    [locationManager startRangingBeaconsInRegion: beaconRegion];
}

//*******************************************
- (void)locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region {
    [locationManager stopRangingBeaconsInRegion: beaconRegion];
}

//*******************************************
- (void)locationManager:(CLLocationManager *)manager didRangeBeacons:(NSArray *)beacons inRegion:(CLBeaconRegion *)region {
    foundBeacons = beacons;

    [[self tableView] reloadData];
}


//*******************************************

#pragma mark - Core Location Delegate Methods

//*******************************************


//*******************************************
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

//*******************************************
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [foundBeacons count];
}

//*******************************************
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: @"MyIdentifier"];

    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle: UITableViewCellStyleSubtitle reuseIdentifier: @"beaconCellIdentifier"];
    }

    CLBeacon *beacon = [foundBeacons objectAtIndex: indexPath.row];

    [[cell textLabel] setText: [NSString stringWithFormat: @"iBeacon %ld", (long)indexPath.row]];
    [[cell detailTextLabel] setText: [NSString stringWithFormat: @"Major: %d  Minor %d", [[beacon major] intValue], [[beacon minor] intValue]]];

    UILabel *meters = [[UILabel alloc] initWithFrame: CGRectMake(0, 0, 100, 44)];
    [meters setText: [NSString stringWithFormat: @"%.2fm", [beacon accuracy]]];
    [meters setTextAlignment: NSTextAlignmentRight];

    [cell setAccessoryView: meters];

    return cell;
}


@end
