//
//  airskullCountry.m
//  AirSkull
//
//  Created by Jonathan Headen on 28/01/13.
//  Copyright (c) 2013 Jonathan Headen. All rights reserved.
//

#import "airskullCountry.h"
@interface airskullCountry  ()
@property (strong,nonatomic) NSArray *countyNames;
@property (strong,nonatomic) NSArray *mountainNames;
@property (strong,nonatomic) NSArray *riverNames;
@property (strong,nonatomic) NSArray *islandNames;
@property (strong, nonatomic) NSArray *lakeNames;
@property (strong, nonatomic) NSArray *headlandNames;
@property (strong, nonatomic) NSDictionary *countyMarkers;
@property (strong, nonatomic) NSDictionary *riverMarkers;
@property (strong, nonatomic) NSDictionary *mountainMarkers;
@property (strong, nonatomic) NSDictionary *islandMarkers;
@property (strong, nonatomic) NSDictionary *lakeMarkers;
@property (strong, nonatomic) NSDictionary *headlandMarkers;
@property (nonatomic) BOOL showHints;@end
@implementation airskullCountry

-(NSNumber *)numAskedQuestions
{
    if (!_numAskedQuestions) _numAskedQuestions = [NSNumber numberWithInt:0];
    return _numAskedQuestions;
}

-(NSNumber *)quizScore
{
    if (!_quizScore) _quizScore = [NSNumber numberWithInt:0];
    return _quizScore;
}
-(NSDictionary *)allQuestions
{
    if (!_allQuestions) _allQuestions = [self getListOfQuestions];
    return _allQuestions;
}
-(NSArray *)countyNames
{
    return [NSArray arrayWithObjects:@"Dublin",@"Kildare",@"Meath",@"Westmeath",@"Wicklow",@"Wexford",
            @"Louth", @"Longford",@"Laois",@"Offaly",@"Kilkenny",@"Carlow",@"Galway",@"Mayo",@"Sligo",
            @"Leitrim",@"Roscommon",@"Kerry",@"Cork",@"Waterford",@"Limerick",@"Clare",@"Tipperary",
            @"Donegal",@"Cavan",@"Monaghan",@"Tyrone",@"Derry",@"Fermanagh",@"Antrim",@"Armagh",@"Down", nil];
}


-(NSArray *)mountainNames
{
    return [NSArray arrayWithObjects:@"Antrimplateau", @"Galtees", @"Ox", @"Blackstairs", @"Knockmealdown", @"Partry",
            @"Bluestacks", @"Macgillycuddyreeks", @"Silvermines", @"Boggeragh", @"Maumturk", @"Slievebloom",@"Comeragh", @"Mournes",
            @"Sperrins", @"Derrynasaggart", @"Mullaghreirk", @"Wicklowmtns", @"Derryveagh", @"Nephinbeg", nil];
}

-(NSArray *)islandNames
{
    return [NSArray arrayWithObjects:@"Achill",@"Aran",@"Aranislands",@"Blaskets",@"Great",@"Rathlin",@"Valentia",@"Bere",nil];
}

-(NSArray *)headlandNames
{
    return [NSArray arrayWithObjects:@"Howth", @"Carnsore",@"Hook",@"Kinsale",@"Mizen", @"Loop",
            @"Hags",@"Erris",@"Malin", nil];
}



-(NSArray *)riverNames
{
    return [NSArray arrayWithObjects:@"Shannon", @"Liffey",@"Lee",@"Boyne",@"Annalee",@"Erne",@"Bann",@"Finn",@"Moy",@"Barrow",
            @"Foyleriver",@"Nore",@"Blackwaterleinster",@"Inny",@"Blackwatermunster",@"Lagan",@"Slaney", @"Blackwaterulster",
            @"Laune",@"Suck",@"Suir",nil];
}

-(NSArray *)lakeNames
{
    return [NSArray arrayWithObjects:@"Allen",@"Conn",@"Foyle",@"Neagh",@"Uppererne",@"Bangor",@"Corrib",@"Lowererne",
            @"Ree",@"Carlingford",@"Derg",@"Mask",@"Swilly",@"Belfast", nil];
}


-(NSMutableArray *)unPlacedTargets
{
    if (!_unPlacedTargets) _unPlacedTargets = [self getListOfTargets];
    for (NSString *county in self.placedTargets) {
        if ([_unPlacedTargets containsObject:county]) {
            [_unPlacedTargets removeObjectIdenticalTo:county];
        }
    }
    return _unPlacedTargets;
}
-(NSMutableArray *)placedTargets
{
    if(!_placedTargets)_placedTargets = [[NSMutableArray alloc]init];
    return _placedTargets;
}
-(NSMutableArray *)targetMarkerHints
{
    if (!_targetMarkerHints) _targetMarkerHints = [[NSMutableArray alloc]init];
    return _targetMarkerHints;
    
}

-(NSDictionary *)targetMarkers
{

    if ([self.mapName isEqualToString:@"Ireland"]) {
        return [self.countyMarkers copy];
    }
    else
    {
        NSMutableDictionary *result = [[NSMutableDictionary alloc] init];
        [result addEntriesFromDictionary:self.riverMarkers];
        [result addEntriesFromDictionary:self.mountainMarkers];
        [result addEntriesFromDictionary:self.islandMarkers];
        [result addEntriesFromDictionary:self.lakeMarkers];
        [result addEntriesFromDictionary:self.headlandMarkers];
         return result;
    }
   
}
-(NSDictionary *)countyMarkers
{
    //Each entry consists of  0 image center x, 1 image center y, 2 label position , 3 label position y, 4 county name, 5 province name, 6 type = county
    NSMutableDictionary * result = [[NSMutableDictionary alloc]init];
    [result setObject:[NSArray arrayWithObjects:[NSNumber numberWithInt:170],[NSNumber numberWithInt:316],[NSNumber numberWithInt:185],[NSNumber numberWithInt:310],@"Mayo",@"Connaught",@"County",nil] forKey:@"Mayo"];
    [result setObject:[NSArray arrayWithObjects:[NSNumber numberWithInt:211],[NSNumber numberWithInt:438],[NSNumber numberWithInt:214],[NSNumber numberWithInt:439],@"Galway",@"Connaught",@"County",nil] forKey:@"Galway"];
    [result setObject:[NSArray arrayWithObjects:[NSNumber numberWithInt:270],[NSNumber numberWithInt:263],[NSNumber numberWithInt:273],[NSNumber numberWithInt:272],@"Sligo",@"Connaught",@"County",nil] forKey:@"Sligo"]; //
    [result setObject:[NSArray arrayWithObjects:[NSNumber numberWithInt:306],[NSNumber numberWithInt:361],[NSNumber numberWithInt:326],[NSNumber numberWithInt:335],@"Roscommon",@"Connaught",@"County",nil] forKey:@"Roscommon"];//
    [result setObject:[NSArray arrayWithObjects:[NSNumber numberWithInt:354],[NSNumber numberWithInt:265],[NSNumber numberWithInt:321],[NSNumber numberWithInt:233],@"Leitrim",@"Connaught",@"County",nil] forKey:@"Leitrim"];
    
    [result setObject:[NSArray arrayWithObjects:[NSNumber numberWithInt:366],[NSNumber numberWithInt:99],[NSNumber numberWithInt:366],[NSNumber numberWithInt:99],@"Donegal",@"Ulster",@"County",nil] forKey:@"Donegal"];
    [result setObject:[NSArray arrayWithObjects:[NSNumber numberWithInt:486],[NSNumber numberWithInt:99],[NSNumber numberWithInt:486],[NSNumber numberWithInt:99],@"Derry",@"Ulster",@"County",nil] forKey:@"Derry"];
    [result setObject:[NSArray arrayWithObjects:[NSNumber numberWithInt:452],[NSNumber numberWithInt:160],[NSNumber numberWithInt:452],[NSNumber numberWithInt:160],@"Tyrone",@"Ulster",@"County",nil] forKey:@"Tyrone"];
    [result setObject:[NSArray arrayWithObjects:[NSNumber numberWithInt:394],[NSNumber numberWithInt:222],[NSNumber numberWithInt:404],[NSNumber numberWithInt:212],@"Fermanagh",@"Ulster",@"County",nil] forKey:@"Fermanagh"];
    [result setObject:[NSArray arrayWithObjects:[NSNumber numberWithInt:583],[NSNumber numberWithInt:105],[NSNumber numberWithInt:583],[NSNumber numberWithInt:105],@"Antrim",@"Ulster",@"County",nil] forKey:@"Antrim"];
    [result setObject:[NSArray arrayWithObjects:[NSNumber numberWithInt:613],[NSNumber numberWithInt:218],[NSNumber numberWithInt:613],[NSNumber numberWithInt:218],@"Down",@"Ulster",@"County",nil] forKey:@"Down"];
    [result setObject:[NSArray arrayWithObjects:[NSNumber numberWithInt:532],[NSNumber numberWithInt:236],[NSNumber numberWithInt:532],[NSNumber numberWithInt:237],@"Armagh",@"Ulster",@"County",nil] forKey:@"Armagh"];
    [result setObject:[NSArray arrayWithObjects:[NSNumber numberWithInt:489],[NSNumber numberWithInt:262],[NSNumber numberWithInt:489],[NSNumber numberWithInt:262],@"Monaghan",@"Ulster",@"County",nil] forKey:@"Monaghan"];
    [result setObject:[NSArray arrayWithObjects:[NSNumber numberWithInt:427],[NSNumber numberWithInt:290],[NSNumber numberWithInt:427],[NSNumber numberWithInt:290],@"Cavan",@"Ulster",@"County",nil] forKey:@"Cavan"];
    
    [result setObject:[NSArray arrayWithObjects:[NSNumber numberWithInt:208],[NSNumber numberWithInt:541],[NSNumber numberWithInt:223],[NSNumber numberWithInt:541],@"Clare",@"Munster",@"County",nil] forKey:@"Clare"];
    [result setObject:[NSArray arrayWithObjects:[NSNumber numberWithInt:250],[NSNumber numberWithInt:622],[NSNumber numberWithInt:249],[NSNumber numberWithInt:624],@"Limerick",@"Munster",@"County",nil] forKey:@"Limerick"];
    [result setObject:[NSArray arrayWithObjects:[NSNumber numberWithInt:103],[NSNumber numberWithInt:698],[NSNumber numberWithInt:128],[NSNumber numberWithInt:728],@"Kerry",@"Munster",@"County",nil] forKey:@"Kerry"];
    [result setObject:[NSArray arrayWithObjects:[NSNumber numberWithInt:220],[NSNumber numberWithInt:748],[NSNumber numberWithInt:252],[NSNumber numberWithInt:746],@"Cork",@"Munster",@"County",nil] forKey:@"Cork"];
    [result setObject:[NSArray arrayWithObjects:[NSNumber numberWithInt:360],[NSNumber numberWithInt:584],[NSNumber numberWithInt:350],[NSNumber numberWithInt:570],@"Tipperary",@"Munster",@"County",nil] forKey:@"Tipperary"];
    [result setObject:[NSArray arrayWithObjects:[NSNumber numberWithInt:410],[NSNumber numberWithInt:698],[NSNumber numberWithInt:410],[NSNumber numberWithInt:698],@"Waterford",@"Munster",@"County",nil] forKey:@"Waterford"];
   
    [result setObject:[NSArray arrayWithObjects:[NSNumber numberWithInt:390],[NSNumber numberWithInt:357],[NSNumber numberWithInt:390],[NSNumber numberWithInt:357],@"Longford",@"Leinster",@"County",nil] forKey:@"Longford"];
    [result setObject:[NSArray arrayWithObjects:[NSNumber numberWithInt:420],[NSNumber numberWithInt:398],[NSNumber numberWithInt:420],[NSNumber numberWithInt:408],@"Westmeath",@"Leinster",@"County",nil] forKey:@"Westmeath"];
    [result setObject:[NSArray arrayWithObjects:[NSNumber numberWithInt:504],[NSNumber numberWithInt:374],[NSNumber numberWithInt:524],[NSNumber numberWithInt:374],@"Meath",@"Leinster",@"County",nil] forKey:@"Meath"];
    [result setObject:[NSArray arrayWithObjects:[NSNumber numberWithInt:554],[NSNumber numberWithInt:317],[NSNumber numberWithInt:554],[NSNumber numberWithInt:317],@"Louth",@"Leinster",@"County",nil] forKey:@"Louth"];
    [result setObject:[NSArray arrayWithObjects:[NSNumber numberWithInt:413],[NSNumber numberWithInt:428],[NSNumber numberWithInt:409],[NSNumber numberWithInt:458],@"Offaly",@"Leinster",@"County",nil] forKey:@"Offaly"];
    [result setObject:[NSArray arrayWithObjects:[NSNumber numberWithInt:506],[NSNumber numberWithInt:480],[NSNumber numberWithInt:506],[NSNumber numberWithInt:460],@"Kildare",@"Leinster",@"County",nil] forKey:@"Kildare"];
    [result setObject:[NSArray arrayWithObjects:[NSNumber numberWithInt:574],[NSNumber numberWithInt:419],[NSNumber numberWithInt:574],[NSNumber numberWithInt:419],@"Dublin",@"Leinster",@"County",nil] forKey:@"Dublin"];
    [result setObject:[NSArray arrayWithObjects:[NSNumber numberWithInt:438],[NSNumber numberWithInt:516],[NSNumber numberWithInt:438],[NSNumber numberWithInt:516],@"Laois",@"Leinster",@"County",nil] forKey:@"Laois"];
    [result setObject:[NSArray arrayWithObjects:[NSNumber numberWithInt:445],[NSNumber numberWithInt:608],[NSNumber numberWithInt:445],[NSNumber numberWithInt:608],@"Kilkenny",@"Leinster",@"County",nil] forKey:@"Kilkenny"];
    [result setObject:[NSArray arrayWithObjects:[NSNumber numberWithInt:509],[NSNumber numberWithInt:580],[NSNumber numberWithInt:496],[NSNumber numberWithInt:580],@"Carlow",@"Leinster",@"County",nil] forKey:@"Carlow"];
    [result setObject:[NSArray arrayWithObjects:[NSNumber numberWithInt:560],[NSNumber numberWithInt:520],[NSNumber numberWithInt:560],[NSNumber numberWithInt:520],@"Wicklow",@"Leinster",@"County",nil] forKey:@"Wicklow"];
    [result setObject:[NSArray arrayWithObjects:[NSNumber numberWithInt:539],[NSNumber numberWithInt:629],[NSNumber numberWithInt:539],[NSNumber numberWithInt:629],@"Wexford",@"Leinster",@"County",nil] forKey:@"Wexford"];
    
    if ([self.mapName isEqualToString:@"AllIreland"] ) {
        return result;
    }
    return result;
}

-(NSDictionary *)mountainMarkers
{
    
    //Each entry consists of  0 image center x, 1 image center y, 2 label position , 3 label position y, 4 county name, 5 province name, 6 type = county
    NSMutableDictionary *result = [[NSMutableDictionary alloc] init];
    [result setObject:[NSArray arrayWithObjects:[NSNumber numberWithInt:578],[NSNumber numberWithInt:90],[NSNumber numberWithInt:612],[NSNumber numberWithInt:152],@"Antrimplateau",@"Ulster",@"MountainRange",nil] forKey:@"Antrimplateau"];
    [result setObject:[NSArray arrayWithObjects:[NSNumber numberWithInt:320],[NSNumber numberWithInt:641],[NSNumber numberWithInt:334],[NSNumber numberWithInt:615],@"Galtees",@"Ulster",@"MountainRange",nil] forKey:@"Galtees"];
    [result setObject:[NSArray arrayWithObjects:[NSNumber numberWithInt:243],[NSNumber numberWithInt:276],[NSNumber numberWithInt:298],[NSNumber numberWithInt:277],@"Ox",@"Connaught",@"MountainRange",nil] forKey:@"Ox"];
    [result setObject:[NSArray arrayWithObjects:[NSNumber numberWithInt:355],[NSNumber numberWithInt:673],[NSNumber numberWithInt:379],[NSNumber numberWithInt:692],@"Knockmealdown",@"Ulster",@"MountainRange",nil] forKey:@"Knockmealdown"];
    [result setObject:[NSArray arrayWithObjects:[NSNumber numberWithInt:509],[NSNumber numberWithInt:597],[NSNumber numberWithInt:526],[NSNumber numberWithInt:629],@"Blackstairs",@"Ulster",@"MountainRange",nil] forKey:@"Blackstairs"];
    [result setObject:[NSArray arrayWithObjects:[NSNumber numberWithInt:156],[NSNumber numberWithInt:362],[NSNumber numberWithInt:181],[NSNumber numberWithInt:340],@"Partry",@"Ulster",@"MountainRange",nil] forKey:@"Partry"];
    [result setObject:[NSArray arrayWithObjects:[NSNumber numberWithInt:361],[NSNumber numberWithInt:146],[NSNumber numberWithInt:372],[NSNumber numberWithInt:198],@"Bluestacks",@"Ulster",@"MountainRange",nil] forKey:@"Bluestacks"];
    [result setObject:[NSArray arrayWithObjects:[NSNumber numberWithInt:134],[NSNumber numberWithInt:728],[NSNumber numberWithInt:126],[NSNumber numberWithInt:749],@"Macgillycuddyreeks",@"Ulster",@"MountainRange",nil] forKey:@"Macgillycuddyreeks"];
    [result setObject:[NSArray arrayWithObjects:[NSNumber numberWithInt:331],[NSNumber numberWithInt:575],[NSNumber numberWithInt:336],[NSNumber numberWithInt:545],@"Silvermines",@"Ulster",@"MountainRange",nil] forKey:@"Silvermines"];
    [result setObject:[NSArray arrayWithObjects:[NSNumber numberWithInt:245],[NSNumber numberWithInt:711],[NSNumber numberWithInt:261],[NSNumber numberWithInt:685],@"Boggeragh",@"Munster",@"MountainRange",nil] forKey:@"Boggeragh"];
    [result setObject:[NSArray arrayWithObjects:[NSNumber numberWithInt:150],[NSNumber numberWithInt:396],[NSNumber numberWithInt:169],[NSNumber numberWithInt:421],@"Maumturk",@"Ulster",@"MountainRange",nil] forKey:@"Maumturk"];
    [result setObject:[NSArray arrayWithObjects:[NSNumber numberWithInt:400],[NSNumber numberWithInt:496],[NSNumber numberWithInt:419],[NSNumber numberWithInt:463] ,@"Slievebloom",@"Leinster",@"MountainRange",nil] forKey:@"Slievebloom"];
    [result setObject:[NSArray arrayWithObjects:[NSNumber numberWithInt:402],[NSNumber numberWithInt:666],[NSNumber numberWithInt:431],[NSNumber numberWithInt:647],@"Comeragh",@"Munster",@"MountainRange",nil] forKey:@"Comeragh"];
    [result setObject:[NSArray arrayWithObjects:[NSNumber numberWithInt:585],[NSNumber numberWithInt:261],[NSNumber numberWithInt:604],[NSNumber numberWithInt:239],@"Mournes",@"Ulster",@"MountainRange",nil] forKey:@"Mournes"];
    [result setObject:[NSArray arrayWithObjects:[NSNumber numberWithInt:472],[NSNumber numberWithInt:114],[NSNumber numberWithInt:491],[NSNumber numberWithInt:168],@"Sperrins",@"Ulster",@"MountainRange",nil] forKey:@"Sperrins"];
    [result setObject:[NSArray arrayWithObjects:[NSNumber numberWithInt:199],[NSNumber numberWithInt:743],[NSNumber numberWithInt:187],[NSNumber numberWithInt:770],@"Derrynasaggart",@"Ulster",@"MountainRange",nil] forKey:@"Derrynasaggart"];
    [result setObject:[NSArray arrayWithObjects:[NSNumber numberWithInt:199],[NSNumber numberWithInt:656],[NSNumber numberWithInt:248],[NSNumber numberWithInt:626],@"Mullaghreirk",@"Ulster",@"MountainRange",nil] forKey:@"Mullaghreirk"];
    [result setObject:[NSArray arrayWithObjects:[NSNumber numberWithInt:551],[NSNumber numberWithInt:494],[NSNumber numberWithInt:547],[NSNumber numberWithInt:444],@"Wicklowmtns",@"Leinster",@"MountainRange",nil] forKey:@"Wicklowmtns"];
    [result setObject:[NSArray arrayWithObjects:[NSNumber numberWithInt:346],[NSNumber numberWithInt:88],[NSNumber numberWithInt:363],[NSNumber numberWithInt:60],@"Derryveagh",@"Ulster",@"MountainRange",nil] forKey:@"Derryveagh"];
    [result setObject:[NSArray arrayWithObjects:[NSNumber numberWithInt:155],[NSNumber numberWithInt:296],[NSNumber numberWithInt:179],[NSNumber numberWithInt:318],@"Nephinbeg",@"Connaught",@"MountainRange",nil] forKey:@"Nephinbeg"];
    return result;
    
    
    

}

-(NSDictionary *)headlandMarkers
{
    //Each entry consists of  0 image center x, 1 image center y, 2 label position , 3 label position y, 4 county name, 5 province name, 6 type = county
    
    NSMutableDictionary *result = [[NSMutableDictionary alloc] init];
    
    
    [result setObject:[NSArray arrayWithObjects:[NSNumber numberWithInt:108],[NSNumber numberWithInt:840],[NSNumber numberWithInt:108],[NSNumber numberWithInt:840],@"Mizen",@"Munster",@"Headland",nil] forKey:@"Mizen"];
    [result setObject:[NSArray arrayWithObjects:[NSNumber numberWithInt:164],[NSNumber numberWithInt:522],[NSNumber numberWithInt:164],[NSNumber numberWithInt:522],@"Hags",@"Munster",@"Headland",nil] forKey:@"Hags"];
    [result setObject:[NSArray arrayWithObjects:[NSNumber numberWithInt:93],[NSNumber numberWithInt:243],[NSNumber numberWithInt:93],[NSNumber numberWithInt:243],@"Erris",@"Connaught",@"Headland",nil] forKey:@"Erris"];
    [result setObject:[NSArray arrayWithObjects:[NSNumber numberWithInt:106],[NSNumber numberWithInt:602],[NSNumber numberWithInt:106],[NSNumber numberWithInt:602],@"Loop",@"Munster",@"Headland",nil] forKey:@"Loop"];
    [result setObject:[NSArray arrayWithObjects:[NSNumber numberWithInt:562],[NSNumber numberWithInt:682],[NSNumber numberWithInt:562],[NSNumber numberWithInt:682],@"Carnsore",@"Leinster",@"Headland",nil] forKey:@"Carnsore"];
    [result setObject:[NSArray arrayWithObjects:[NSNumber numberWithInt:273],[NSNumber numberWithInt:806],[NSNumber numberWithInt:273],[NSNumber numberWithInt:806],@"Kinsale",@"Munster",@"Headland",nil] forKey:@"Kinsale"];
    [result setObject:[NSArray arrayWithObjects:[NSNumber numberWithInt:499],[NSNumber numberWithInt:690], [NSNumber numberWithInt:515],[NSNumber numberWithInt:714],@"Hook",@"Leinster",@"Headland",nil] forKey:@"Hook"];
    [result setObject:[NSArray arrayWithObjects:[NSNumber numberWithInt:600],[NSNumber numberWithInt:432],[NSNumber numberWithInt:600],[NSNumber numberWithInt:422],@"Howth",@"Leinster",@"Headland",nil] forKey:@"Howth"];
    [result setObject:[NSArray arrayWithObjects:[NSNumber numberWithInt:434],[NSNumber numberWithInt:8],[NSNumber numberWithInt:434],[NSNumber numberWithInt:8],@"Malin",@"Ulster",@"Headland",nil] forKey:@"Malin"];
    return result;
}


-(NSDictionary *)islandMarkers
{
    //Each entry consists of  0 image center x, 1 image center y, 2 label position , 3 label position y, 4 county name, 5 province name, 6 type = county
    
    NSMutableDictionary *result = [[NSMutableDictionary alloc] init];
    
    [result setObject:[NSArray arrayWithObjects:[NSNumber numberWithInt:84],[NSNumber numberWithInt:305],[NSNumber numberWithInt:95],[NSNumber numberWithInt:311],@"Achill",@"Connaught",@"Island",nil] forKey:@"Achill"];
    [result setObject:[NSArray arrayWithObjects:[NSNumber numberWithInt:11],[NSNumber numberWithInt:701],[NSNumber numberWithInt:35],[NSNumber numberWithInt:690],@"Blaskets",@"Munster",@"Island",nil] forKey:@"Blaskets"];
    [result setObject:[NSArray arrayWithObjects:[NSNumber numberWithInt:101],[NSNumber numberWithInt:809],[NSNumber numberWithInt:121],[NSNumber numberWithInt:809],@"Bere",@"Munster",@"Island",nil] forKey:@"Bere"];
    [result setObject:[NSArray arrayWithObjects:[NSNumber numberWithInt:34],[NSNumber numberWithInt:741],[NSNumber numberWithInt:34],[NSNumber numberWithInt:750],@"Valentia",@"Munster",@"Island",nil] forKey:@"Valentia"];
    [result setObject:[NSArray arrayWithObjects:[NSNumber numberWithInt:567],[NSNumber numberWithInt:20],[NSNumber numberWithInt:583],[NSNumber numberWithInt:35],@"Rathlin",@"Ulster",@"Island",nil] forKey:@"Rathlin"];
    [result setObject:[NSArray arrayWithObjects:[NSNumber numberWithInt:132],[NSNumber numberWithInt:490], [NSNumber numberWithInt:126],[NSNumber numberWithInt:490],@"Aranislands",@"Connaught",@"Island",nil] forKey:@"Aranislands"];
    [result setObject:[NSArray arrayWithObjects:[NSNumber numberWithInt:284],[NSNumber numberWithInt:94], [NSNumber numberWithInt:290],[NSNumber numberWithInt:113],@"Aran",@"Ulster",@"Island",nil] forKey:@"Aran"];
    [result setObject:[NSArray arrayWithObjects:[NSNumber numberWithInt:310],[NSNumber numberWithInt:764], [NSNumber numberWithInt:332],[NSNumber numberWithInt:776],@"Great",@"Munster",@"Island",nil] forKey:@"Great"];
    return result;
    
}

-(NSDictionary *)riverMarkers
{
     //Each entry consists of  0 image center x, 1 image center y, 2 label position , 3 label position y, 4 county name, 5 province name, 6 type = county
    NSMutableDictionary *result = [[NSMutableDictionary alloc] init];

    [result setObject:[NSArray arrayWithObjects:[NSNumber numberWithInt:536],[NSNumber numberWithInt:148],[NSNumber numberWithInt:544],[NSNumber numberWithInt:105],@"Bann",@"Ulster",@"River",nil] forKey:@"Bann"];
    [result setObject:[NSArray arrayWithObjects:[NSNumber numberWithInt:397],[NSNumber numberWithInt:115],[NSNumber numberWithInt:349],[NSNumber numberWithInt:111],@"Finn",@"Ulster",@"River",nil] forKey:@"Finn"];
    [result setObject:[NSArray arrayWithObjects:[NSNumber numberWithInt:518],[NSNumber numberWithInt:394],[NSNumber numberWithInt:515],[NSNumber numberWithInt:402],@"Boyne",@"Leinster",@"River",nil] forKey:@"Boyne"];
    [result setObject:[NSArray arrayWithObjects:[NSNumber numberWithInt:263],[NSNumber numberWithInt:751],[NSNumber numberWithInt:258],[NSNumber numberWithInt:765],@"Lee",@"Munster",@"River",nil] forKey:@"Lee"];
    [result setObject:[NSArray arrayWithObjects:[NSNumber numberWithInt:221],[NSNumber numberWithInt:304],[NSNumber numberWithInt:245],[NSNumber numberWithInt:332],@"Moy",@"Connaught",@"River",nil] forKey:@"Moy"];
    [result setObject:[NSArray arrayWithObjects:[NSNumber numberWithInt:306],[NSNumber numberWithInt:427],[NSNumber numberWithInt:327],[NSNumber numberWithInt:317] ,@"Shannon",@"Connaught",@"River",nil] forKey:@"Shannon"];
    [result setObject:[NSArray arrayWithObjects:[NSNumber numberWithInt:371],[NSNumber numberWithInt:265],[NSNumber numberWithInt:435],[NSNumber numberWithInt:318],@"Erne",@"Ulster",@"River",nil] forKey:@"Erne"];
    [result setObject:[NSArray arrayWithObjects:[NSNumber numberWithInt:399],[NSNumber numberWithInt:244],[NSNumber numberWithInt:464],[NSNumber numberWithInt:278],@"Annalee",@"Ulster",@"River",nil] forKey:@"Annalee"];
    [result setObject:[NSArray arrayWithObjects:[NSNumber numberWithInt:140],[NSNumber numberWithInt:704],[NSNumber numberWithInt:154],[NSNumber numberWithInt:687] ,@"Laune",@"Munster",@"River",nil] forKey:@"Laune"];
    [result setObject:[NSArray arrayWithObjects:[NSNumber numberWithInt:420],[NSNumber numberWithInt:625],[NSNumber numberWithInt:410],[NSNumber numberWithInt:668],@"Suir",@"Leinster",@"River",nil] forKey:@"Suir"];
    [result setObject:[NSArray arrayWithObjects:[NSNumber numberWithInt:531],[NSNumber numberWithInt:593],[NSNumber numberWithInt:548],[NSNumber numberWithInt:638] ,@"Slaney",@"Leinster",@"River",nil] forKey:@"Slaney"];
    [result setObject:[NSArray arrayWithObjects:[NSNumber numberWithInt:448],[NSNumber numberWithInt:597],[NSNumber numberWithInt:410],[NSNumber numberWithInt:543],@"Nore",@"Leinster",@"River",nil] forKey:@"Nore"];
    [result setObject:[NSArray arrayWithObjects:[NSNumber numberWithInt:301],[NSNumber numberWithInt:711],[NSNumber numberWithInt:293],[NSNumber numberWithInt:706],@"Blackwatermunster",@"Munster",@"River",nil] forKey:@"Blackwatermunster"];
    [result setObject:[NSArray arrayWithObjects:[NSNumber numberWithInt:477],[NSNumber numberWithInt:213],[NSNumber numberWithInt:502],[NSNumber numberWithInt:206],@"Blackwaterulster",@"Ulster",@"River",nil] forKey:@"Blackwaterulster"];
    [result setObject:[NSArray arrayWithObjects:[NSNumber numberWithInt:585],[NSNumber numberWithInt:193],[NSNumber numberWithInt:590],[NSNumber numberWithInt:208],@"Lagan",@"Ulster",@"River",nil] forKey:@"Lagan"];
    [result setObject:[NSArray arrayWithObjects:[NSNumber numberWithInt:289],[NSNumber numberWithInt:471],[NSNumber numberWithInt:304],[NSNumber numberWithInt:433],@"Suck",@"Connaught",@"River",nil] forKey:@"Suck"];
    [result setObject:[NSArray arrayWithObjects:[NSNumber numberWithInt:519],[NSNumber numberWithInt:361],[NSNumber numberWithInt:514],[NSNumber numberWithInt:342] ,@"Blackwaterleinster",@"Leinster",@"River",nil] forKey:@"Blackwaterleinster"];
    [result setObject:[NSArray arrayWithObjects:[NSNumber numberWithInt:435],[NSNumber numberWithInt:129],[NSNumber numberWithInt:444],[NSNumber numberWithInt:166] ,@"Foyleriver",@"Ulster",@"River",nil] forKey:@"Foyleriver"];
    [result setObject:[NSArray arrayWithObjects:[NSNumber numberWithInt:326],[NSNumber numberWithInt:469],[NSNumber numberWithInt:412],[NSNumber numberWithInt:394],@"Inny",@"Connaught",@"River",nil] forKey:@"Inny"];
    [result setObject:[NSArray arrayWithObjects:[NSNumber numberWithInt: 534],[NSNumber numberWithInt:460],[NSNumber numberWithInt:578],[NSNumber numberWithInt:460],@"Liffey",@"Leinster",@"River",nil] forKey:@"Liffey"];
    [result setObject:[NSArray arrayWithObjects:[NSNumber numberWithInt:474],[NSNumber numberWithInt:576],[NSNumber numberWithInt:497],[NSNumber numberWithInt:526],@"Barrow",@"Leinster",@"River",nil] forKey:@"Barrow"];
    return result;
    
}





-(NSDictionary *)lakeMarkers
{
    
    //Each entry consists of  0 image center x, 1 image center y, 2 label position , 3 label position y, 4 county name, 5 province name, 6 type = county
    NSMutableDictionary *result = [[NSMutableDictionary alloc] init];

    [result setObject:[NSArray arrayWithObjects:[NSNumber numberWithInt:374],[NSNumber numberWithInt:216],[NSNumber numberWithInt:374],[NSNumber numberWithInt:216],@"Lowererne",@"Ulster",@"Lake",nil] forKey:@"Lowererne"];
    [result setObject:[NSArray arrayWithObjects:[NSNumber numberWithInt:411],[NSNumber numberWithInt:256],[NSNumber numberWithInt:439],[NSNumber numberWithInt:243],@"Uppererne",@"Ulster",@"Lake",nil] forKey:@"Uppererne"];
    [result setObject:[NSArray arrayWithObjects:[NSNumber numberWithInt:647],[NSNumber numberWithInt:194],[NSNumber numberWithInt:668],[NSNumber numberWithInt:227],@"Bangor",@"Ulster",@"Lake",nil] forKey:@"Bangor"];
    [result setObject:[NSArray arrayWithObjects:[NSNumber numberWithInt:629],[NSNumber numberWithInt:146],[NSNumber numberWithInt:644],[NSNumber numberWithInt:124],@"Belfast",@"Ulster",@"Lake", nil] forKey:@"Belfast"];
    [result setObject:[NSArray arrayWithObjects:[NSNumber numberWithInt:584],[NSNumber numberWithInt:286],[NSNumber numberWithInt:584],[NSNumber numberWithInt:286],@"Carlingford",@"Ulster",@"Lake",nil] forKey:@"Carlingford"];
    [result setObject:[NSArray arrayWithObjects:[NSNumber numberWithInt:403],[NSNumber numberWithInt:56],[NSNumber numberWithInt:411],[NSNumber numberWithInt:14],@"Swilly",@"Ulster",@"Lake",nil] forKey:@"Swilly"];
    [result setObject:[NSArray arrayWithObjects:[NSNumber numberWithInt:198],[NSNumber numberWithInt:420],[NSNumber numberWithInt:209],[NSNumber numberWithInt:429],@"Corrib",@"Connaught",@"Lake",nil] forKey:@"Corrib"];
    [result setObject:[NSArray arrayWithObjects:[NSNumber numberWithInt:209],[NSNumber numberWithInt:298],[NSNumber numberWithInt:209],[NSNumber numberWithInt:298],@"Conn",@"Connaught",@"Lake",nil] forKey:@"Conn"];
    [result setObject:[NSArray arrayWithObjects:[NSNumber numberWithInt:188],[NSNumber numberWithInt:374],[NSNumber numberWithInt:188],[NSNumber numberWithInt:374],@"Mask",@"Connaught",@"Lake",nil] forKey:@"Mask"];
    [result setObject:[NSArray arrayWithObjects:[NSNumber numberWithInt:341],[NSNumber numberWithInt:277],[NSNumber numberWithInt:341],[NSNumber numberWithInt:277],@"Allen",@"Connaught",@"Lake",nil] forKey:@"Allen"];
    [result setObject:[NSArray arrayWithObjects:[NSNumber numberWithInt:310],[NSNumber numberWithInt:519],[NSNumber numberWithInt:310],[NSNumber numberWithInt:519],@"Derg",@"Connaught",@"Lake",nil] forKey:@"Derg"];
    [result setObject:[NSArray arrayWithObjects:[NSNumber numberWithInt:547],[NSNumber numberWithInt:165],[NSNumber numberWithInt:547],[NSNumber numberWithInt:165],@"Neagh",@"Ulster",@"Lake",nil] forKey:@"Neagh"];
    [result setObject:[NSArray arrayWithObjects:[NSNumber numberWithInt:459],[NSNumber numberWithInt:58],[NSNumber numberWithInt:479],[NSNumber numberWithInt:38],@"Foyle",@"Ulster",@"Lake",nil] forKey:@"Foyle"];
    [result setObject:[NSArray arrayWithObjects:[NSNumber numberWithInt:359],[NSNumber numberWithInt:394], [NSNumber numberWithInt:361],[NSNumber numberWithInt:410],@"Ree",@"Connaught",@"Lake",nil] forKey:@"Ree"];
    
    
    return result;
}


#pragma mark actions
-(void)incrementQuizScore
{
    int newScore = [self.quizScore intValue] + 1;
    self.quizScore = [NSNumber numberWithInt:newScore];
}
-(NSMutableArray *)getListOfTargets
{
    NSMutableArray *result = [[NSMutableArray alloc] init];
    
    if ([self.mapSections isEqualToString:@"Counties"]) {
        [result addObjectsFromArray:self.countyNames];
    }
    
    if ([self.mapSections isEqualToString:@"MountainsIslands"]) {
        [result addObjectsFromArray:self.mountainNames];
        [result addObjectsFromArray:self.islandNames];
        [result addObjectsFromArray:self.headlandNames];
        
    }
    
    if ([self.mapSections isEqualToString:@"RiversLakes"]) {
        [result addObjectsFromArray:self.riverNames];
        [result addObjectsFromArray:self.lakeNames];
    }
    
    return result;
}
-(void) getNextTarget
{
    //pick a random county from those that have not yet been placed
    int x = (arc4random() % [self.unPlacedTargets count]);
    self.targetName = [self.unPlacedTargets objectAtIndex:x];
}


-(NSArray *)getQuestionFromCategory:(NSString *)category
{
    NSMutableDictionary *section = [self getDicionaryForType:category];
    NSMutableDictionary *resultHeader = [[NSMutableDictionary alloc] init];
    int x = (arc4random() % [section count]);
    NSString *key = [[section allKeys] objectAtIndex:x];
    [resultHeader setObject:[section objectForKey:key] forKey:key];
    [section removeObjectForKey:key];
    
    NSArray *result = [NSArray arrayWithObjects:resultHeader, section, nil];
    return result;
}

-(NSArray *)getThreeCategoryQuestionsForCategory:(NSString *)category
{
    NSMutableDictionary *section = [self getDicionaryForType:category];
    NSMutableDictionary *resultHeader = [[NSMutableDictionary alloc] init];
    
    for (int i = 0; i < 3; i++) {
        int x = (arc4random() % [section count]);
        NSString *key = [[section allKeys] objectAtIndex:x];
        [resultHeader setObject:[section objectForKey:key] forKey:key];
        [section removeObjectForKey:key];
    }
    NSArray *result = [NSArray arrayWithObjects:resultHeader, section, nil];
    return result;
}

-(NSArray *)getNextQuestion
{
    NSArray *result = [NSArray arrayWithObject:@"Complete"]; //let the caller know if we are finished
    if ([self.allQuestions count] > 0) {
     
        NSString *questionTarget = [[self.allQuestions allKeys] objectAtIndex:0];
        NSArray *question =  [self.allQuestions objectForKey:questionTarget];
        [self.allQuestions removeObjectForKey:questionTarget]; 
        //add 1 to the num Questions Asked
        int newNumQuestionsAsked = [self.numAskedQuestions intValue] + 1;
        self.numAskedQuestions = [NSNumber numberWithInt:newNumQuestionsAsked];
        
        return question;
    }
    return  result;
}

-(NSMutableDictionary *)getListOfQuestions
{
    // self.quizCategories is: the categories followed by number of questions
    int numQuestions = [[self.quizCategories lastObject] intValue];
    NSMutableDictionary *allCategories = [[NSMutableDictionary alloc] init];
    NSMutableDictionary *result = [[NSMutableDictionary alloc] init];
    if (numQuestions == 20)
    {
        if ([self.quizCategories containsObject:@"Counties"])
        {
            NSArray *questions = [self getThreeCategoryQuestionsForCategory:@"County"];
            [result addEntriesFromDictionary:[questions objectAtIndex:0]];
            [allCategories addEntriesFromDictionary:[questions objectAtIndex:1]];
        }
        if ([self.quizCategories containsObject:@"Rivers"])
        {
            NSArray *questions = [self getThreeCategoryQuestionsForCategory:@"River"];
            [result addEntriesFromDictionary:[questions objectAtIndex:0]];
            [allCategories addEntriesFromDictionary:[questions objectAtIndex:1]]; }
        if ([self.quizCategories containsObject:@"Mountains"])
        {
            NSArray *questions = [self getThreeCategoryQuestionsForCategory:@"MountainRange"];
            [result addEntriesFromDictionary:[questions objectAtIndex:0]];
            [allCategories addEntriesFromDictionary:[questions objectAtIndex:1]];
        }
        if ([self.quizCategories containsObject:@"Islands"])
        {
            NSArray *questions = [self getThreeCategoryQuestionsForCategory:@"Island"];
            [result addEntriesFromDictionary:[questions objectAtIndex:0]];
            [allCategories addEntriesFromDictionary:[questions objectAtIndex:1]];
        }
        if ([self.quizCategories containsObject:@"Lakes"])
        {
            NSArray *questions = [self getThreeCategoryQuestionsForCategory:@"Lake"];
            [result addEntriesFromDictionary:[questions objectAtIndex:0]];
            [allCategories addEntriesFromDictionary:[questions objectAtIndex:1]];
        }
        if ([self.quizCategories containsObject:@"Headlands"])
        {
            NSArray *questions = [self getThreeCategoryQuestionsForCategory:@"Headland"];
            [result addEntriesFromDictionary:[questions objectAtIndex:0]];
            [allCategories addEntriesFromDictionary:[questions objectAtIndex:1]];
        }
    }
    else
    {
        if ([self.quizCategories containsObject:@"Counties"])
        {
            NSArray *questions = [self getQuestionFromCategory:@"County"];
            [result addEntriesFromDictionary:[questions objectAtIndex:0]];
            [allCategories addEntriesFromDictionary:[questions objectAtIndex:1]];
        }
        if ([self.quizCategories containsObject:@"Rivers"])
        {
            NSArray *questions = [self getQuestionFromCategory:@"River"];
            [result addEntriesFromDictionary:[questions objectAtIndex:0]];
            [allCategories addEntriesFromDictionary:[questions objectAtIndex:1]]; }
        if ([self.quizCategories containsObject:@"Mountains"])
        {
            NSArray *questions = [self getQuestionFromCategory:@"MountainRange"];
            [result addEntriesFromDictionary:[questions objectAtIndex:0]];
            [allCategories addEntriesFromDictionary:[questions objectAtIndex:1]];
        }
        if ([self.quizCategories containsObject:@"Islands"])
        {
            NSArray *questions = [self getQuestionFromCategory:@"Island"];
            [result addEntriesFromDictionary:[questions objectAtIndex:0]];
            [allCategories addEntriesFromDictionary:[questions objectAtIndex:1]];
        }
        if ([self.quizCategories containsObject:@"Lakes"])
        {
            NSArray *questions = [self getQuestionFromCategory:@"Lake"];
            [result addEntriesFromDictionary:[questions objectAtIndex:0]];
            [allCategories addEntriesFromDictionary:[questions objectAtIndex:1]];
        }
        if ([self.quizCategories containsObject:@"Headlands"])
        {
            NSArray *questions = [self getQuestionFromCategory:@"Headland"];
            [result addEntriesFromDictionary:[questions objectAtIndex:0]];
            [allCategories addEntriesFromDictionary:[questions objectAtIndex:1]];
        }
    }
    int loopCount = (numQuestions - [result count]);
    for (int i = 0; i < loopCount; i++)
    {
        int x = (arc4random() % [allCategories count]);
        NSString *key = [[allCategories allKeys] objectAtIndex:x];
        [result setObject:[allCategories objectForKey:key] forKey:key];
        [allCategories removeObjectForKey:key];
    }

    return result;
}
-(NSArray *)answersForQuestion:(NSArray *)question
{
    NSMutableArray *result = [[NSMutableArray alloc] init];
    NSString *answerToExclude = [question objectAtIndex:4];
    NSString *type = [question lastObject];
    NSMutableDictionary *allAnswers = [self getDicionaryForType:type];
    [allAnswers removeObjectForKey:answerToExclude];
    for (int i = 0 ; i < 3; i++) {
       int x = (arc4random() % [allAnswers count]);
        NSString *key = [[allAnswers allKeys] objectAtIndex:x];
        [result addObject:[allAnswers objectForKey:key]];
        [allAnswers removeObjectForKey:key];
    }
    return result;
    
}

-(NSMutableDictionary *)getDicionaryForType:(NSString *)type
{
    NSMutableDictionary *result;
    if ([type isEqualToString:@"County"]) result = [self.countyMarkers mutableCopy];
    if ([type isEqualToString:@"River"]) result = [self.riverMarkers mutableCopy];
    if ([type isEqualToString:@"MountainRange"]) result = [self.mountainMarkers mutableCopy];
    if ([type isEqualToString:@"Island"]) result = [self.islandMarkers mutableCopy];
    if ([type isEqualToString:@"Headland"]) result = [self.headlandMarkers mutableCopy];
    if ([type isEqualToString:@"Lake"]) result = [self.lakeMarkers mutableCopy];
    return result;
}


#pragma mark tokencheckinglogic

-(BOOL) isMapComplete
{
    BOOL result = YES;
    if ([self.unPlacedTargets count] > 0) result = NO;
    return result;
}

-(BOOL)isQuizComplete
{
    BOOL result = YES;
    if ([self.allQuestions count]> 0) result = NO;
    return result;
}

@end
