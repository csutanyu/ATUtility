//
//  ViewController.m
//  ATUtility
//
//  Created by arvin.tan on 7/3/15.
//  Copyright (c) 2015 arvin.tan. All rights reserved.
//

#import "ViewController.h"
#import "UIView+ATUTility.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIView *childView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self.childView addDashLineInPosition:LinePositionAll unitLength:6.0 lineWidth:3 color:[UIColor redColor]];
//    [self.childView addSolidLineInPosition:LinePositionAll lineWidth:3.0 color:[UIColor redColor]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
