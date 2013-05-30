//
//  SGSViewController.m
//  CensusSample
//
//  Created by PJ Gray on 5/30/13.
//  Copyright (c) 2013 Say Goodnight Software. All rights reserved.
//

#import "SGSViewController.h"
#import "AFCensusAPIClient.h"

static NSString* const kCensusAPIKey = @"<INSERT YOUR CENSUS KEY HERE>";

@interface SGSViewController ()

@end

@implementation SGSViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    AFCensusAPIClient* censusClient = [[AFCensusAPIClient alloc] initWithAPIKey:kCensusAPIKey];
    [censusClient getMetric:kCensusMetric_OwnerOccupiedHousing
                    withLat:@"42.343653"
                    withLng:@"-71.097701"
                    success:^(AFHTTPRequestOperation *operation, id responseObject) {
                        
                        NSLog(@"Lower Value Owner Occupied Housing: %@", responseObject[kCensusMetric_LowerValueForOwnerOccupiedHousing]);
                        NSLog(@"Median Value Owner Occupied Housing: %@", responseObject[kCensusMetric_MedianValueForOwnerOccupiedHousing]);
                        NSLog(@"Upper Value Owner Occupied Housing: %@", responseObject[kCensusMetric_UpperValueForOwnerOccupiedHousing]);
                        
                    } failure:nil];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
