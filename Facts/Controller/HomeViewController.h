//
//  HomeViewController.h
//  Facts
//
//  Created by Javier Berlana on 06/10/14.
//  Copyright (c) 2014 Javier Berlana. All rights reserved.
//

#import "FactsViewController.h"

@class FactInputTextField;

@interface HomeViewController : FactsViewController

@property (weak, nonatomic) IBOutlet UIView *buttonsView;
@property (weak, nonatomic) IBOutlet FactInputTextField *inputField;

- (IBAction)dismissKeyboards:(id)sender;

@end
