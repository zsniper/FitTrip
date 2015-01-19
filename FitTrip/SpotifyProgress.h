//
//  SpotifyProgress.h
//  WeatherHack2
//
//  Created by zkmb on 2015-01-18.
//  Copyright (c) 2015 zkmb. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SpotifyProgress : UIView

@property BOOL animating;

- (id)initWithFrame:(CGRect)frame
  withPointDiameter:(int)diameter
       withInterval:(float)interval;
@end