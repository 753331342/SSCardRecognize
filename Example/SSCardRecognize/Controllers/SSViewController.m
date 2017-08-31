//
//  SSViewController.m
//  SSCardRecognize
//
//  Created by 753331342@qq.com on 08/31/2017.
//  Copyright (c) 2017 753331342@qq.com. All rights reserved.
//

#import "SSViewController.h"
#import "SSBankCardRecognizeController.h"

@interface SSViewController ()

@end

@implementation SSViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (IBAction)sanBankCard:(UIButton *)sender {
	[self.navigationController pushViewController:[[SSBankCardRecognizeController alloc] init] animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
