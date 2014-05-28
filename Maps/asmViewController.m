//
//  asmViewController.m
//  IrelandMaps
//
//  Created by Jonathan Headen on 17/02/13.
//  Copyright (c) 2013 AirSkull. All rights reserved.
//


#import "asmViewController.h"
#import "airskullCountry.h"

@interface asmViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *markerView;
@property (weak, nonatomic) IBOutlet UIImageView *completedCountyLabelsView;
@property (weak, nonatomic) IBOutlet UIImageView *mapView;
@property (weak, nonatomic) IBOutlet UIImageView *completedCountiesView;
@property (weak, nonatomic) IBOutlet UIImageView *completedLakesView;
@property (weak, nonatomic) IBOutlet UIImageView *countyView;
@property (weak, nonatomic) IBOutlet UIImageView *token;
@property (weak, nonatomic) IBOutlet UIImageView *mapOutline;
@property (strong, nonatomic) airskullCountry *mainland;//mainland
@property (nonatomic, weak) NSTimer *hintTimer; //control when the hints get shown
@property (nonatomic) BOOL hintOnScreen; //is the hint being shown
@property (nonatomic) BOOL countyOnScreen; //is the county being shown
@property (nonatomic,strong) NSNumber *hintDelayCounter; //number of seconds before the hint is shown
@property (strong, nonatomic) UIView * countyInView; //the county over which the token is hovering
@property (weak, nonatomic) IBOutlet UIImageView *overLay;
@property (weak, nonatomic) IBOutlet UIImageView *hintsOnOffSwitch;
@property (weak, nonatomic) IBOutlet UIImageView *homeNav;



@end


@implementation asmViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    //counties map => mapdata is Ireland
    //physical map => mapdata is IrelandPhysical
    self.mapView.image =[UIImage imageNamed:[self.mapData stringByAppendingString:@".png"]];
    self.mapOutline.image =[UIImage imageNamed:[self.mapData stringByAppendingString:@"Outline.png"]];
    [self addGestureRecognizerToPiece:self.token];
    [self animateNewToken];
    self.countyInView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[self.mainland.targetName stringByAppendingString:@".png"]]];
    self.countyInView.hidden = YES;
    //add the tap gesture recognizer for the hints onoff switch
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(Tap:)];
    [self.view addGestureRecognizer:tap ];
    [self drawSwitch];
    self.homeNav.hidden= NO;
    
    UISwipeGestureRecognizer *swipeDown = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeDown:)];
    swipeDown.direction = UISwipeGestureRecognizerDirectionDown;
    UISwipeGestureRecognizer *swipeUp = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeUp:)];
    swipeUp.direction = UISwipeGestureRecognizerDirectionUp;
    [self.view addGestureRecognizer:swipeDown];
    [self.view addGestureRecognizer:swipeUp];
    
}
-(void) startPuzzle
{
    self.overLay.hidden = YES;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark properties
-(airskullCountry *)mainland
{
    if (!_mainland) {
        _mainland = [[airskullCountry alloc] init];
        _mainland.mapName = self.mapData;
        _mainland.mapSections = self.mapSections;
    }
    return _mainland;
}


#pragma mark mapLogic

-(void)hintDisplayCycle:(NSTimer *)timer
{
    if ([self.hintDelayCounter isEqualToNumber:[NSNumber numberWithInt:0]])
    {
        self.hintDelayCounter = [NSNumber numberWithFloat:HINT_DELAY];
    }
    else if ([self.hintDelayCounter isEqualToNumber:[NSNumber numberWithFloat:2]])
    {
        if (self.hintsOnOff) [self showHint];
        self.hintDelayCounter = [NSNumber numberWithInt:1];
    }
    else {
        self.hintDelayCounter = [NSNumber numberWithInt:([self.hintDelayCounter floatValue] -1)];
    }
    
}
-(void)startTimer {
    if (self.hintsOnOff)
    {
        [self showHint];
        self.hintDelayCounter = [NSNumber numberWithInt:1];
        self.hintTimer = [NSTimer scheduledTimerWithTimeInterval:HINT_DELAY_TIMER
                                                          target:self
                                                        selector:@selector(hintDisplayCycle:)
                                                        userInfo:nil
                                                         repeats:YES];
    }
}
-(void)stopHintTimer
{
    [self.hintTimer invalidate];
    for (UIView *view in self.markerView.subviews)
    {
        [view removeFromSuperview];
    }
}

-(void)hideHint
{
    for (UIView *view in self.markerView.subviews) {
        CGAffineTransform transform = view.transform;
        if (CGAffineTransformIsIdentity(transform)) {
            UIViewAnimationOptions options = UIViewAnimationOptionCurveLinear;
            [UIView animateWithDuration:HINT_ANIMATION_DURATION/3 delay:0 options:options animations:^{
                view.transform = CGAffineTransformRotate(CGAffineTransformScale(transform, 0.7, 0.7), 2*M_PI/3);
            } completion:^(BOOL finished) {
                if (finished) {
                    [UIView animateWithDuration:HINT_ANIMATION_DURATION/3 delay:0 options:options animations:^{
                        view.transform = CGAffineTransformRotate(CGAffineTransformScale(transform, 0.4, 0.4), -2*M_PI/3);
                    } completion:^(BOOL finished) {
                        if (finished) {
                            [UIView animateWithDuration:HINT_ANIMATION_DURATION/3 delay:0 options:options animations:^{
                                view.transform = CGAffineTransformScale(transform, 0.1, 0.1);
                            } completion:^(BOOL finished) {
                                if (finished) [view removeFromSuperview];
                            }];
                        }
                    }];
                }
            }];
        }
        
    }
}
-(void)showHint
{
    float x = [[[[self.mainland targetMarkers]objectForKey:self.mainland.targetName]objectAtIndex:2] floatValue];
    float y = [[[[self.mainland targetMarkers]objectForKey:self.mainland.targetName]objectAtIndex:3] floatValue];
    if ((self.hintsOnOff) && (!self.mainland.isMapComplete)) [self addMarkerAtFloatX:x andFloatY:y];
}
#pragma mark gestures and UI
-(NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait ;
}

-(void) Tap:(UIGestureRecognizer *)gesture
{
    if (!self.overLay.hidden) [self startPuzzle];

    CGPoint touchPoint = [gesture locationInView:self.view];
    NSLog(@"[NSNumber numberWithInt:%f],[NSNumber numberWithInt:%f] %@",touchPoint.x,touchPoint.y -20,self.mainland.targetName);
    if (CGRectContainsPoint(self.homeNav.frame, touchPoint)){
        if (self.mainland.isMapComplete) {
            // exit point
            [self.presentingViewController dismissViewControllerAnimated:YES completion:^{}];
        } else
        { NSString *Title = [NSString stringWithFormat:@"Map not Finished"];
            NSString *messageString = [NSString stringWithFormat:@"Are you sure you want to Quit?"];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:Title message:messageString delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", @"Start Over", nil ];
            [alert show];
        }
        
    }
    
    if (CGRectContainsPoint(self.hintsOnOffSwitch.frame, touchPoint)) {
        self.hintsOnOff = !self.hintsOnOff;
        [self.delegate asmViewController:self didFlickHintsSwitch:self.hintsOnOff];
        if (self.hintsOnOff)
        {
            [self startTimer];
        }
        else
        {
            [self stopHintTimer];
            
        }
    }
    [self drawSwitch];
}

-(void) drawSwitch
{
    if (self.hintsOnOff) {
        self.hintsOnOffSwitch.image = [UIImage imageNamed:@"switchon.png"];
    } else {
        self.hintsOnOffSwitch.image = [UIImage imageNamed:@"switchoff.png"];
    }
}

- (void)swipe:(UISwipeGestureRecognizer *)gesture
turningSwitchOn:(BOOL)onoff
{
    if (!self.overLay.hidden) [self startPuzzle];
    CGPoint touchPoint = [gesture locationInView:self.view];
    if (CGRectContainsPoint(self.hintsOnOffSwitch.frame, touchPoint)) {
        self.hintsOnOff = onoff;
        [self.delegate asmViewController:self didFlickHintsSwitch:self.hintsOnOff];
        [self drawSwitch];
    }
    if (self.hintsOnOff)
    {
        [self startTimer];
    }
    else
    {
        [self stopHintTimer];
    }
}

-(void)swipeUp:(UISwipeGestureRecognizer *)gesture
{
    [self swipe:gesture turningSwitchOn:YES];
}

-(void)swipeDown:(UISwipeGestureRecognizer *)gesture
{
    [self swipe:gesture turningSwitchOn:NO];
}

-(void)animateNewToken
{
    //clear all residue
        self.hintDelayCounter = [NSNumber numberWithFloat:HINT_DELAY];
    
    self.countyOnScreen = NO;
    // get the next county from the mainland data model
    if (![self.mainland isMapComplete])
    {
        [self.mainland getNextTarget];
        [self showHint];
        [self startTimer];
        self.token.image = [UIImage imageNamed:[self.mainland.targetName stringByAppendingString:@"token.png"]];
        self.token.hidden = NO;
        CGAffineTransform trans = CGAffineTransformScale(self.token.transform, 0.01, 0.01);
        [self.token setCenter:(CGPointMake(TOKEN_POS_X,TOKEN_POS_Y))];
        self.token.transform = trans;
        [UIView animateWithDuration:1.0 delay:0.0 options:UIViewAnimationCurveEaseInOut
                         animations:^{
                             self.token.transform =   CGAffineTransformScale(self.token.transform, 100.0, 100.0);
                         }
                         completion:nil];
    }
    else
    {
        NSString *Title = [NSString stringWithFormat:@"Finished"];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:Title message:@"Congratulations, you did it!" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:@"Back to Main Menu", @"PlayAgain", nil ];
        [alert show];
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        //do Nothing
    }
    if (buttonIndex == 1) {
        NSLog(@"Back to Main Menu");
        [self.presentingViewController dismissViewControllerAnimated:YES completion:^{}];
    }
    if (buttonIndex == 2) {
        NSLog(@"Play Again");
        self.mainland = nil;
        for (UIView *view in self.completedCountiesView.subviews) {
            [view removeFromSuperview];
        }
        for (UIView *view in self.completedLakesView.subviews) {
            [view removeFromSuperview];
        }
        for (UIView *view in self.completedCountyLabelsView.subviews) {
            [view removeFromSuperview];
        }
        [self.countyInView removeFromSuperview];
        [self animateNewToken];
    }

}

-(void)addMarkerAtFloatX:(float)floatX andFloatY:(float)floatY
{
    UIView *marker = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"marker.png"]];
    [marker setCenter:(CGPointMake(floatX, floatY))];
    [self.markerView addSubview:marker];

    CGAffineTransform trans = CGAffineTransformScale(marker.transform, 0.01, 0.01);
    marker.transform = trans;
    
    //roll in the animation
    UIViewAnimationOptions options = UIViewAnimationOptionCurveLinear;
    [UIView animateWithDuration:HINT_ANIMATION_DURATION/3 delay:0 options:options animations:^{
        marker.transform = CGAffineTransformRotate(CGAffineTransformScale(trans, 10.0, 10.0), 2*M_PI/3);
    } completion:^(BOOL finished) {
        if (finished) {
            [UIView animateWithDuration:HINT_ANIMATION_DURATION/3 delay:0 options:options animations:^{
                marker.transform = CGAffineTransformRotate(CGAffineTransformScale(trans, 65.0, 65.0), -2*M_PI/3);
            } completion:^(BOOL finished) {
                if (finished) {
                    [UIView animateWithDuration:HINT_ANIMATION_DURATION/3 delay:0 options:options animations:^{
                        marker.transform = CGAffineTransformScale(trans, 100.0, 100.0);
                    } completion:^(BOOL completed){
                        if (completed) {
                            [self hideHint];
                        }
                    }];
                }
            }];
        }
    }];

    
}
- (void)addGestureRecognizerToPiece:(UIView *)piece
{
    
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panPiece:)];
    [panGesture setMaximumNumberOfTouches:1];
    [panGesture setDelegate:self];
    [piece addGestureRecognizer:panGesture];
    
}
-(void)showCounty
{
    if (!self.countyOnScreen) {
        CGPoint tokenPosition = CGPointMake(self.token.center.x - 20, self.token.center.y - 50);
        [self.countyInView removeFromSuperview];
        self.countyInView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[self.mainland.targetName  stringByAppendingString:@".png"]]];
        [self.countyInView setCenter:tokenPosition];
        self.countyInView.alpha = 0.5;
        [self.countyView addSubview:self.countyInView];
        self.countyOnScreen = YES;
        
    }
}


- (void)panPiece:(UIPanGestureRecognizer *)gestureRecognizer
{
    if (!self.overLay.hidden) [self startPuzzle];
    UIView *piece = [gestureRecognizer view]; //the token label being moved
    if ([gestureRecognizer state] == UIGestureRecognizerStateBegan || [gestureRecognizer state] == UIGestureRecognizerStateChanged) {
        CGPoint translation = [gestureRecognizer translationInView:[piece superview]];
        [piece setCenter:CGPointMake([piece center].x + translation.x, [piece center].y + translation.y)];
        [self checkIfTokenInCounty];
        if (!self.mainland.isTokenInTarget)
        {
            self.countyInView.hidden = YES;
            self.countyOnScreen = NO;
        }
        [self.countyInView setCenter:CGPointMake([self.countyInView center].x + translation.x, [self.countyInView center].y + translation.y)];
        [gestureRecognizer setTranslation:CGPointZero inView:[piece superview]];
        
    } else if ([gestureRecognizer state] == UIGestureRecognizerStateEnded)
    {
        //handle the county docking & display new token (if county placed) or animate the token back to start (if not)

        if (self.mainland.isTokenInTarget)
        {
            [self dockCounty];
            self.token.hidden = YES;
            //[self stopHintTimer];
            [self animateNewToken];
        }
        else {
            
            [UIView animateWithDuration:1.5 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
                [self.token setCenter:CGPointMake(TOKEN_POS_X, TOKEN_POS_Y)];
                self.token.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1, 1);
            } completion:^(BOOL finished) {
                self.token.transform = CGAffineTransformIdentity;
            }];
            for (UIView *view in self.markerView.subviews) {
                [view removeFromSuperview];
            }
            [self.countyInView removeFromSuperview];
            self.countyOnScreen = NO;
        }
    }
}
-(void)dockCounty
{
    //Add County to array of completed counties, and remove it from the possibilities for random selection
    NSArray *coordinates = [self.mainland.targetMarkers objectForKey:self.mainland.targetName];
    CGPoint countyCenter = (CGPointMake([[coordinates objectAtIndex:0]floatValue], [[coordinates objectAtIndex:1]floatValue]));
    CGPoint countyLabelCenter = (CGPointMake([[coordinates objectAtIndex:2]floatValue], [[coordinates objectAtIndex:3]floatValue]));
    
    //add the token name to the list of counties that have been placed so it won't come up again
    [self.mainland.placedTargets addObject:self.mainland.targetName];
    // add the county spot being placed to the list of spots taken so it won't get re-labelled
    self.mainland.lastToken = self.mainland.targetName;
    //animate the county docking into it's assigned spot
    CGAffineTransform trans = CGAffineTransformScale(self.countyInView.transform, 1.0, 1.0);
    self.countyInView.transform = trans;
    [UIView animateWithDuration:1.0 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         self.countyInView.center = countyCenter;
                         self.countyInView.alpha = 0.7;
                         self.countyInView.transform =   CGAffineTransformScale(self.countyInView.transform, 0.99, 0.99);
                     }
                     completion:^(BOOL finished) {
                         self.countyInView.transform = CGAffineTransformIdentity;
                     }];
    
    
    UIView *dockedCounty = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[self.mainland.targetName stringByAppendingString:@"_complete.png"]]];
    
    dockedCounty.hidden = YES;
    dockedCounty.alpha = 0.01;
    if ([[coordinates lastObject] isEqualToString:@"Lake"]) {
        [self.completedLakesView addSubview:dockedCounty];
    } else{
        [self.completedCountiesView addSubview:dockedCounty];
    }
    
    dockedCounty.transform = CGAffineTransformScale(dockedCounty.transform, 1.0, 1.0);
    
    [UIView animateWithDuration:1.0 delay:1.0 options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         dockedCounty.hidden = NO;
                         dockedCounty.alpha = 1.0;
                         CGAffineTransform finaltrans = CGAffineTransformScale(dockedCounty.transform, 1.0, 1.0);
                         dockedCounty.transform =   finaltrans;
                     }
                     completion:nil];
    //Label needs to go onto a seperate layer (or it could get covered by other counties)
    UIView *countyLabel = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[self.mainland.targetName stringByAppendingString:@"token.png"]]];
    countyLabel.center = countyLabelCenter;
    countyLabel.hidden = YES;
    countyLabel.alpha = 0.1;
    [self.completedCountyLabelsView addSubview:countyLabel];
    countyLabel.transform = CGAffineTransformScale(countyLabel.transform, 0.01, 0.01);
    [UIView animateWithDuration:1.0 delay:2.0 options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         countyLabel.hidden = NO;
                         countyLabel.alpha =  1.0;
                         CGAffineTransform labelTrans = CGAffineTransformScale(dockedCounty.transform, 0.5, 0.5);
                         countyLabel.transform = labelTrans;
                     }
                     completion:nil];
    
    // }
    [self hideHint];
    [self stopHintTimer];
    self.hintDelayCounter = [NSNumber numberWithInt:3];
}

-(void)checkIfTokenInCounty
{
    
    NSString *county = self.mainland.targetName;
    NSArray *coordinates = [self.mainland.targetMarkers objectForKey:county];
    CGRect greaterCountyArea = CGRectMake([[coordinates objectAtIndex:2]floatValue] - 125, [[coordinates objectAtIndex:3]floatValue] - 125, 250, 250);
    BOOL inCounty = NO;
    if (CGRectContainsPoint(greaterCountyArea, self.token.center))
    {
        [self showCounty];
        inCounty = YES;
    }
    
    self.mainland.isTokenInTarget = inCounty;
    
}


- (void)viewDidUnload {
    [self setHomeNav:nil];
    [self setOverLay:nil];
    [self setCompletedLakesView:nil];
    [super viewDidUnload];
}
@end
