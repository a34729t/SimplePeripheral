//
//  ViewController.h
//  SimplePeripheral
//
//  Created by Nicolas Flacco on 3/8/14.
//  Copyright (c) 2014 Nicolas Flacco. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIButton *sendMsgButton;
- (IBAction)pushedSendMsgButton:(UIButton *)sender;

@end
