//
//  DateMonthPickerView.m
//  Facts
//
//  Created by Javier Berlana on 06/10/14.
//  Copyright (c) 2014 Javier Berlana. All rights reserved.
//

#import "DateMonthPickerView.h"

@implementation DateMonthPickerView

- (void)layoutSubviews
{
    self.pickerView.layer.cornerRadius = 3;
}

- (void)removeFromSuperview
{
    // Animate the appearence.
    [UIView animateWithDuration:.2 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        
        // Place the control at the bottom of the view.
        CGRect frame = self.superview.frame;
        frame.origin.y = CGRectGetHeight(frame);
        frame.size.height = CGRectGetHeight(self.frame);;
        self.frame = frame;
        
    } completion:^(BOOL finished) {
        [super removeFromSuperview];
    }];
}

- (IBAction)cancelTapped:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(dateMonthPickerDidDismiss:)]) {
        [self.delegate dateMonthPickerDidDismiss:self];
    }
    [self removeFromSuperview];
}

- (IBAction)doneTapped:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(dateMonthPicker:didSelectDay:andMonth:)])
    {
        NSInteger day   = [self.pickerView selectedRowInComponent:0]+1;
        NSInteger month = [self.pickerView selectedRowInComponent:1]+1;
        [self.delegate dateMonthPicker:self didSelectDay:day andMonth:month];
    }
    
    [self removeFromSuperview];
}

#pragma mark - Picker view delegate

- (void)pickerView:(UIPickerView *)pickerView didSelectRow: (NSInteger)row inComponent:(NSInteger)component
{
    if ([self.delegate respondsToSelector:@selector(dateMonthPicker:changeDay:andMonth:)])
    {
        NSInteger day   = [pickerView selectedRowInComponent:0]+1;
        NSInteger month = [pickerView selectedRowInComponent:1]+1;
        [self.delegate dateMonthPicker:self changeDay:day andMonth:month];
    }
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return component == 0 ? 31:12;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 2;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSString *title;
    
    if (component == 0) {
        title = [NSString stringWithFormat:@"%d",row+1];
    }
    else {
        title = [[[NSDateFormatter alloc] init] monthSymbols][row];
    }
    
    return title;
} 

@end
