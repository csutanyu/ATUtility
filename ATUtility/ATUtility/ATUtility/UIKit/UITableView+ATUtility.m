//
//  UITableView+ATUtility.m
//  TelinkBlue
//
//  Created by arvintan on 16/5/8.
//  Copyright © 2016年 rayson. All rights reserved.
//

#import "UITableView+ATUtility.h"

@implementation UITableView (ATUtility)

- (void)scrollToButtom {
    [self.self setContentOffset:CGPointMake(self.contentOffset.x, CGFLOAT_MAX)];
    [self.self reloadData];
}

@end
