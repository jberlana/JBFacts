//
//  HomeViewController.m
//  Facts
//
//  Created by Javier Berlana on 06/10/14.
//  Copyright (c) 2014 Javier Berlana. All rights reserved.
//

#import "HomeViewController.h"

// Controllers
#import "FactDetailViewController.h"

// Views
#import "FactInputTextField.h"
#import "FactTypeButton.h"

// Model
#import "Fact.h"


@interface HomeViewController () <FactTypeButtonDelegate, FactInputTextFieldDelegate>

@property (assign, nonatomic) FactType selectedType;

@property (strong, nonatomic) FactTypeButton *numberButton;
@property (strong, nonatomic) FactTypeButton *dateButton;
@property (strong, nonatomic) FactTypeButton *randomButton;

@end


@implementation HomeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self prepareButtons];
    [self prepareInputView];
    self.inputField.factInputDelegate = self;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.inputField resignFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Prepare View

- (void)prepareButtons
{
    float buttonWidth  = CGRectGetWidth(self.buttonsView.frame)/3;
    float buttonHeight = CGRectGetHeight(self.buttonsView.frame);
    
    CGRect currentFrame = CGRectMake(0, 0, buttonWidth, buttonHeight);
    self.numberButton = [[FactTypeButton alloc] initWithType:FactTypeNumber withFrame:currentFrame andDelegate:self];
    [self.buttonsView addSubview:self.numberButton];
    
    currentFrame = CGRectMake(buttonWidth, 0, buttonWidth, buttonHeight);
    self.dateButton = [[FactTypeButton alloc] initWithType:FactTypeDate withFrame:currentFrame andDelegate:self];
    [self.buttonsView addSubview:self.dateButton];
    
    currentFrame = CGRectMake(buttonWidth*2, 0, buttonWidth, buttonHeight);
    self.randomButton = [[FactTypeButton alloc] initWithType:FactTypeRandom withFrame:currentFrame andDelegate:self];
    [self.buttonsView addSubview:self.randomButton];
    
    [self.numberButton setSelected:YES];
}

- (void)prepareInputView
{
    [self.inputField setType:FactInputTypeNumber];
    self.inputField.layer.backgroundColor = [UIColor colorWithWhite:1 alpha:.2].CGColor;
    self.inputField.layer.cornerRadius    = 2;
    self.inputField.layer.masksToBounds   = YES;
}


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.destinationViewController isKindOfClass:[FactDetailViewController class]])
    {
        FactDetailViewController *detailCV = segue.destinationViewController;
        
        if ([sender isKindOfClass:[Fact class]]) {
            detailCV.fact = sender;
        }
    }
}


#pragma mark - Fact button delegate

- (void)factTypeButtonPressed:(FactTypeButton *)button
{
    self.selectedType = button.type;
    
    switch (button.type)
    {
        case FactTypeNumber:
            [self.inputField setType:FactInputTypeNumber];
            [self.inputField becomeFirstResponder];
            break;
            
        case FactTypeDate:
            [self.inputField setType:FactInputTypeDate];
            [self.inputField becomeFirstResponder];
            break;
            
        case FactTypeRandom:
            [self performSegueWithIdentifier:@"toDetail" sender:[Fact factRandom]];
            break;
    }
    
    // Unselect previous selected buttons
    [self.numberButton setSelected:NO];
    [self.dateButton setSelected:NO];
    [self.randomButton setSelected:NO];
}

#pragma mark - Fact input delegate

- (void)factInputField:(FactInputTextField *)inputField keyboardFrameChange:(CGRect)frame
{
    [UIView animateWithDuration:.6 delay:0 usingSpringWithDamping:.54 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        
        float newH = CGRectGetHeight(self.view.frame) - CGRectGetHeight(frame);
        float headerViewsHeight = CGRectGetHeight(self.inputField.frame) + CGRectGetMinY(self.inputField.frame);
        
        CGRect currentButtonsFrame = self.buttonsView.frame;
        currentButtonsFrame.origin.y = ((newH - headerViewsHeight)/2 - CGRectGetHeight(self.buttonsView.frame)/2) +headerViewsHeight;
        self.buttonsView.frame = currentButtonsFrame;
        
    } completion:^(BOOL finished) {}];
}

- (void)factInputFieldEndEditing:(FactInputTextField *)inputField
{
    [UIView animateWithDuration:.6 delay:0 usingSpringWithDamping:.54 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        
        float newH = CGRectGetHeight(self.view.frame);
        float headerViewsHeight = CGRectGetHeight(self.inputField.frame) + CGRectGetMinY(self.inputField.frame);
        
        CGRect currentButtonsFrame = self.buttonsView.frame;
        currentButtonsFrame.origin.y = ((newH - headerViewsHeight)/2 - CGRectGetHeight(self.buttonsView.frame)/2) +headerViewsHeight;
        self.buttonsView.frame = currentButtonsFrame;
        
    } completion:^(BOOL finished) {
    }];
}

- (void)factInputField:(FactInputTextField *)inputField didInputText:(NSString *)text
{
    Fact *fact = nil;
    
    switch (self.selectedType)
    {
        case FactTypeNumber:
            fact = [Fact factWithRawText:text andType:FactTypeNumber];
            break;
            
        case FactTypeDate:
            fact = [Fact factWithRawText:text andType:FactTypeDate];
            break;
            
        case FactTypeRandom:
            fact = [Fact factRandom];
            break;
    }
    
    if (fact) {
        [self performSegueWithIdentifier:@"toDetail" sender:fact];
    }
    else {
        [self showErrorForType:self.selectedType];
    }
}


- (void)showErrorForType:(FactType)type
{
    [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", @"Alert title")
                                message:[Fact invalidInputErrorMessageForType:type]
                               delegate:nil
                      cancelButtonTitle:NSLocalizedString(@"Ok",@"Alert button")
                      otherButtonTitles:nil]show];
}

- (IBAction)dismissKeyboards:(id)sender
{
    [self.inputField resignFirstResponder];
}

@end
