//
//  DateFact.m
//  Facts
//
//  Created by Javier Berlana on 05/10/14.
//  Copyright (c) 2014 Javier Berlana. All rights reserved.
//

#import "DateFact.h"

#import "NumbersAPIClient.h"

@interface DateFact ()
@property (nonatomic, strong) NSDate *date;
@property (nonatomic, strong, readwrite) NSString *fact;
@property (nonatomic, assign, readwrite) FactType type;
@end

@implementation DateFact

@synthesize fact = _fact;
@synthesize type = _type;

- (instancetype)initWithString:(NSString *)text
{
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"\\d{1,2}\\/\\d{1,2}" options:0 error:nil];
    NSRange range = [regex rangeOfFirstMatchInString:text options:0 range:NSMakeRange(0, text.length)];
    DateFact *datefact = nil;
    
    if (range.location != NSNotFound && range.length > 0)
    {
        NSString *match = [text substringWithRange:range];
        NSString *day = [match substringToIndex:[match rangeOfString:@"/"].location];
        NSString *month = [match substringFromIndex:[match rangeOfString:@"/"].location+1];
        
        if (month.intValue > 0 && month.intValue <= 12 && day.intValue > 0 && day.intValue) {
            
            NSDateComponents *components = [[NSDateComponents alloc] init];
            
            components.day = day.intValue;
            components.month = month.intValue;
            NSDate *date = [[NSCalendar currentCalendar] dateFromComponents:components];
            
            datefact = [[DateFact alloc] initWithDate:date];
        }
    }
    
    return datefact;
}

- (instancetype)initWithDate:(NSDate *)date
{
    self = [super init];
    
    if (!self) {
        return nil;
    }
    
    self.type = FactTypeDate;
    self.date = date;
    return self;
}


- (NSString *)description
{
    NSString *description = [NSString stringWithFormat:@"\nType: Date\nInput: %@\nFact: %@",self.date.description,self.fact];
    return description;
}


- (NSURLSessionDataTask *)getFactWithSuccess:(void (^)(NSString *fact))success
                                 failure:(void (^)(NSError *error))failure
{
    if (self.fact) {
        success(self.fact);
        return nil;
    }
    
    return [[NumbersAPIClient sharedClient] factForDate:self.date success:^(NSString *fact) {
        self.fact = fact;
        if (success) {
            success(fact);
        }
    } failure:failure];
}


- (NSString *)invalidInputErrorMessage
{
    return NSLocalizedString(@"The input should have the format: \ndd/mm", @"Error message");
}

@end
