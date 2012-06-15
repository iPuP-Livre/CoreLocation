//
//  ViewController.h
//  CoreLocation
//
//  Created by Marian PAUL on 08/03/12.
//  Copyright (c) 2012 iPuP SARL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface ViewController : UIViewController <CLLocationManagerDelegate>
{
    CLLocationManager *_locationManager;
    BOOL _isCompassAvailable;
    
    UITextView *_textViewGPSData;
    UILabel *_labelHeadingData;
}
@end
