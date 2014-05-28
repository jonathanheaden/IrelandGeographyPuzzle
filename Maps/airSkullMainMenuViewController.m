//
//  airSkullMainMenuViewController.m
//  AirSkull
//
//  Created by Jonathan Headen on 3/02/13.
//  Copyright (c) 2013 Jonathan Headen. All rights reserved.
//

#import "airSkullMainMenuViewController.h"
#import "asmViewController.h"
#import "asmQuizViewController.h"
#import "airskullCountry.h"

@interface airSkullMainMenuViewController () <asmViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *configOptions; //130 x 768
@property (weak, nonatomic) IBOutlet UIImageView *quizIcon;
@property (weak, nonatomic) IBOutlet UIImageView *mountainsQuizSwitch;
@property (weak, nonatomic) IBOutlet UIImageView *riversQuizSwitch;
@property (weak, nonatomic) IBOutlet UIImageView *islandsQuizSwitch;
@property (weak, nonatomic) IBOutlet UIImageView *lakesQuizSwitch;
@property (weak, nonatomic) IBOutlet UIImageView *headlandsQuizSwitch;
@property (strong, nonatomic) NSString *map;
@property (strong, nonatomic) NSString *mapSections;
@property (weak, nonatomic) IBOutlet UIImageView *countiesQuizSwitch;
@property (weak, nonatomic) IBOutlet UIImageView *hintsOnOffSwitch;
@property (nonatomic) BOOL hintsOnOff;
@property (nonatomic) BOOL countiesQuizOnOff;
@property (nonatomic) BOOL mountainsQuizOnOff;
@property (nonatomic) BOOL riversQuizOnOff;
@property (nonatomic) BOOL lakesQuizOnOff;
@property (nonatomic) BOOL headlandsQuizOnOff;
@property (nonatomic) int maxQuestions;
@property (weak, nonatomic) IBOutlet UIImageView *hintOnOffCue;
@property (weak, nonatomic) IBOutlet UIImageView *backToHomeCue;
@property (nonatomic) BOOL islandsQuizOnOff;
@property (nonatomic, strong) NSMutableArray *quizSections;
//the Main Menu Icons
@property (weak, nonatomic) IBOutlet UIImageView *mapCountiesIcon;
@property (weak, nonatomic) IBOutlet UIImageView *mapRiversLakesIcon;
@property (weak, nonatomic) IBOutlet UIImageView *mapMountainsIslandsIcon;
@property (weak, nonatomic) IBOutlet UIImageView *quizQuestions10;
@property (weak, nonatomic) IBOutlet UIImageView *quizQuestions20;

@end

@implementation airSkullMainMenuViewController


-(NSMutableArray *)quizSections
{
    if (!_quizSections) _quizSections = [[NSMutableArray alloc]init];
    return _quizSections;
}
 

- (void)viewDidLoad
{
    [super viewDidLoad];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(Tap:)];
    [self.view addGestureRecognizer:tap ];
    
    UISwipeGestureRecognizer *swipeDown = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeDown:)];
    swipeDown.direction = UISwipeGestureRecognizerDirectionDown;
    UISwipeGestureRecognizer *swipeUp = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeUp:)];
    swipeUp.direction = UISwipeGestureRecognizerDirectionUp;
    [self.view addGestureRecognizer:swipeDown];
    [self.view addGestureRecognizer:swipeUp];
    
    NSDictionary *airSkullDefaults = [self getDefaults];
    self.countiesQuizOnOff = [[airSkullDefaults objectForKey:AIRSKULL_COUNTIES_SWITCH] boolValue];
    self.mountainsQuizOnOff = [[airSkullDefaults objectForKey:AIRSKULL_MOUNTAINS_SWITCH] boolValue];
    self.riversQuizOnOff = [[airSkullDefaults objectForKey:AIRSKULL_RIVERS_SWITCH] boolValue];
    self.islandsQuizOnOff = [[airSkullDefaults objectForKey:AIRSKULL_ISLANDS_SWITCH] boolValue];
    self.lakesQuizOnOff = [[airSkullDefaults objectForKey:AIRSKULL_LAKES_SWITCH] boolValue];
    self.headlandsQuizOnOff = [[airSkullDefaults objectForKey:AIRSKULL_HEADLANDS_SWITCH] boolValue];
    self.hintsOnOff = [[airSkullDefaults objectForKey:AIRSKULL_HINTS_SWITCH] boolValue];
    self.maxQuestions = 0;
    [self drawScreenSwitches];
    
    
    
}

-(NSMutableDictionary *)getDefaults
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary  *airSkullDefaults = [[defaults objectForKey:AIRSKULL_DEFAULTS_KEY] mutableCopy];
    if (!airSkullDefaults)
    {
        airSkullDefaults = [[NSMutableDictionary alloc]init];
        [airSkullDefaults setObject:[NSNumber numberWithBool:YES] forKey:AIRSKULL_COUNTIES_SWITCH];
        [airSkullDefaults setObject:[NSNumber numberWithBool:YES] forKey:AIRSKULL_MOUNTAINS_SWITCH];
        [airSkullDefaults setObject:[NSNumber numberWithBool:YES] forKey:AIRSKULL_RIVERS_SWITCH];
        [airSkullDefaults setObject:[NSNumber numberWithBool:YES] forKey:AIRSKULL_ISLANDS_SWITCH];
        [airSkullDefaults setObject:[NSNumber numberWithBool:YES] forKey:AIRSKULL_LAKES_SWITCH];
        [airSkullDefaults setObject:[NSNumber numberWithBool:YES] forKey:AIRSKULL_HEADLANDS_SWITCH];
        [airSkullDefaults setObject:[NSNumber numberWithBool:YES] forKey:AIRSKULL_HINTS_SWITCH];
        self.countiesQuizOnOff = YES;
        self.mountainsQuizOnOff = YES;
        self.riversQuizOnOff = YES;
        self.islandsQuizOnOff = YES;
        self.hintsOnOff = YES;
        [defaults setObject:airSkullDefaults forKey:AIRSKULL_DEFAULTS_KEY];
        [defaults synchronize];
    }
    return airSkullDefaults;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void)setDefaults
{
    NSMutableDictionary *airSkullDefaults = [self getDefaults];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [airSkullDefaults setObject:[NSNumber numberWithBool:self.countiesQuizOnOff] forKey:AIRSKULL_COUNTIES_SWITCH];
    [airSkullDefaults setObject:[NSNumber numberWithBool:self.mountainsQuizOnOff] forKey:AIRSKULL_MOUNTAINS_SWITCH];
    [airSkullDefaults setObject:[NSNumber numberWithBool:self.riversQuizOnOff] forKey:AIRSKULL_RIVERS_SWITCH];
    [airSkullDefaults setObject:[NSNumber numberWithBool:self.islandsQuizOnOff] forKey:AIRSKULL_ISLANDS_SWITCH];
    
    [airSkullDefaults setObject:[NSNumber numberWithBool:self.lakesQuizOnOff] forKey:AIRSKULL_LAKES_SWITCH];
    
    [airSkullDefaults setObject:[NSNumber numberWithBool:self.headlandsQuizOnOff] forKey:AIRSKULL_HEADLANDS_SWITCH];
    [airSkullDefaults setObject:[NSNumber numberWithBool:self.hintsOnOff] forKey:AIRSKULL_HINTS_SWITCH];
    [defaults setObject:airSkullDefaults forKey:AIRSKULL_DEFAULTS_KEY];
    [defaults synchronize];
    NSLog(@"%@",airSkullDefaults);
}
#pragma mark logic
-(NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait ;
}

#pragma mark actions

-(void) drawScreenSwitches
{
    if (self.countiesQuizOnOff) {
        self.countiesQuizSwitch.image = [UIImage imageNamed:@"switchon.png"];
    } else {
        self.countiesQuizSwitch.image = [UIImage imageNamed:@"switchoff.png"];
    }
    
    if (self.mountainsQuizOnOff) {
        self.mountainsQuizSwitch.image = [UIImage imageNamed:@"switchon.png"];
    } else {
        self.mountainsQuizSwitch.image = [UIImage imageNamed:@"switchoff.png"];
    }
    
    if (self.riversQuizOnOff) {
        self.riversQuizSwitch.image = [UIImage imageNamed:@"switchon.png"];
    } else {
        self.riversQuizSwitch.image = [UIImage imageNamed:@"switchoff.png"];
    }
    
    if (self.islandsQuizOnOff) {
        self.islandsQuizSwitch.image = [UIImage imageNamed:@"switchon.png"];
    } else {
        self.islandsQuizSwitch.image = [UIImage imageNamed:@"switchoff.png"];
    }
    
    if (self.lakesQuizOnOff) {
        self.lakesQuizSwitch.image = [UIImage imageNamed:@"switchon.png"];
    } else {
        self.lakesQuizSwitch.image = [UIImage imageNamed:@"switchoff.png"];
    }
    
    if (self.headlandsQuizOnOff) {
        self.headlandsQuizSwitch.image = [UIImage imageNamed:@"switchon.png"];
    } else {
        self.headlandsQuizSwitch.image = [UIImage imageNamed:@"switchoff.png"];
    }
    
    if (self.hintsOnOff) {
        self.hintsOnOffSwitch.image = [UIImage imageNamed:@"switchon.png"];
    } else {
        self.hintsOnOffSwitch.image = [UIImage imageNamed:@"switchoff.png"];
    }

}
-(void) Tap:(UIGestureRecognizer *)gesture
{
    //self.hintOnOffCue.hidden = YES;
    self.backToHomeCue.hidden = YES;
    CGPoint touchPoint = [gesture locationInView:self.view];
    if (CGRectContainsPoint(self.mapCountiesIcon.frame, touchPoint)) {
        self.map = @"Ireland";
        self.mapSections = @"Counties";
        [self performSegueWithIdentifier:@"Show Map" sender:self];
    }
    
    if (CGRectContainsPoint(self.mapRiversLakesIcon.frame, touchPoint)) {
        self.map = @"IrelandPhysical";
        //self.map = @"alllakesandrivers";
        self.mapSections = @"RiversLakes";
        [self performSegueWithIdentifier:@"Show Map" sender:self];
    }
    if (CGRectContainsPoint(self.mapMountainsIslandsIcon.frame, touchPoint)) {
        self.map = @"IrelandPhysical";
       // self.map = @"allmountains";
        self.mapSections = @"MountainsIslands";
        [self performSegueWithIdentifier:@"Show Map" sender:self];
    }
    
    if (CGRectContainsPoint(self.quizQuestions20.frame, touchPoint)) {
        [self prepareForQuizwithQuestions:20];
    }

    if (CGRectContainsPoint(self.quizQuestions10.frame, touchPoint)) {
        [self prepareForQuizwithQuestions:10];
    }
    
    if (CGRectContainsPoint(self.countiesQuizSwitch.frame, touchPoint)) {
        self.countiesQuizOnOff = !self.countiesQuizOnOff;
        [self setDefaults];
        [self drawScreenSwitches];
    }
    
    if (CGRectContainsPoint(self.mountainsQuizSwitch.frame, touchPoint)) {
        self.mountainsQuizOnOff = !self.mountainsQuizOnOff;
        [self setDefaults];
        [self drawScreenSwitches];
    }
    
    if (CGRectContainsPoint(self.riversQuizSwitch.frame, touchPoint)) {
        self.riversQuizOnOff = !self.riversQuizOnOff;
        [self setDefaults];
        [self drawScreenSwitches];
        
    }
    if (CGRectContainsPoint(self.islandsQuizSwitch.frame, touchPoint)) {
        self.islandsQuizOnOff = !self.islandsQuizOnOff;
        [self setDefaults];
        [self drawScreenSwitches];
    }
    
    if (CGRectContainsPoint(self.lakesQuizSwitch.frame, touchPoint)) {
        self.lakesQuizOnOff = !self.lakesQuizOnOff;
        [self setDefaults];
        [self drawScreenSwitches];
    }
    
    if (CGRectContainsPoint(self.headlandsQuizSwitch.frame, touchPoint)) {
        self.headlandsQuizOnOff = !self.headlandsQuizOnOff;
        [self setDefaults];
        [self drawScreenSwitches];
    }
    
    if (CGRectContainsPoint(self.hintsOnOffSwitch.frame, touchPoint)) {
        self.hintsOnOff = !self.hintsOnOff;
        [self setDefaults];
        [self drawScreenSwitches];
    }
    
    
}
-(void)prepareForQuizwithQuestions:(int)numberOfQuestions
{
    
    if (self.countiesQuizOnOff)
    {
        [self.quizSections addObject:@"Counties"];
        self.maxQuestions += 32;
    }
    if (self.riversQuizOnOff)
    {
        [self.quizSections addObject:@"Rivers"];
        self.maxQuestions += 21;
    }
    if (self.mountainsQuizOnOff)
    {
        [self.quizSections addObject:@"Mountains"];
        self.maxQuestions += 19;
    }
    if (self.islandsQuizOnOff)
    {
        [self.quizSections addObject:@"Islands"];
        self.maxQuestions += 8;
    }
    if (self.lakesQuizOnOff)
    {
        [self.quizSections addObject:@"Lakes"];
        self.maxQuestions += 14;
    }
    
    if (self.headlandsQuizOnOff)
    {
        [self.quizSections addObject:@"Headlands"];
        self.maxQuestions += 9;
    }
    if (self.maxQuestions == 0) {
        NSString *Title = [NSString stringWithFormat:@"Quiz Sections Needed"];
        NSString *messageString = [NSString stringWithFormat:@"No Quiz Sections Selected! Press on one or more of the switches to select categories"];
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:Title message:messageString delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        
    }
    else
    {
        if (self.maxQuestions < numberOfQuestions) {
            [self.quizSections addObject:[NSNumber numberWithInt:self.maxQuestions]];
            [self performSegueWithIdentifier:@"Show Quiz" sender:self];
        }
        else
        {
            [self.quizSections addObject:[NSNumber numberWithInt:numberOfQuestions]];
            [self performSegueWithIdentifier:@"Show Quiz" sender:self];
        }
    }

}
- (void)swipe:(UISwipeGestureRecognizer *)gesture
turningSwitchOn:(BOOL)onoff
{
    CGPoint touchPoint = [gesture locationInView:self.view];
    if (CGRectContainsPoint(self.countiesQuizSwitch.frame, touchPoint)) {
        self.countiesQuizOnOff =  onoff;
        [self setDefaults];
        [self drawScreenSwitches];
    }
    
    if (CGRectContainsPoint(self.mountainsQuizSwitch.frame, touchPoint)) {
        self.mountainsQuizOnOff = onoff;
        [self setDefaults];
        [self drawScreenSwitches];
    }
    
    if (CGRectContainsPoint(self.riversQuizSwitch.frame, touchPoint)) {
        self.riversQuizOnOff = onoff;
        [self setDefaults];
        [self drawScreenSwitches];
        
    }
    if (CGRectContainsPoint(self.islandsQuizSwitch.frame, touchPoint)) {
        self.islandsQuizOnOff = onoff;
        [self setDefaults];
        [self drawScreenSwitches];
    }
    
    if (CGRectContainsPoint(self.lakesQuizSwitch.frame, touchPoint)) {
        self.lakesQuizOnOff = onoff;
        [self setDefaults];
        [self drawScreenSwitches];
    }
    
    if (CGRectContainsPoint(self.headlandsQuizSwitch.frame, touchPoint)) {
        self.headlandsQuizOnOff = onoff;
        [self setDefaults];
        [self drawScreenSwitches];
    }
    
    if (CGRectContainsPoint(self.hintsOnOffSwitch.frame, touchPoint)) {
        self.hintsOnOff = onoff;
        [self setDefaults];
        [self drawScreenSwitches];
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


-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
}

#pragma protocol implemetation
-(void)launchTheQuiz
{
     [self performSegueWithIdentifier:@"Show Quiz" sender:self];
}

-(void)asmViewController:(asmViewController *)sender puzzleComplete:(BOOL)completed
{
    [self dismissViewControllerAnimated:YES completion:^{}];
}

-(void)asmViewController:(asmViewController *)sender didFlickHintsSwitch:(BOOL)toggleOnOff
{
    self.hintsOnOff = toggleOnOff;
    [self setDefaults];
    [self drawScreenSwitches];
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.destinationViewController isKindOfClass:[asmViewController class]]) {
        asmQuizViewController *puzzle = (asmQuizViewController *)segue.destinationViewController;
        puzzle.quizCategories = self.quizSections;
        self.quizSections = nil;
        self.maxQuestions = 0; //reset to zero after setting the quiz sections to avoid accumulating tallies
        puzzle.mapData = self.map;
        puzzle.mapSections = self.mapSections;
        puzzle.hintsOnOff = self.hintsOnOff;
        puzzle.delegate = self;
    }
}

- (void)viewDidUnload {
    [self setHintOnOffCue:nil];
    [self setLakesQuizSwitch:nil];
    [self setHeadlandsQuizSwitch:nil];
    [self setBackToHomeCue:nil];
    [super viewDidUnload];
}
@end
