//
//  UIImage+UISegmentIconAndText.m
//  BirdCage
//
//  Created by Brendan Zhou on 19/04/2015.
//  Copyright (c) 2015 Bizar Mobile Pty Ltd. All rights reserved.
//

#import "UIImage+UISegmentIconAndText.h"

@implementation UIImage (UISegmentIconAndText)

+ (id) imageFromImage:(UIImage*)image string:(NSString*)string color:(UIColor*)color
{
    UIFont *font = [UIFont systemFontOfSize:16.0];
    CGSize expectedTextSize = [string sizeWithAttributes:@{NSFontAttributeName: font}];
    int width = expectedTextSize.width + image.size.width + 5;
    int height = MAX(expectedTextSize.height, image.size.width);
    CGSize size = CGSizeMake((float)width, (float)height);
    UIGraphicsBeginImageContextWithOptions(size, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, color.CGColor);
    int fontTopPosition = (height - expectedTextSize.height) / 2;
    CGPoint textPoint = CGPointMake(image.size.width + 5, fontTopPosition);
    
    [string drawAtPoint:textPoint withAttributes:@{NSFontAttributeName: font}];
    // Images upside down so flip them
    CGAffineTransform flipVertical = CGAffineTransformMake(1, 0, 0, -1, 0, size.height);
    CGContextConcatCTM(context, flipVertical);
    CGContextDrawImage(context, (CGRect){ {0, (height - image.size.height) / 2}, {image.size.width, image.size.height} }, [image CGImage]);
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

+ (id)imageFromImage:(UIImage*)image
           imageSize:(CGSize) imageSize
              string:(NSString*)string
      fontAttributes:(NSDictionary*) fontAttributes
shouldKeepOriginalTextSize:(BOOL) useOriginalTextSize;
{
    CGSize expectedTextSize = [string sizeWithAttributes:fontAttributes];
    
    CGSize size = expectedTextSize;
    NSUInteger fontTopPosition = (imageSize.height - expectedTextSize.height) / 2;
    NSUInteger heightToUse = expectedTextSize.height;
    
    int width = expectedTextSize.width + imageSize.width + 5;
    
    if (!useOriginalTextSize) {
        heightToUse = MAX(expectedTextSize.height, imageSize.width);
        size = CGSizeMake((float)width, (float)heightToUse);
        fontTopPosition = (heightToUse - expectedTextSize.height) / 2;
    }
    
    UIGraphicsBeginImageContextWithOptions(size, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //    UIColor *color = [fontAttributes valueForKey:NSForegroundColorAttributeName];
    UIColor *color = [UIColor blackColor];
    CGContextSetFillColorWithColor(context, color.CGColor);
    
    
    CGPoint textPoint = CGPointMake(imageSize.width + 2, fontTopPosition);
    
    [string drawAtPoint:textPoint withAttributes:fontAttributes];
    // Images upside down so flip them
    CGAffineTransform flipVertical = CGAffineTransformMake(1, 0, 0, -1, 0, size.height);
    CGAffineTransform scale = CGAffineTransformMakeScale(imageSize.width / image.size.width , imageSize.height / image.size.height);
    CGContextConcatCTM(context, flipVertical);
    CGContextConcatCTM(context, scale);
    
    CGContextDrawImage(context, (CGRect){ { 0, (heightToUse - imageSize.height) / 2 }, { imageSize.width, imageSize.height } }, [image CGImage]);
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}
@end
