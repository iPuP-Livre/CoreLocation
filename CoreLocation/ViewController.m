//
//  ViewController.m
//  CoreLocation
//
//  Created by Marian PAUL on 08/03/12.
//  Copyright (c) 2012 iPuP SARL. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad 
{
    [super viewDidLoad];
    // -------------------------------------------------
    // Configuration du location Manager
    // -------------------------------------------------
    
    // on alloue un Manager pour la location 
    _locationManager = [[CLLocationManager alloc] init];
    // self est le delegate
    _locationManager.delegate = self;
    // Par défaut, on met la meilleure localisation
    _locationManager.desiredAccuracy = kCLLocationAccuracyBest; //[1]
    // on update autant que possible
    _locationManager.distanceFilter = kCLDistanceFilterNone; //[2]
    
    // On vérifie que le device a bien la boussole de dispo
    if ([CLLocationManager headingAvailable] == NO) { //[3]
        // pour iPhone OS < 4.0 : if (locationManager.headingAvailable == NO)
        // pas de boussole disponible
        _isCompassAvailable = NO;
    } else {
        _isCompassAvailable = YES;
        // configuration du filtre pour la boussole
        _locationManager.headingFilter = kCLHeadingFilterNone;
    }
    // -------------------------------------------------
    // Elements graphiques
    // -------------------------------------------------
    
    _textViewGPSData = [[UITextView alloc] initWithFrame:CGRectMake(10, 10, 300, 200)];
    _textViewGPSData.editable = NO; //[4]
    [self.view addSubview:_textViewGPSData];
    
    _labelHeadingData = [[UILabel alloc] initWithFrame:CGRectMake(0, 220, 320, 30)];
    _labelHeadingData.backgroundColor = [UIColor clearColor];
    // multi lignes
    _labelHeadingData.numberOfLines = 0; //[5]
    [self.view addSubview:_labelHeadingData];
    
    // -------------------------------------------------
    // Démarrage localisation + boussole
    // -------------------------------------------------
    // on lance la localisation
    [_locationManager startUpdatingLocation]; //[6]
    // on lance la boussole
    [_locationManager startUpdatingHeading]; //[7]
}

#pragma mark - Location delegate

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *) oldLocation //[8] 
{
    NSMutableString *stringToDisplay = [NSMutableString string]; //[9]
    [stringToDisplay appendFormat:@"lat : %f long : %f\n", newLocation.coordinate.latitude, newLocation.coordinate.longitude];
    [stringToDisplay appendFormat:@"altitude : %f\n", newLocation.altitude];
    [stringToDisplay appendFormat:@"vitesse : %f m/s \n", newLocation.speed];
    [stringToDisplay appendFormat:@"précision horiz : %f, vert : %f\n", newLocation.horizontalAccuracy, newLocation.verticalAccuracy];
    _textViewGPSData.text = stringToDisplay;
    
}


#pragma mark - Delegate de la boussole(heading)
- (void)locationManager:(CLLocationManager *)manager didUpdateHeading:(CLHeading *)heading //[10]
{
    
    _labelHeadingData.text = [NSString stringWithFormat:@"%f ; x : %f, y : %f, z: %f", heading.trueHeading, heading.x, heading.y, heading.z]; //[11]
    [_labelHeadingData sizeToFit]; //[12]
}

#pragma mark - Gestion des erreurs

// Cette méthode est appelée lorsque l'objet actualisant la localisation rencontre une erreur
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error //[13]
{
    
    if ([error code] == kCLErrorDenied) { //[14]
        // Cette erreur indique que l'utilisateur a refusé l'accès au service de localisation
        [_locationManager stopUpdatingHeading];
        [_locationManager stopUpdatingLocation];
    } else if ([error code] == kCLErrorHeadingFailure) { //15]
        // Cette erreur indique que les données de la boussole ne peuvent être déterminées, probablement à cause d'interférences 
    }
}

- (void)dealloc 
{
    [_locationManager stopUpdatingHeading];
    [_locationManager stopUpdatingLocation];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    _textViewGPSData = nil;
    _labelHeadingData = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

@end
