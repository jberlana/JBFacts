//
//  DateMonthPickerView.h
//  Facts
//
//  Created by Javier Berlana on 06/10/14.
//  Copyright (c) 2014 Javier Berlana. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DateMonthPickerView;

@protocol DateMonthPickerDelegate <NSObject>

/**
 Notify delegate when the user select a new date.
 @param picker A self reference.
 @param day    The new day.
 @param month  The new month.
 @since 0.1
 */
- (void)dateMonthPicker:(DateMonthPickerView *)picker changeDay:(NSInteger)day andMonth:(NSInteger)month;


/**
 Notify delegate when the user press the `Done` button.
 @param picker A self reference.
 @param day    The selected day.
 @param month  The selected month.
 @since 0.1
 */
- (void)dateMonthPicker:(DateMonthPickerView *)picker didSelectDay:(NSInteger)day andMonth:(NSInteger)month;

/**
 Notify delegate when the user dismiss the control.
 @param picker A self reference.
 @since 0.1
 */
- (void)dateMonthPickerDidDismiss:(DateMonthPickerView *)picker;

@end



@interface DateMonthPickerView : UIControl

@property (nonatomic, weak) id<DateMonthPickerDelegate> delegate;

@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (weak, nonatomic) IBOutlet UIButton *doneButton;

- (IBAction)cancelTapped:(id)sender;
- (IBAction)doneTapped:(id)sender;

@end
