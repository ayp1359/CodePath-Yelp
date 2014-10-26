//
//  Categories.m
//  Yelp
//
//  Created by Ali YAZDAN PANAH on 10/24/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

#import "Categories.h"

@interface Categories ()
@property (strong, nonatomic) NSArray* const categories;
@property (strong, nonatomic) NSMutableSet* selectedCategories;
@end

@implementation Categories

- (id)init
{
  self = [super init];
  if (self) {
    self.selectedCategories = [[NSMutableSet alloc] init];
    //Manuallly setting up categories from Yelp API:
    self.categories = @[@[@"afghani",@"Afghan"],
                        @[@"african",@"African"],
                        @[@"senegalese",@"Senegalese"],
                        @[@"southafrican",@"South African"],
                        @[@"newamerican",@"American (New)"],
                        @[@"tradamerican",@"American (Traditional)"],
                        @[@"arabian",@"Arabian"],
                        @[@"argentine",@"Argentine"],
                        @[@"armenian",@"Armenian"],
                        @[@"asianfusion",@"Asian Fusion"],
                        @[@"australian",@"Australian"],
                        @[@"austrian",@"Austrian"],
                        @[@"bangladeshi",@"Bangladeshi"],
                        @[@"bbq",@"Barbeque"],
                        @[@"basque",@"Basque"],
                        @[@"belgian",@"Belgian"],
                        @[@"brasseries",@"Brasseries"],
                        @[@"brazilian",@"Brazilian"],
                        @[@"breakfast_brunch",@"Breakfast & Brunch"],
                        @[@"british",@"British"],
                        @[@"buffets",@"Buffets"],
                        @[@"burgers",@"Burgers"],
                        @[@"burmese",@"Burmese"],
                        @[@"cafes",@"Cafes"],
                        @[@"cafeteria",@"Cafeteria"],
                        @[@"cajun",@"Cajun/Creole"],
                        @[@"cambodian",@"Cambodian"],
                        @[@"caribbean",@"Caribbean"],
                        @[@"dominican",@"Dominican"],
                        @[@"haitian",@"Haitian"],
                        @[@"puertorican",@"Puerto Rican"],
                        @[@"trinidadian",@"Trinidadian"],
                        @[@"catalan",@"Catalan"],
                        @[@"cheesesteaks",@"Cheesesteaks"],
                        @[@"chicken_wings",@"Chicken Wings"],
                        @[@"chinese",@"Chinese"],
                        @[@"cantonese",@"Cantonese"],
                        @[@"dimsum",@"Dim Sum"],
                        @[@"shanghainese",@"Shanghainese"],
                        @[@"szechuan",@"Szechuan"],
                        @[@"comfortfood",@"Comfort Food"],
                        @[@"creperies",@"Creperies"],
                        @[@"cuban",@"Cuban"],
                        @[@"czech",@"Czech"],
                        @[@"delis",@"Delis"],
                        @[@"diners",@"Diners"],
                        @[@"ethiopian",@"Ethiopian"],
                        @[@"hotdogs",@"Fast Food"],
                        @[@"filipino",@"Filipino"],
                        @[@"fishnchips",@"Fish & Chips"],
                        @[@"fondue",@"Fondue"],
                        @[@"food_court",@"Food Court"],
                        @[@"foodstands",@"Food Stands"],
                        @[@"french",@"French"],
                        @[@"gastropubs",@"Gastropubs"],
                        @[@"german",@"German"],
                        @[@"gluten_free",@"Gluten-Free"],
                        @[@"greek",@"Greek"],
                        @[@"halal",@"Halal"],
                        @[@"hawaiian",@"Hawaiian"],
                        @[@"himalayan",@"Himalayan/Nepalese"],
                        @[@"hotdog",@"Hot Dogs"],
                        @[@"hotpot",@"Hot Pot"],
                        @[@"hungarian",@"Hungarian"],
                        @[@"iberian",@"Iberian"],
                        @[@"indpak",@"Indian"],
                        @[@"indonesian",@"Indonesian"],
                        @[@"irish",@"Irish"],
                        @[@"italian",@"Italian"],
                        @[@"japanese",@"Japanese"],
                        @[@"korean",@"Korean"],
                        @[@"kosher",@"Kosher"],
                        @[@"laotian",@"Laotian"],
                        @[@"latin",@"Latin American"],
                        @[@"colombian",@"Colombian"],
                        @[@"salvadoran",@"Salvadoran"],
                        @[@"venezuelan",@"Venezuelan"],
                        @[@"raw_food",@"Live/Raw Food"],
                        @[@"malaysian",@"Malaysian"],
                        @[@"mediterranean",@"Mediterranean"],
                        @[@"falafel",@"Falafel"],
                        @[@"mexican",@"Mexican"],
                        @[@"mideastern",@"Middle Eastern"],
                        @[@"egyptian",@"Egyptian"],
                        @[@"lebanese",@"Lebanese"],
                        @[@"modern_european",@"Modern European"],
                        @[@"mongolian",@"Mongolian"],
                        @[@"moroccan",@"Moroccan"],
                        @[@"pakistani",@"Pakistani"],
                        @[@"persian",@"Persian/Iranian"],
                        @[@"peruvian",@"Peruvian"],
                        @[@"pizza",@"Pizza"],
                        @[@"polish",@"Polish"],
                        @[@"portuguese",@"Portuguese"],
                        @[@"russian",@"Russian"],
                        @[@"salad",@"Salad"],
                        @[@"sandwiches",@"Sandwiches"],
                        @[@"scandinavian",@"Scandinavian"],
                        @[@"scottish",@"Scottish"],
                        @[@"seafood",@"Seafood"],
                        @[@"singaporean",@"Singaporean"],
                        @[@"slovakian",@"Slovakian"],
                        @[@"soulfood",@"Soul Food"],
                        @[@"soup",@"Soup"],
                        @[@"southern",@"Southern"],
                        @[@"spanish",@"Spanish"],
                        @[@"steak",@"Steakhouses"],
                        @[@"sushi",@"Sushi Bars"],
                        @[@"taiwanese",@"Taiwanese"],
                        @[@"tapas",@"Tapas Bars"],
                        @[@"tapasmallplates",@"Tapas/Small Plates"],
                        @[@"tex-mex",@"Tex-Mex"],
                        @[@"thai",@"Thai"],
                        @[@"turkish",@"Turkish"],
                        @[@"ukrainian",@"Ukrainian"],
                        @[@"vegan",@"Vegan"],
                        @[@"vegetarian",@"Vegetarian"],
                        @[@"vietnamese",@"Vietnamese"]
                        ];
  }
  return self;
}

- (NSString*) getParams
{
  return [[self.selectedCategories allObjects] componentsJoinedByString:@","];
}

- (void) selectCategoryAtIndex:(NSInteger)index selected:(BOOL)selected;
{
  if (selected) {
    [self.selectedCategories addObject:(self.categories[index][0])];
  } else {
    [self.selectedCategories removeObject:(self.categories[index][0])];
  }
}

- (BOOL) isCategorySelectedAtIndex:(NSInteger)index
{
  return [self.selectedCategories containsObject:(self.categories[index][0])];
}

- (id) initWithParams: (NSString*) params
{
  self = [self init];
  if (self) {
    self.selectedCategories = [NSMutableSet setWithArray:[params componentsSeparatedByString:@","]];
  }
  return self;
}

- (NSString*) categoryAtIndex:(NSInteger)index
{
  return self.categories[index][1];
}

- (NSInteger) getCount
{
  return self.categories.count;
}

@end
