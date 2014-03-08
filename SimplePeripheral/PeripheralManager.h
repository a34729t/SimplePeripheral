//
//  PeripheralManager.h
//  BLE Echo Server
//
//  Created by Nicolas Flacco on 3/5/14.
//  Copyright (c) 2014 Nicolas Flacco. All rights reserved.
//

#import <Foundation/Foundation.h>
@import CoreBluetooth;

@class PeripheralManager;

@protocol PeripheralManagerDelegate <NSObject>

// TODO

@end

@interface PeripheralManager : NSObject

@property(nonatomic) id <PeripheralManagerDelegate> delegate;

+ (PeripheralManager *)sharedInstance;
- (void)startBroadcasting;
- (void)stopBroadcasting;
- (void)notifyCentrals:(NSString *)msg;
@end
