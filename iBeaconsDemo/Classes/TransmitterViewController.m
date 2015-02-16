//
//  TransmitterViewController.m
//  iBeaconsDemo
//
//  Created by Bryan O'Malley on 2/11/15.
//  Copyright (c) 2015 Axeva. All rights reserved.
//

#import "Data.h"
#import "TransmitterViewController.h"


@interface TransmitterViewController () {
    CLBeaconRegion *beaconRegion;
    NSDictionary *beaconPeripheralData;
    CBPeripheralManager *peripheralManager;
}

@property (weak, nonatomic) IBOutlet UILabel *uuid;
@property (weak, nonatomic) IBOutlet UILabel *majorMinor;

@end

@implementation TransmitterViewController


@synthesize uuid;
@synthesize majorMinor;


//*******************************************

#pragma mark - View Lifecycle

//*******************************************


//*******************************************
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear: animated];

    [self setupBeacon];
    [self setupView];
}

//*******************************************
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear: animated];

    if (peripheralManager) {
        [peripheralManager stopAdvertising];
    }
}


//*******************************************

#pragma mark - Private Methods

//*******************************************


//*******************************************
- (void)setupBeacon {
    NSUUID *proximityUUID = [[NSUUID alloc] initWithUUIDString: [Data proximityUUID]];
    beaconRegion = [[CLBeaconRegion alloc] initWithProximityUUID: proximityUUID
                                                           major: [Data majorNumber]
                                                           minor: [Data minorNumber]
                                                      identifier: @"com.axeva.ibeacons"];
    beaconPeripheralData = [beaconRegion peripheralDataWithMeasuredPower: nil];
    peripheralManager = [[CBPeripheralManager alloc] initWithDelegate: self
                                                                queue: nil
                                                              options: nil];
}

//*******************************************
- (void)setupView {
    [uuid setText: [Data proximityUUID]];
    [majorMinor setText: [NSString stringWithFormat: @"Major: %ld  Minor %ld", (long)[Data majorNumber], (long)[Data minorNumber]]];
}


//*******************************************

#pragma mark - CBPeripheralManagerDelegate Delegate Methods

//*******************************************


//*******************************************
- (void)peripheralManagerDidUpdateState:(CBPeripheralManager *)peripheral {
    if (peripheral.state == CBPeripheralManagerStatePoweredOn) {
        NSLog(@"Powered On");
        [peripheralManager startAdvertising: beaconPeripheralData];
    } else if (peripheral.state == CBPeripheralManagerStatePoweredOff) {
        NSLog(@"Powered Off");
        [peripheralManager stopAdvertising];
    }
}


@end
