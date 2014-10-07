//
//  FactDetailViewController.m
//  Facts
//
//  Created by Javier Berlana on 06/10/14.
//  Copyright (c) 2014 Javier Berlana. All rights reserved.
//

#import "FactDetailViewController.h"

// Model
#import "Fact.h"

@interface FactDetailViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *backgroundImage;
@property (weak, nonatomic) IBOutlet UILabel *factLabel;

@end


@implementation FactDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self applyBackroundForType:self.fact.type];
    [self loadFact:self.fact];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Prepare View

- (void)applyBackroundForType:(FactType)type
{
    switch (type)
    {
        case FactTypeNumber:
            self.backgroundImage.image = [UIImage imageNamed:@"bg_number"];
            break;
            
        case FactTypeDate:
            self.backgroundImage.image = [UIImage imageNamed:@"bg_date"];
            break;
            
        case FactTypeRandom:
            self.backgroundImage.image = [UIImage imageNamed:@"bg_random"];
            break;
    }
}

- (void)loadFact:(Fact *)fact
{
    // Set a placeholder label while load the fact from internet.
    self.factLabel.text = NSLocalizedString(@"Loading...", @"Loading indicator on a label.");
    
    [self.fact getFactWithSuccess:^(NSString *fact) {
        self.factLabel.text = fact;
        
    } failure:^(NSError *error) {
        // An error happens trying to retreive the fact from internet.
        self.factLabel.text = NSLocalizedString(@"Sorry, we can not retreive de fact.", @"Error");
    }];
}

@end
