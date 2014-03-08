//
//  ViewController.m
//  SimplePeripheral
//
//  Created by Nicolas Flacco on 3/8/14.
//  Copyright (c) 2014 Nicolas Flacco. All rights reserved.
//

#import "ViewController.h"
#import "PeripheralManager.h"

@interface ViewController () <PeripheralManagerDelegate>

@property(nonatomic,strong) PeripheralManager *peripheralManager;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    _peripheralManager = [PeripheralManager sharedInstance];
    _peripheralManager.delegate = self;
    [_peripheralManager startBroadcasting];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)pushedSendMsgButton:(UIButton *)sender {
    NSLog(@"UI pushedSendMsgButton");
    [_peripheralManager notifyCentrals:@"foo"];
}

@end
