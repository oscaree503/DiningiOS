//
//  UIImage+UISegmentIconAndText.h
//  BirdCage
//
//  Created by Brendan Zhou on 19/04/2015.
//  Copyright (c) 2015 Bizar Mobile Pty Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIImage (UISegmentIconAndText)

+ (id) imageFromImage:(UIImage*)image string:(NSString*)string color:(UIColor*)color;

+ (id)imageFromImage:(UIImage*)image
           imageSize:(CGSize) imageSize
              string:(NSString*)string
      fontAttributes:(NSDictionary*) fontAttributes
shouldKeepOriginalTextSize:(BOOL) useOriginalTextSize;

@end
