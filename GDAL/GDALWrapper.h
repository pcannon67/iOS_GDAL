//
//  GDALWrapper.h
//  GDAL
//
//  Created by Andreas Urech on 2011-12-29.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GDALWrapper : NSObject

- (id)initWithFile:(NSString *)file ofType:(NSString *)type;
- (void)readData;
@end
