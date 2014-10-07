//
//  FactInputTextField.h
//  Facts
//
//  Created by Javier Berlana on 06/10/14.
//  Copyright (c) 2014 Javier Berlana. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, FactInputType) {
    FactInputTypeNumber = 0,
    FactInputTypeDate,
};


@class FactInputTextField;
@protocol FactInputTextFieldDelegate <NSObject>

- (void)factInputField:(FactInputTextField *)inputField keyboardFrameChange:(CGRect)frame;
- (void)factInputField:(FactInputTextField *)inputField didInputText:(NSString *)text;

@end


@interface FactInputTextField : UITextField

@property (nonatomic, assign) FactInputType type;
@property (nonatomic, weak) id<FactInputTextFieldDelegate> factInputDelegate;

@end
