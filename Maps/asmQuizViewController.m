//
//  asmQuizViewController.m
//  AirSkull
//
//  Created by Jonathan Headen on 13/02/13.
//  Copyright (c) 2013 Jonathan Headen. All rights reserved.
//

#import "asmQuizViewController.h"
#import "airskullCountry.h"

@interface asmQuizViewController ()

@property (strong, nonatomic) airskullCountry *mainland;//mainland
@property (weak, nonatomic) IBOutlet UIImageView *token;
@property (weak, nonatomic) IBOutlet UIImageView *markerView;
@property (weak, nonatomic) IBOutlet UIImageView *answerA;
@property (weak, nonatomic) IBOutlet UIImageView *answerB;
@property (weak, nonatomic) IBOutlet UIImageView *answerC;
@property (weak, nonatomic) IBOutlet UIImageView *answerD;
@property (weak, nonatomic) IBOutlet UIImageView *completedCountiesView;
@property (weak, nonatomic) IBOutlet UIImageView *completedCountyLabelsView;
@property (weak, nonatomic) IBOutlet UIImageView *mapOutline;
@property (weak, nonatomic) IBOutlet UIImageView *scoreTens;
@property (weak, nonatomic) IBOutlet UIImageView *scoreUnits;
@property (weak, nonatomic) IBOutlet UIImageView *homeNav;
@property int correctAnswerPos;
@property (weak, nonatomic) IBOutlet UIImageView *tensNumAskedQuestionsImage;
@property (weak, nonatomic) IBOutlet UIImageView *unitsNumAskedQuestionsImage;
@property (nonatomic) BOOL answeringQuestion;
@property (weak, nonatomic) IBOutlet UIImageView *mapView;
@end

@implementation asmQuizViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(Tap:)];
    [self.view addGestureRecognizer:tap ];
    self.hintsOnOff = NO;
    self.homeNav.hidden = NO;
    [self loadQuestion];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(airskullCountry *)mainland
{
    if (!_mainland) {
        _mainland = [[airskullCountry alloc] init];
        _mainland.quizCategories = self.quizCategories;
    }
    return _mainland;
}

#pragma mark logic etc

-(void)animateNewToken
{
    //leave this blank to stop the tokens getting animated in Quizmode
}
-(void)loadQuestion
{   
    for (UIView *view in [self.completedCountiesView subviews]) {
        [view removeFromSuperview];
    }
    for (UIView *view in [self.markerView subviews]){
        [view removeFromSuperview];
    }
  
    NSArray *question = [self.mainland getNextQuestion];
    if ([[question lastObject] isEqualToString:@"Complete"]) {
        NSLog(@"Quiz Complete");
        //Quiz is Finished so let the user know...score etc.
        NSString *Title = [NSString stringWithFormat:@"Quiz Complete"];
        NSString *messageString = [NSString stringWithFormat:@"Your score was %@ out of %@",self.mainland.quizScore,[self.mainland.quizCategories lastObject]];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:Title message:messageString delegate:self cancelButtonTitle: @"Play Again" otherButtonTitles:@"Back to Main Menu", nil ];
        [alert show];
    }
    else
    {
        if ([[question lastObject] isEqualToString:@"County"]) {
            self.mapView.image = [UIImage imageNamed:@"Ireland.png"];
            self.mainland.mapName = @"Ireland";
            self.mapOutline.image = [UIImage imageNamed:@"IrelandOutline.png"];
        } else
        {
            self.mapView.image = [UIImage imageNamed:@"IrelandPhysical.png"];
            self.mainland.mapName = @"IrelandPhysical";
            self.mapOutline.image = [UIImage imageNamed:@"IrelandPhysicalOutline.png"];
        }
        [self drawQuestionsAsked];
        if ([[question lastObject] isEqualToString:@"County"]) self.token.image = [UIImage imageNamed:@"Countyquestion.png"];
        if ([[question lastObject] isEqualToString:@"River"]) self.token.image = [UIImage imageNamed:@"Riverquestion.png"];
        if ([[question lastObject] isEqualToString:@"MountainRange"]) self.token.image = [UIImage imageNamed:@"Mountainquestion.png"];
        if ([[question lastObject] isEqualToString:@"Island"]) self.token.image = [UIImage imageNamed:@"Islandquestion.png"];
        if ([[question lastObject] isEqualToString:@"Lake"]) self.token.image = [UIImage imageNamed:@"Lakequestion.png"];
        if ([[question lastObject] isEqualToString:@"Headland"]) self.token.image = [UIImage imageNamed:@"Headlandquestion.png"];

        NSMutableArray *answers = [[self.mainland answersForQuestion:question] mutableCopy];
        NSMutableArray *answerChoices = [[NSMutableArray alloc]init];
        int x = (arc4random() % 4);
        for (int i = 0; i < 4; i++) {
            if (i == x)
            {
                NSString * answerName = [question objectAtIndex:4];
                [answerChoices addObject:answerName];
                self.correctAnswerPos  = x;
                self.mainland.targetName=answerName;
            }
            else
            {
                [answerChoices addObject:[[answers lastObject]objectAtIndex:4]];
                [answers removeLastObject];
            }
        }
        NSLog(@"Question: %@ answers : %@ correct : %d",question,answerChoices,self.correctAnswerPos);
        self.answerA.image = [UIImage imageNamed:[[answerChoices objectAtIndex:0]stringByAppendingString:@"token.png"]];
        self.answerB.image = [UIImage imageNamed:[[answerChoices objectAtIndex:1]stringByAppendingString:@"token.png"]];
        self.answerC.image = [UIImage imageNamed:[[answerChoices objectAtIndex:2]stringByAppendingString:@"token.png"]];
        self.answerD.image = [UIImage imageNamed:[[answerChoices objectAtIndex:3]stringByAppendingString:@"token.png"]];
        [self dockCounty];
        if (([[question lastObject] isEqualToString:@"Headland"] )|| ([[question lastObject] isEqualToString:@"Island"])) {
            UIView *marker = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"marker.png"]];
            float floatX = [[question objectAtIndex:2] floatValue];
            float floatY = [[question objectAtIndex:3] floatValue];
            [marker setCenter:(CGPointMake(floatX, floatY))];
            [self.markerView addSubview:marker];
            marker.transform = CGAffineTransformScale(marker.transform, 1.0, 1.0);
            [UIView animateWithDuration:1.0 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState
                             animations:^{
                                 CGAffineTransform markerTrans = CGAffineTransformScale(marker.transform, 2.0, 2.0);
                                 marker.transform = markerTrans;
                             }
                             completion:^(BOOL complete){
                                 [UIView animateWithDuration:1.0 delay:1.0 options:UIViewAnimationOptionBeginFromCurrentState
                                                  animations:^{
                                                      CGAffineTransform markerTrans = CGAffineTransformScale(marker.transform, 0.5, 0.5);
                                                      marker.transform = markerTrans;
                                                  }
                                                  completion:nil];
                             }];
        }
    }
}

-(void)drawScores
{
    //draw the scoreboard
    int scorelabel = [self.mainland.quizScore intValue];
    int unitScore = (scorelabel % 10);
    int tensScore = ((scorelabel - unitScore) / 10);
    NSString *unitsImage = [NSString stringWithFormat:@"%d.png",unitScore];
    NSString *tensImage = [NSString stringWithFormat:@"%d.png",tensScore];
    self.scoreUnits.image = [UIImage imageNamed:unitsImage];
    self.scoreTens.image = [UIImage imageNamed:tensImage];
}
-(void)drawQuestionsAsked
{
    //draw the number questions asked
    int numAskedLabel = [self.mainland.numAskedQuestions intValue];
    int unitasked = (numAskedLabel % 10);
    int tensasked = ((numAskedLabel - unitasked) / 10);
    if (tensasked > 0) {
        NSString *numAskedUnitsImage = [NSString stringWithFormat:@"%d.png",unitasked];
        NSString *numAskedTensImage = [NSString stringWithFormat:@"%d.png",tensasked];
        self.tensNumAskedQuestionsImage.image = [UIImage imageNamed:numAskedTensImage];
        self.unitsNumAskedQuestionsImage.image = [UIImage imageNamed:numAskedUnitsImage];
        self.unitsNumAskedQuestionsImage.hidden = NO;
    } else
    {
        NSString *numAskedUnitsImage = [NSString stringWithFormat:@"%d.png",unitasked];
        self.tensNumAskedQuestionsImage.image = [UIImage imageNamed:numAskedUnitsImage];
        self.unitsNumAskedQuestionsImage.hidden = YES;
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

-(void)showTheRightAnswerWithResponseRight:(BOOL)correct
{
    [self hideHint];
    //show the label for self.mainland.targetname then remove it in load question
     NSArray *coordinates = [self.mainland.targetMarkers objectForKey:self.mainland.targetName];
     CGPoint targetLabelCenter = (CGPointMake([[coordinates objectAtIndex:2]floatValue], [[coordinates objectAtIndex:3]floatValue]));
    UIView *targetLabel = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[self.mainland.targetName stringByAppendingString:@"token.png"]]];
    targetLabel.center = targetLabelCenter;
    [self.completedCountyLabelsView addSubview:targetLabel];
    
    targetLabel.transform = CGAffineTransformScale(targetLabel.transform, 0.01, 0.01);
    [UIView animateWithDuration:1.0 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         CGAffineTransform labelTrans = CGAffineTransformScale(targetLabel.transform, 50, 50);
                         targetLabel.transform = labelTrans;
                     }
                     completion:^(BOOL complete){
                         [UIView animateWithDuration:1.0 delay:1.0 options:UIViewAnimationOptionBeginFromCurrentState
                                          animations:^{
                                              CGAffineTransform viewTrans = CGAffineTransformScale(targetLabel.transform, 0.01, 0.01);
                                              targetLabel.transform = viewTrans;
                                          }
                                          completion:^(BOOL finished){
                                              if (finished) {
                                                  [targetLabel removeFromSuperview];
                                                  self.answeringQuestion = NO;
                                              }
                                          }];
                     }];
   
    if (correct)
    {
        UIView *answerResponseLabel = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"rightanswer.png"]];
        [self flashLabel:answerResponseLabel];
    } else
    {
        UIView *answerResponseLabel = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"wronganswer.png"]];
        [self flashLabel:answerResponseLabel];
    }
}
-(void)flashLabel:(UIView *)answerResponseLabel
{

    answerResponseLabel.center  = CGPointMake(600, 800);
    [self.completedCountyLabelsView addSubview:answerResponseLabel];
    answerResponseLabel.transform = CGAffineTransformScale(answerResponseLabel.transform, 0.01, 0.01);
    [UIView animateWithDuration:1.0 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         CGAffineTransform answerTrans = CGAffineTransformScale(answerResponseLabel.transform, 100, 100);
                         answerResponseLabel.transform = answerTrans;
                     }
                     completion:^(BOOL complete){
                         [UIView animateWithDuration:1.0 delay:1.0 options:UIViewAnimationOptionBeginFromCurrentState
                                          animations:^{
                                              CGAffineTransform viewTrans = CGAffineTransformScale(answerResponseLabel.transform, 0.5, 0.5);
                                              answerResponseLabel.transform = viewTrans;
                                              answerResponseLabel.alpha = 0.2;
                                          }
                                          completion:^(BOOL finished){
                                              if (finished) {
                                                  [answerResponseLabel removeFromSuperview];
                                                  [self loadQuestion];
                                              }
                                          }];
                     }];
    
}
-(void)gotTheAnswerRight
{
    [self.mainland incrementQuizScore];
    [self drawScores];
    //animate the "show answer" & then move to next question
    [self showTheRightAnswerWithResponseRight:YES];
}
-(void)gotTheAnswerWrong
{
    //animate the "show answer" & then move to next question
    [self showTheRightAnswerWithResponseRight:NO];
    }

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
        //clicked play again or "Start Over"
        self.mainland = nil;
        [self drawScores];
        [self loadQuestion];
        
     
    }
    if (buttonIndex == 1)
    {
        //clicked back to main
        [self.presentingViewController dismissViewControllerAnimated:YES completion:^{}];
    }
    
}
        
#pragma mark UI actions
-(void) Tap:(UIGestureRecognizer *)gesture
{
    CGPoint touchPoint = [gesture locationInView:self.view];
    if ((CGRectContainsPoint(self.answerA.frame, touchPoint))&&(!self.answeringQuestion)) {
        self.answeringQuestion = YES;
        //if this is the right answer mark it Correct
        if (self.correctAnswerPos == 0)
        {
            [self gotTheAnswerRight];
        }else
        {
            [self gotTheAnswerWrong];
        }
    } 
    if ((CGRectContainsPoint(self.answerB.frame, touchPoint))&&(!self.answeringQuestion)) {
        self.answeringQuestion = YES;
        //if this is the right answer mark it Correct
        if (self.correctAnswerPos == 1)
        {
            [self gotTheAnswerRight];
        }else
        {
            [self gotTheAnswerWrong];
        }

    }
    if ((CGRectContainsPoint(self.answerC.frame, touchPoint))&&(!self.answeringQuestion)) {
        self.answeringQuestion = YES;
        //if this is the right answer mark it Correct
        if (self.correctAnswerPos == 2)
        {
            [self gotTheAnswerRight];
        }else
        {
            [self gotTheAnswerWrong];
        }

    }
    if ((CGRectContainsPoint(self.answerD.frame, touchPoint))&&(!self.answeringQuestion)) {
        self.answeringQuestion = YES;
        //if this is the right answer mark it Correct
        if (self.correctAnswerPos == 3)
        {
            [self gotTheAnswerRight];
        }else
        {
            [self gotTheAnswerWrong];
        }
    }
    if (CGRectContainsPoint(self.homeNav.frame, touchPoint)) {
        if ([self.mainland isQuizComplete]) {
            //quit
            [self.presentingViewController dismissViewControllerAnimated:YES completion:^{}];
        }
        else
        {
            NSString *Title = [NSString stringWithFormat:@"Quiz not Finished"];
            NSString *messageString = [NSString stringWithFormat:@"Are you sure you want to Quit the Quiz?"];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:Title message:messageString delegate:self cancelButtonTitle:@"Start Over" otherButtonTitles:@"Yes", @"No", nil ];
            [alert show];
        }
    }
    
}
-(void)finish
{
    [self.presentingViewController  dismissViewControllerAnimated:YES completion:^{}];
}
-(void)dockCounty
{
    //Add County to array of completed counties, and remove it from the possibilities for random selection
    UIView *dockedCounty = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[self.mainland.targetName stringByAppendingString:@"_complete.png"]]];
    
    dockedCounty.alpha = 0.01;
    [self.completedCountiesView addSubview:dockedCounty];
    
    dockedCounty.transform = CGAffineTransformScale(dockedCounty.transform, 1.0, 1.0);
    
    [UIView animateWithDuration:0 delay:1.0 options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         dockedCounty.alpha = 1.0;
                         CGAffineTransform finaltrans = CGAffineTransformScale(dockedCounty.transform, 1.0, 1.0);
                         dockedCounty.transform =   finaltrans;
                     }
                     completion:nil];
  
}


- (void)viewDidUnload {
    [self setScoreTens:nil];
    [self setScoreUnits:nil];
    [self setHomeNav:nil];
    [super viewDidUnload];
}
@end
