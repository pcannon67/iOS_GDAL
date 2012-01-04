//
//  GDALWrapper.m
//  GDAL
//
//  Created by Andreas Urech on 2011-12-29.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "GDALWrapper.h"
#include "ogrsf_frmts.h"
 
@interface GDALWrapper() {

     NSString *_filePath;
}
@end


@implementation GDALWrapper

- (id)initWithFile:(NSString *)file ofType:(NSString *)type {
    
    NSString *path = [[NSBundle mainBundle] pathForResource:file ofType:type];
    _filePath = path;
    
    return self;
}

- (void)readData {
    
    OGRRegisterAll();
    OGRDataSource *poDS;
    
    poDS = OGRSFDriverRegistrar::Open([_filePath UTF8String], FALSE );
    if( poDS == NULL ) {
        NSLog(@"Open failed.\n" );
        exit( 1 );
    }
    
    OGRLayer *poLayer;
    poLayer = poDS->GetLayer(0);
    
    OGRFeature *poFeature;
    
    poLayer->ResetReading();

    while( (poFeature = poLayer->GetNextFeature()) != NULL ) {
        OGRFeatureDefn *poFDefn = poLayer->GetLayerDefn();
        int iField;
        
        for( iField = 0; iField < poFDefn->GetFieldCount(); iField++ ) {
            OGRFieldDefn *poFieldDefn = poFDefn->GetFieldDefn( iField );
            
            if( poFieldDefn->GetType() == OFTInteger )
                NSLog(@"%d,", poFeature->GetFieldAsInteger(iField));
            else if( poFieldDefn->GetType() == OFTReal )
                NSLog(@"%.3f,", poFeature->GetFieldAsDouble(iField));
            else if( poFieldDefn->GetType() == OFTString )
                NSLog(@"%s,", poFeature->GetFieldAsString(iField));
            else
                NSLog(@"%s,", poFeature->GetFieldAsString(iField));
        }
        
        OGRGeometry *poGeometry;
        
        poGeometry = poFeature->GetGeometryRef();
        if( poGeometry != NULL 
           && wkbFlatten(poGeometry->getGeometryType()) == wkbPoint ) {
            OGRPoint *poPoint = (OGRPoint *) poGeometry;
            
            NSLog(@"%.3f,%3.f\n", poPoint->getX(), poPoint->getY() );
        }
        else {
            NSLog(@"no point geometry\n" );
        }       
        OGRFeature::DestroyFeature( poFeature );
    }
    
    OGRDataSource::DestroyDataSource( poDS );
}

@end
