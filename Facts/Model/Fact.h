//
//  Fact.h
//  Facts
//
//  Created by Javier Berlana on 05/10/14.
//  Copyright (c) 2014 Javier Berlana. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, FactType) {
    FactTypeNumber = 0,
    FactTypeDate,
    FactTypeRandom,
};

@interface Fact : NSObject

@property (nonatomic, assign, readonly) FactType type;
@property (nonatomic, strong, readonly) NSString *fact;

///--------------------------------------
/// @name Creating and Initializing Facts
///--------------------------------------

/**
 Tries to initialize an `NumberFact` object from a given `NSString`.
 @param text The text to parse.
 @param type The type to check.
 @return The newly-initialized NumberFact, nil if can not parse the text.
 @since 0.1
 */
+ (Fact *)factWithRawText:(NSString *)text andType:(FactType)type;

/**
 Initializes an `NumberFact` object with the specified number.
 @param number The number to retreive the fact.
 @return The newly-initialized NumberFact.
 @since 0.1
 */
+ (Fact *)factWithNumber:(NSInteger)number;

/**
 Initializes an `DateFact` object with the specified date.
 @param date The date to retreive the fact.
 @return The newly-initialized DateFact.
 @since 0.1
 */
+ (Fact *)factWithDate:(NSDate *)date;

/**
 Initializes an `RandomFact` object.
 @return The newly-initialized RandomFact.
 @since 0.1
 */
+ (Fact *)factRandom;


///---------------------------
/// @name Making HTTP Requests
///---------------------------

/**
 Request a Fact to http://numbersapi.com/
 @param success A block to be executed when receive a Fact from the server.
 @param failure A block to be executed if shit happens.
 @return NSURLSessionDataTask The data task of the network request.
 @since 0.1
 */
- (NSURLSessionDataTask *)getFactWithSuccess:(void (^)(NSString *fact))success
                                     failure:(void (^)(NSError *error))failure;


/**
 Returns a message indicating why a input is not valid.
 @param The type to show the error.
 @return A message.
 @since 0.1
 */
+ (NSString *)invalidInputErrorMessageForType:(FactType)type;

@end
