# AFCensusAPIClient

An AFHTTPClient subclass for the [Census API](http://www.census.gov/developers/).

## Usage

Go to the above link to get your census API key.

``` objective-c
AFCensusAPIClient* censusClient = [[AFCensusAPIClient alloc] initWithAPIKey:@"YOUR CENSUS KEY HERE"];
[censusClient getMetric:kCensusMetric_OwnerOccupiedHousing
                withLat:@"42.343653"
                withLng:@"-71.097701"
                success:^(AFHTTPRequestOperation *operation, id responseObject) {
                    
                    NSLog(@"Lower Value Owner Occupied Housing: %@", responseObject[kCensusMetric_LowerValueForOwnerOccupiedHousing]);
                    NSLog(@"Median Value Owner Occupied Housing: %@", responseObject[kCensusMetric_MedianValueForOwnerOccupiedHousing]);
                    NSLog(@"Upper Value Owner Occupied Housing: %@", responseObject[kCensusMetric_UpperValueForOwnerOccupiedHousing]);
                    
                } failure:nil];
```

#### Supported Metrics

Supported metrics using constants is limited right now, but you can always update this repo, or pass in the codes directly.  As built-in constants:

* kCensusMetric_LowerValueForOwnerOccupiedHousing
* kCensusMetric_MedianValueForOwnerOccupiedHousing
* kCensusMetric_UpperValueForOwnerOccupiedHousing
* kCensusMetric_MedianHouseholdIncome


## Contact

PJ Gray

- http://github.com/pj4533
- http://twitter.com/pj4533
- pj@pj4533.com

## License

AFCensusAPIClient is available under the MIT license. See the LICENSE file for more info.

