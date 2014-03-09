//
//  PeripheralManager.m
//  BLE Echo Server
//
//  Created by Nicolas Flacco on 3/5/14.
//  Copyright (c) 2014 Nicolas Flacco. All rights reserved.
//

#import "PeripheralManager.h"
#import "BLEInfo.h"

@interface PeripheralManager() <CBPeripheralManagerDelegate>

@property(nonatomic,strong) CBPeripheralManager         *peripheralManager;
@property (strong, nonatomic) CBMutableCharacteristic   *notifyCharacteristic;
@property(nonatomic,strong) NSMutableSet                *centrals;
@end

@implementation PeripheralManager

+ (PeripheralManager *)sharedInstance
{
    static dispatch_once_t once=0;
    __strong static id _sharedInstance = nil;
    dispatch_once(&once, ^{
        _sharedInstance = [[self alloc] init];
    });
    return _sharedInstance;
}

- (id)init
{
    if (self=[super init]) {
        // We create a queue and start the central manager
        dispatch_queue_t queue=dispatch_queue_create("com.flaccoDev.peripheralqueue", 0);
        _peripheralManager=[[CBPeripheralManager alloc]initWithDelegate:self
                                                            queue:queue
                                                          options:nil];
        _centrals = [[NSMutableSet alloc] init];
    }
    return self;
}

- (void)startBroadcasting
{
    NSLog(@"PM startBroadcasting");
    [_peripheralManager startAdvertising:@{ CBAdvertisementDataServiceUUIDsKey : @[SERVICE_CBUUID] }];
}

- (void)stopBroadcasting
{
    NSLog(@"PM stopBroadcasting");
    [_peripheralManager stopAdvertising];
}

- (void)notifyCentrals:(NSString *)msg
{
    // TODO: Hack! We are sending to all
    NSLog(@"PM notifyPeer (All peers, currently)");
    
    // Queue the data
    if ([_centrals count] > 0)
    {
        NSData *data = [msg dataUsingEncoding:NSUTF8StringEncoding];
        [_peripheralManager updateValue:data
                      forCharacteristic:_notifyCharacteristic
                   onSubscribedCentrals:nil];
    }

}

#pragma mark - CBPeripheralManager delegate methods

- (void)peripheralManagerDidUpdateState:(CBPeripheralManager *)peripheral
{
    // Opt out from any other state
    if (peripheral.state != CBPeripheralManagerStatePoweredOn) {
        return;
    }
    
    // We're in CBPeripheralManagerStatePoweredOn state...
    NSLog(@"PM PeripheralManager powered on.");
    
    // ... so build our service.
    
    // The notify characteristic
    _notifyCharacteristic = [[CBMutableCharacteristic alloc]initWithType:NOTIFY_CHARACTERISTIC_CBUUID
                                                                  properties:CBCharacteristicPropertyNotify value:nil
                                                                 permissions:CBAttributePermissionsReadable];
    
    // Add the characteristic to the service
    CBMutableService *notifyService = [[CBMutableService alloc] initWithType:SERVICE_CBUUID primary:YES];
    notifyService.characteristics = @[_notifyCharacteristic];
    
    // And add it to the peripheral manager
    [_peripheralManager addService:notifyService];
    
    [self startBroadcasting];
}

/** Catch when someone subscribes to our characteristic, then start sending them data */
- (void)peripheralManager:(CBPeripheralManager *)peripheral central:(CBCentral *)central didSubscribeToCharacteristic:(CBCharacteristic *)characteristic
{
    NSLog(@"PM  Central subscribed to characteristic");
    [_centrals addObject:central];
}

/** Recognise when the central unsubscribes */
- (void)peripheralManager:(CBPeripheralManager *)peripheral central:(CBCentral *)central didUnsubscribeFromCharacteristic:(CBCharacteristic *)characteristic
{
    NSLog(@"PM Central unsubscribed from characteristic");
    [_centrals removeObject:central];
}

@end
