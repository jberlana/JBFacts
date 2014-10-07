//
//  FactTypeButton.m
//  Facts
//
//  Created by Javier Berlana on 06/10/14.
//  Copyright (c) 2014 Javier Berlana. All rights reserved.
//

#import "FactTypeButton.h"

@interface FactTypeButton ()

@property (nonatomic, assign, readwrite) FactType type;
@property (nonatomic, weak) id<FactTypeButtonDelegate> delegate;

@property (nonatomic, strong) UIImageView *icon;
@property (nonatomic, strong) UILabel *title;

@end

@implementation FactTypeButton

- (instancetype)initWithType:(FactType)type withFrame:(CGRect)frame andDelegate:(id <FactTypeButtonDelegate>)delegate
{
    self = [super init];
    
    if (!self) {
        return nil;
    }
    
    self.frame    = frame;
    self.delegate = delegate;
    self.type     = type;
    [self addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self drawButtonWithType:type];
    [self setNormalStyle];
    
    return self;
}


#pragma mark - View draw

- (void)drawButtonWithType:(FactType)type
{
    switch (type)
    {
        case FactTypeNumber:
            [self drawIcon:@"ic_number"];
            [self drawLabel:NSLocalizedString(@"Number", @"Title for a button")];
            break;
            
        case FactTypeDate:
            [self drawIcon:@"ic_date"];
            [self drawLabel:NSLocalizedString(@"Date", @"Title for a button")];
            break;
            
        case FactTypeRandom:
            [self drawIcon:@"ic_random"];
            [self drawLabel:NSLocalizedString(@"Random", @"Title for a button")];
            break;
            
        default:
            break;
    }
}


- (void)drawIcon:(NSString *)imageName
{
    float width = [self getButtonWith];
    
    UIImageView *icon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
    icon.frame               = CGRectMake(CGRectGetWidth(self.frame)/2 -width/2, 0, width, width);
    icon.layer.borderColor   = [UIColor colorWithWhite:1 alpha:1].CGColor;
    icon.layer.borderWidth   = 3;
    icon.layer.cornerRadius  = width/2;
    icon.layer.masksToBounds = YES;
    icon.contentMode         = UIViewContentModeScaleAspectFit;
    
    self.icon = icon;
    [self addSubview:self.icon];
}


- (void)drawLabel:(NSString *)title
{
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetHeight(self.frame) -30, CGRectGetWidth(self.frame), 30)];
    titleLabel.text             = title;
    titleLabel.font             = [UIFont systemFontOfSize:17];
    titleLabel.numberOfLines    = 1;
    titleLabel.backgroundColor  = [UIColor clearColor];
    titleLabel.textColor        = [UIColor colorWithWhite:1 alpha:1];
    titleLabel.textAlignment    = NSTextAlignmentCenter;
    titleLabel.adjustsFontSizeToFitWidth = YES;
    
    self.title = titleLabel;
    [self addSubview:self.title];
}


- (float)getButtonWith
{
    return MIN(CGRectGetWidth(self.frame), CGRectGetHeight(self.frame)-30);
}


#pragma mark - Actions

- (void)buttonPressed:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(factTypeButtonPressed:)]) {
        [self.delegate factTypeButtonPressed:self];
    }
    
    [self setSelectedStyle];
}


#pragma mark - Selection status

- (void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
    if (selected) {
        [self setSelectedStyle];
    }
    else {
        [self setNormalStyle];
    }
}


- (void)setSelectedStyle
{
    [UIView animateWithDuration:.2 animations:^{
        self.alpha = 1;
    }];
}


- (void)setNormalStyle
{
    [UIView animateWithDuration:.2 animations:^{
        self.alpha = 0.6;
    }];
}

@end
