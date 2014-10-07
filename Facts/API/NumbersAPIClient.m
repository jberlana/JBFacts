//
//  NumbersAPIClient.m
//  Facts
//
//  Created by Javier Berlana on 05/10/14.
//  Copyright (c) 2014 Javier Berlana. All rights reserved.
//

#import "NumbersAPIClient.h"

static NSString * const k_NumbersAPIBaseURLString = @"http://numbersapi.com/";

static NSString * const k_NumbersAPINumberFormat = @"%ld";
static NSString * const k_NumbersAPIDateFormat   = @"%ld/%ld/date";
static NSString * const k_NumbersAPIRandomFormat = @"random";

@implementation NumbersAPIClient

+ (instancetype)sharedClient
{
    static NumbersAPIClient *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[NumbersAPIClient alloc] initWithBaseURL:[NSURL URLWithString:k_NumbersAPIBaseURLString]];
        _sharedClient.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
        _sharedClient.responseSerializer = [AFHTTPResponseSerializer serializer];
    });
    
    return _sharedClient;
}


- (NSURLSessionDataTask *)GET:(NSString *)URLString
                       params:(NSDictionary *)parameters
                      success:(void (^)(NSString *response))success
                      failure:(void (^)(NSError *error))failure
{
    return [self GET:URLString parameters:parameters success:^(NSURLSessionDataTask *task, id DATA)
            {
                NSString *response = [[NSString alloc] initWithData:DATA encoding:NSUTF8StringEncoding];
                DDLogInfo(@"\nSERVER RESPONSE: %@\nURL: %@\nParams: %@\n",response, URLString, parameters);
                if (success) {
                    success(response);
                }
                
            } failure:^(NSURLSessionDataTask *task, NSError *error) {
                DDLogInfo(@"SERVER ERROR: %@",error.localizedDescription);
                if (failure) {
                    failure(error);
                }
            }];
}


#pragma mark - API methods

- (NSURLSessionDataTask *)factForNumber:(NSInteger)number
                                success:(void (^)(NSString *fact))success
                                failure:(void (^)(NSError *error))failure
{
    NSString *url = [NSString stringWithFormat:k_NumbersAPINumberFormat,(long)number];
    return [self GET:url params:nil success:success failure:failure];
}


- (NSURLSessionDataTask *)factForDate:(NSDate *)date
                       success:(void (^)(NSString *fact))success
                       failure:(void (^)(NSError *error))failure
{
    
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth fromDate:date];
    NSInteger day   = [components day];
    NSInteger month = [components month];
    
    NSString *url = [NSString stringWithFormat:k_NumbersAPIDateFormat,(long)month,(long)day];
    return [self GET:url params:nil success:success failure:failure];
}


- (NSURLSessionDataTask *)factRandomSuccess:(void (^)(NSString *fact))success
                                    failure:(void (^)(NSError *error))failure
{
    NSString *url = k_NumbersAPIRandomFormat;
    return [self GET:url params:nil success:success failure:failure];
}

@end
