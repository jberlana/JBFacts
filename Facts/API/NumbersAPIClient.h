//
//  NumbersAPIClient.h
//  Facts
//
//  Created by Javier Berlana on 05/10/14.
//  Copyright (c) 2014 Javier Berlana. All rights reserved.
//

#import "AFHTTPSessionManager.h"

@interface NumbersAPIClient : AFHTTPSessionManager

///-----------------------------------------------
/// @name Creating and Initializing the HTTPClient
///-----------------------------------------------

/**
 Initializes an `NumbersAPIClient` object.
 @return NumbersAPIClient
 @since 0.1
 */
+ (instancetype)sharedClient;


///----------------------------------------------
/// @name Making HTTP Requests to the Numbers API
///----------------------------------------------

/**
 Returns a fact given a number.
 @param number  The number to get the fact about.
 @param success Success block, returns the fact in a NSString.
 @param failure Failure block, returns a NSError.
 @return NSURLSessionDataTask
 @since 0.1
 */
- (NSURLSessionDataTask *)factForNumber:(NSInteger)number
                                success:(void (^)(NSString *fact))success
                                failure:(void (^)(NSError *error))failure;

/**
 Returns a fact given a date.
 @param date    The date to get the fact about.
 @param success Success block, returns the fact in a NSString.
 @param failure Failure block, returns a NSError.
 @return NSURLSessionDataTask
 @since 0.1
 */
- (NSURLSessionDataTask *)factForDate:(NSDate *)date
                              success:(void (^)(NSString *fact))success
                              failure:(void (^)(NSError *error))failure;

/**
 Returns a random fact.
 @param success Success block, returns the fact in a NSString.
 @param failure Failure block, returns a NSError.
 @return NSURLSessionDataTask
 @since 0.1
 */
- (NSURLSessionDataTask *)factRandomSuccess:(void (^)(NSString *fact))success
                                    failure:(void (^)(NSError *error))failure;

@end
