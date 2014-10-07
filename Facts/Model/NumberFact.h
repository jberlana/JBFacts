//
//  NumberFact.h
//  Facts
//
//  Created by Javier Berlana on 05/10/14.
//  Copyright (c) 2014 Javier Berlana. All rights reserved.
//

#import "Fact.h"

@interface NumberFact : Fact

- (instancetype)initWithString:(NSString *)text;

/**
 Initializes an `NumberFact` object with the specified number.
 @param number The number to retreive the fact.
 @return The newly-initialized NumberFact.
 @since 0.1
 */
- (instancetype)initWithNumber:(NSInteger)number;

@end
