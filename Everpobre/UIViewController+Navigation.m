//
//  UIViewController+Navigation.m
//  Everpobre
//
//  Created by David de Tena on 10/04/15.
//  Copyright (c) 2015 David de Tena. All rights reserved.
//

#import "UIViewController+Navigation.h"

@implementation UIViewController (Navigation)

#pragma mark - Métodos que añado

// Embeber un ViewController en un Navigation Controller
-(UINavigationController *) wrappedInNavigation{
    UINavigationController *nav = [[UINavigationController alloc]init];
    [nav pushViewController:self animated:NO];
    
    return nav;
}

@end
