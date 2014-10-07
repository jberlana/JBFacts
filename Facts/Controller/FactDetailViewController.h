//
//  FactDetailViewController.h
//  Facts
//
//  Created by Javier Berlana on 06/10/14.
//  Copyright (c) 2014 Javier Berlana. All rights reserved.
//

#import "FactsViewController.h"

@class Fact;

@interface FactDetailViewController : FactsViewController

@property (nonatomic, strong) Fact *fact;

@end
