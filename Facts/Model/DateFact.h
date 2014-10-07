//
//  DateFact.h
//  Facts
//
//  Created by Javier Berlana on 05/10/14.
//  Copyright (c) 2014 Javier Berlana. All rights reserved.
//

#import "Fact.h"

@interface DateFact : Fact

- (instancetype)initWithString:(NSString *)text;

/**
 Initializes an `DateFact` object with the specified date.
 @param date The date to retreive the fact.
 @return The newly-initialized DateFact.
 @since 0.1
 */
- (instancetype)initWithDate:(NSDate *)date;

@end
