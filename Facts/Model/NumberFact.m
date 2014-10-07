//
//  NumberFact.m
//  Facts
//
//  Created by Javier Berlana on 05/10/14.
//  Copyright (c) 2014 Javier Berlana. All rights reserved.
//

#import "NumberFact.h"

#import "NumbersAPIClient.h"

@interface NumberFact ()
@property (nonatomic, assign) NSInteger number;
@property (nonatomic, strong, readwrite) NSString *fact;
@property (nonatomic, assign, readwrite) FactType type;
@end

@implementation NumberFact

@synthesize fact = _fact;
@synthesize type = _type;

- (instancetype)initWithString:(NSString *)text
{
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"\\d*" options:0 error:nil];
    NSRange range = [regex rangeOfFirstMatchInString:text options:0 range:NSMakeRange(0, text.length)];
    NumberFact *numberFact = nil;
    
    if (range.location != NSNotFound && range.length > 0) {
        numberFact = [[NumberFact alloc] initWithNumber:[text substringWithRange:range].intValue];
    }
    
    return numberFact;
}

// Designated initializer
- (instancetype)initWithNumber:(NSInteger)number
{
    self = [super init];
    
    if (!self) {
        return nil;
    }
    
    self.type   = FactTypeNumber;
    self.number = number;
    return self;
}


- (NSString *)description
{
    NSString *description = [NSString stringWithFormat:@"\nType: Number\nInput: %ld\nFact: %@",(long)self.number,self.fact];
    return description;
}


- (NSURLSessionDataTask *)getFactWithSuccess:(void (^)(NSString *fact))success
                                 failure:(void (^)(NSError *error))failure
{
    if (self.fact) {
        success(self.fact);
        return nil;
    }
    
    return [[NumbersAPIClient sharedClient] factForNumber:self.number success:^(NSString *fact) {
        self.fact = fact;
        if (success) {
            success(fact);
        }
    } failure:failure];
}


- (NSString *)invalidInputErrorMessage
{
    return NSLocalizedString(@"The input should be a number.", @"Error message");
}

@end
