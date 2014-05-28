//
//  airskullCountry.h
//  AirSkull
//
//  Created by Jonathan Headen on 28/01/13.
//  Copyright (c) 2013 Jonathan Headen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface airskullCountry : NSObject
#define CORRECTSCORE @"CorrectScore"
#define COUNT_OF_COUNTIES_PLACED @"CountiesPlaced"
#define HINT_DELAY_TIMER 1.0 //hint timer interval
#define HINT_DELAY 3.0 //number of seconds before the hint is shown
#define HINT_ANIMATION_DURATION 2.0
#define AIRSKULL_DEFAULTS_KEY @"AirSkullIrelandMapDefaults"
#define AIRSKULL_COUNTIES_SWITCH @"AirSkullCountiesSwitch"
#define AIRSKULL_MOUNTAINS_SWITCH @"AirSkullMountainsSwitch"
#define AIRSKULL_RIVERS_SWITCH @"AirSkullRiversSwitch"
#define AIRSKULL_ISLANDS_SWITCH @"AirSkullIslandsSwitch"
#define AIRSKULL_LAKES_SWITCH @"AirSkullLakesSwitch"
#define AIRSKULL_HEADLANDS_SWITCH @"AirSkullHeadlandsSwitch"
#define AIRSKULL_HINTS_SWITCH @"AirSkullHintsSwitch"

@property  BOOL isTokenInCounty; // is the token in the hotspot or not?
//@property (strong,nonatomic) NSMutableDictionary *answers;
@property (strong, nonatomic) NSDictionary *targetMarkers;
@property (strong, nonatomic) NSMutableArray *targetMarkerHints; //the list of nearby counties for which a marker should be drawn - is this needed ?
//consider if these two can be folded into one as it's now only the county on the token that could be shown
//@property (strong, nonatomic) NSString *tokenCounty; //the target name on the label & county map name recorded in countyMapsPlaced
@property (strong, nonatomic) NSString * targetName; //the token county name lowercase
@property (strong, nonatomic) NSMutableArray *placedTargets; // counties that have been placed
@property (strong, nonatomic) NSMutableArray *unPlacedTargets; // counties that have  not been placed
@property (strong, nonatomic) NSMutableDictionary *allQuestions; //quiz questions that haven't been asked yet
@property (strong, nonatomic) NSString *mapName; //what map are we using
@property (strong, nonatomic) NSString *mapSections; //which types should be shown
@property (nonatomic) BOOL isTokenInTarget;
@property (strong,nonatomic) NSArray *quizCategories; //last enty is number of questions
@property (strong,nonatomic) NSNumber *quizScore;
@property (strong,nonatomic) NSNumber *numAskedQuestions; // the number of questions asked

@property (nonatomic,strong) NSString * lastToken; //use this while programming to get the placement right for targets 
-(void) getNextTarget;
-(BOOL) isMapComplete; //are we there yet?
-(BOOL) isQuizComplete; // huh? are we?
-(void) incrementQuizScore; //add a point

//implement the quiz
//the airskullcountry should contain the list of questions: number questions = 20 intially
//can be a mix of counties , rivers, mountains , lakes , islands /headlands
//choose x questions from master array
// 4 from each type then combine the remainder and choose at random
// question is @"what %@ is this?", target.type
//show 4 possible answers including the correct one. validate the correct one is only listed once and the other three choices are the same type
-(NSArray *) getNextQuestion; //the array from targetMarkers name position type etc.
-(NSArray *)answersForQuestion:(NSArray *)question; //get the 3 other choices for the question




@end
