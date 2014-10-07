//
//  FactTypeButton.h
//  Facts
//
//  Created by Javier Berlana on 06/10/14.
//  Copyright (c) 2014 Javier Berlana. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Fact.h"

@class FactTypeButton;

@protocol FactTypeButtonDelegate <NSObject>

/**
 Called when the button is pressed.
 @param button A self reference to the pressed button.
 @since 0.1
 */
- (void)factTypeButtonPressed:(FactTypeButton *)button;

@end


@interface FactTypeButton : UIControl

@property (nonatomic, assign, readonly) FactType type;

/**
 Initializes an `FactTypeButton` object for the specified type.
 @param type     The type must be `FactButtonTypeNumber`, `FactButtonTypeDate` or `FactButtonTypeRandom`.
 @param frame    The frame to place the button.
 @param delegate The delegate to respond on events.
 @return The newly-initialized Button.
 @since 0.1
 */
- (instancetype)initWithType:(FactType)type withFrame:(CGRect)frame andDelegate:(id <FactTypeButtonDelegate>)delegate;


@end
