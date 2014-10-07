//
//  FactInputTextField.m
//  Facts
//
//  Created by Javier Berlana on 06/10/14.
//  Copyright (c) 2014 Javier Berlana. All rights reserved.
//

#import "FactInputTextField.h"

// View
#import "DateMonthPickerView.h"

@interface FactInputTextField () <UITextFieldDelegate, DateMonthPickerDelegate>

@property (nonatomic, weak) DateMonthPickerView *pickerView;

@end

@implementation FactInputTextField

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if (!self) {
        return nil;
    }
    
    self.delegate = self;
    
    // Start listening for notifications of keyboard appearence.
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(noticeShowKeyboard:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    return self;
}

/**
 Overwrite parent `resignFirstResponder`
 @return The default implementation returns YES, resigning first responder status.
 @since 0.1
 */
- (BOOL)resignFirstResponder
{
    // Dismiss custom input controls and notify delegate
    if (self.pickerView)
    {
        [self.pickerView removeFromSuperview];
    }
    
    [self notifyKeyboardChangeToDelegateWithFrame:CGRectZero];
    return [super resignFirstResponder];
}


/**
 Change the type of the input.
 @param type Can be a nummer or a date.
 @since 0.1
 */
- (void)setType:(FactInputType)type
{
    if (_type != type) {
        // Dismiss the current keyboard and clean the text.
        [self resignFirstResponder];
        self.text = @"";
    }
    
    _type = type;
    [self preparePlaceholderForType:type];
}


/**
 Define the input's placeholder to adjust the type.
 @param type The type to set.
 @since 0.1
 */
- (void)preparePlaceholderForType:(FactInputType)type
{
    switch (type)
    {
        case FactInputTypeNumber:
            self.placeholder = NSLocalizedString(@"Write a number", @"Placeholder");
            break;
            
        case FactInputTypeDate:
            self.placeholder = NSLocalizedString(@"Write a date dd/mm", @"Placeholder");
            break;
    }
}

#pragma mark - Notify delegate

/**
 Notify the delegate when the user ends with the data input.
 @since 0.1
 */
- (void)notifyDelegateEndedWriting
{
    if ([self.factInputDelegate respondsToSelector:@selector(factInputField:didInputText:)]) {
        [self.factInputDelegate factInputField:self didInputText:self.text];
    }
}

/**
 Notify the delegate when the input control (keyboard or date piker) change their frame.
 @since 0.1
 */
- (void)notifyKeyboardChangeToDelegateWithFrame:(CGRect)frame
{
    if ([self.factInputDelegate respondsToSelector:@selector(factInputField:keyboardFrameChange:)]) {
        [self.factInputDelegate factInputField:self keyboardFrameChange:frame];
    }
}

#pragma mark - Keyboard listeners

/**
 Notification received when receive a `UIKeyboardWillShowNotification` signal.
 @param notification `UIKeyboardWillShowNotification`
 @since 0.1
 */
- (void)noticeShowKeyboard:(NSNotification *)notification
{
    // Get the keyboard size from the notification.
    NSDictionary *info = notification.userInfo;
    NSValue *value     = info[UIKeyboardFrameEndUserInfoKey];
    CGRect rawFrame    = [value CGRectValue];
    [self notifyKeyboardChangeToDelegateWithFrame:rawFrame];
}


#pragma mark - Textfield delegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    // If the type is `FactInputTypeDate` do not show the default keyboard, show a custom picker.
    if (self.type == FactInputTypeDate) {
        [self showDateMonthPicker];
        return NO;
    }
    
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [self notifyKeyboardChangeToDelegateWithFrame:CGRectZero];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self notifyDelegateEndedWriting];
    [self resignFirstResponder];
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    BOOL validInput = YES;
 
    // If user is not deleting chars.
    if (string.length > 0)
    {
        // Check that the input is a valid char.
        if (self.type == FactInputTypeNumber) {
            validInput = [self isNumber:string];
        }
        else if (self.type == FactInputTypeDate) {
            validInput = [self isValidDateChar:string];
        }
    }
    
    return validInput;
}

#pragma mark - Validate input

/**
 Validate a text input to check is a number.
 @param text The NSString to validate.
 @return BOOL if is a number.
 @since 0.1
 */
- (BOOL)isNumber:(NSString *)text
{
    NSCharacterSet *notDigits = [[NSCharacterSet decimalDigitCharacterSet] invertedSet];
    return [text rangeOfCharacterFromSet:notDigits].location == NSNotFound;
}


/**
 Validate a text input to check is a number or a slash.
 @param text The NSString to validate.
 @return BOOL if is a number or slash.
 @since 0.1
 */
- (BOOL)isValidDateChar:(NSString *)text
{
    NSMutableCharacterSet *slash = [NSMutableCharacterSet characterSetWithCharactersInString:@"/"];
    [slash formUnionWithCharacterSet:[[NSCharacterSet decimalDigitCharacterSet] invertedSet]];
    return [text rangeOfCharacterFromSet:slash].location == NSNotFound;
}

#pragma mark - Custom input keyboards

/**
 Show the custom date piket animated.
 @since 0.1
 */
- (void)showDateMonthPicker
{
    if (!self.pickerView)
    {
        NSArray *nibViews = [[NSBundle mainBundle] loadNibNamed:@"DateMonthPickerView" owner:self options:nil];
        self.pickerView = (DateMonthPickerView *)[nibViews objectAtIndex:0];
        
        // Place the control at the bottom of the view.
        CGRect frame = self.superview.frame;
        frame.origin.y = CGRectGetHeight(frame);
        frame.size.height = CGRectGetHeight(self.pickerView.frame);;
        self.pickerView.frame = frame;
        
        self.pickerView.delegate = self;
        [self.superview addSubview:self.pickerView];
        
        // Animate the appearence.
        [UIView animateWithDuration:.2 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            
            CGRect frame = self.superview.frame;
            frame.origin.y = CGRectGetHeight(frame) - CGRectGetHeight(self.pickerView.frame);
            frame.size.height = CGRectGetHeight(self.pickerView.frame);;
            self.pickerView.frame = frame;
            
        } completion:^(BOOL finished) {}];
        
        [self notifyKeyboardChangeToDelegateWithFrame:frame];
    }
}

#pragma mark - Date month picker view delegate

- (void)dateMonthPicker:(DateMonthPickerView *)picker changeDay:(NSInteger)day andMonth:(NSInteger)month
{
    self.text = [NSString stringWithFormat:@"%ld/%ld",(long)day,(long)month];
}

- (void)dateMonthPicker:(DateMonthPickerView *)picker didSelectDay:(NSInteger)day andMonth:(NSInteger)month
{
    self.text = [NSString stringWithFormat:@"%ld/%ld",(long)day,(long)month];
    [self notifyDelegateEndedWriting];
}

- (void)dateMonthPickerDidDismiss:(DateMonthPickerView *)picker
{
    [self notifyKeyboardChangeToDelegateWithFrame:CGRectZero];
}

@end
