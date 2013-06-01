// AFCensusAPIClient.m
// 
// Copyright (c) 2013 Say Goodnight Software
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
// 
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
// 
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "AFCensusAPIClient.h"
#import "AFFCCAPIClient.h"
#import "AFNetworking.h"

static NSString * const kCensusBaseURLString = @"http://api.census.gov/";

NSString * kCensusMetric_MedianHouseholdIncome = @"B19013_001E";

NSString * kCensusMetric_LowerValueForOwnerOccupiedHousing = @"B25076_001E";
NSString * kCensusMetric_MedianValueForOwnerOccupiedHousing = @"B25077_001E";
NSString * kCensusMetric_UpperValueForOwnerOccupiedHousing = @"B25078_001E";

NSString * kCensusMetric_OwnerOccupiedHousing = @"B25076_001E,B25077_001E,B25078_001E";

@implementation AFCensusAPIClient

+ (instancetype)sharedClient {
    static AFCensusAPIClient *_sharedClient = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        _sharedClient = [[self alloc] init];
    });
    
    return _sharedClient;
}

- (instancetype)initWithAPIKey:(NSString*)apiKey {
    self = [self init];
    if (!self) {
        return nil;
    }
    self.apiKey = apiKey;
    
    return self;
}

- (instancetype)init {
    self = [super initWithBaseURL:[NSURL URLWithString:kCensusBaseURLString]];
    if (!self) {
        return nil;
    }
    
    [self registerHTTPOperationClass:[AFJSONRequestOperation class]];
    [self setDefaultHeader:@"Accept" value:@"application/json"];
    
    self.parameterEncoding = AFJSONParameterEncoding;
    
    return self;
}


- (void)getMetric:(NSString*) metric
          withLat:(NSString*) lat
          withLng:(NSString*) lng
          success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
          failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    
    [[AFFCCAPIClient sharedClient] getFIPSWithLat:lat withLng:lng success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary* params = @{
                                 @"key": self.apiKey,
                                 @"get": metric,
                                 @"for": [NSString stringWithFormat:@"tract:%@",responseObject[@"tract"]],
                                 @"in": [NSString stringWithFormat:@"state:%@+county:%@",responseObject[@"state"], responseObject[@"county"]],
                                 };
        [super getPath:@"data/2010/acs5" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
            if ([responseObject isKindOfClass:[NSArray class]]) {
                NSArray* resultArray = responseObject;
                if ([resultArray count] > 1) {
                    NSArray* descArray = resultArray[0];
                    NSArray* valuesArray = resultArray[1];
                    NSMutableDictionary* returnDict = [NSMutableDictionary dictionary];
                    for (int i = 0; i < [descArray count]; i++) {
                        NSString* thisKey = descArray[i];
                        NSString* thisResult = valuesArray[i];
                        returnDict[thisKey] = thisResult;
                    }
                    success(operation, returnDict);
                }
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"%@", error);
        }]; 
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

@end
