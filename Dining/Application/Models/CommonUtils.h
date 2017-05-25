//  CommonUtils.h
//  Created by BE

#import <Foundation/Foundation.h>

@interface CommonUtils : NSObject {
    UIActivityIndicatorView *activityIndicator;
}

@property (nonatomic, strong) NSMutableDictionary *dicAlertContent;

+ (instancetype)shared;


- (void)showAlert:(NSString *)title withMessage:(NSString *)message;
- (void)showVAlertSimple:(NSString *)title body:(NSString *)body duration:(float)duration;

- (void)removeAllSubViews:(UIView *) view;
- (void)setScrollViewOffsetBottom:(UIScrollView *) view;

- (BOOL)checkKeyInDic:(NSString *)key inDic:(NSMutableDictionary *)dic;
- (NSString *)getValueByIdFromArray:(NSMutableArray *)arr idKeyFormat:(NSString *)keyIdStr valKeyFormat:(NSString *)keyValStr idValue:(NSString *)idStr;
- (NSMutableArray *) getContentArrayFromIdsString:(NSString *)idsString withSeparator:(NSString *)separator withContentSource:(NSMutableArray *)sourceArray;

- (NSString *)getUserDefault:(NSString *)key;
- (void)setUserDefault:(NSString *)key withFormat:(NSString *)val;
- (void)removeUserDefault:(NSString *)key;

- (NSMutableDictionary *)getUserDefaultDicByKey:(NSString *)key;
- (void)setUserDefaultDic:(NSString *)key withDic:(NSMutableDictionary *)dic;
- (void)removeUserDefaultDic:(NSString *)key;

- (NSString *)getBlankString:(NSString *)str;

- (void) cropCircleImage:(UIImageView *)imageView;
- (void) setCircleBorderImage:(UIImageView *)imageView withBorderWidth:(float)width withBorderColor:(UIColor *)color;
- (void) setRoundedRectBorderImage:(UIImageView *)imageView withBorderWidth:(float)width withBorderColor:(UIColor *)color withBorderRadius:(float)radius;

- (void) cropCircleButton:(UIButton *)button;
- (void) setCircleBorderButton:(UIButton *)button withBorderWidth:(float) borderWidth withBorderColor:(UIColor *) color;
- (void) setRoundedRectBorderButton:(UIButton *)button withBorderWidth:(float)width withBorderColor:(UIColor *)color withBorderRadius:(float)radius;
- (void) setRoundedRectView:(UIView *)view withCornerRadius:(float)radius;

- (void) setImageViewAFNetworking:(UIImageView *)imageView withImageUrl:(NSString *)imageUrl withPlaceholderImage:(UIImage *)placeholder;
- (void) setButtonImageAFNetworking:(UIButton *)button withImageUrl:(NSString *)imageUrl withPlaceholderImage:(UIImage *)placeholder;
- (void) setButtonMultiLineText:(UIButton *)button;

- (void) setTextFieldBorder:(UITextField *)textField withColor:(UIColor *)color withBorderWidth:(float)width withCornerRadius:(float)radius;
- (void) setTextFieldMargin:(UITextField *)textField valX:(float)x valY:(float)y valW:(float)w valH:(float)h;
- (void) setTextViewBorder:(UITextView *)textView withColor:(UIColor *)color withBorderWidth:(float)width withCornerRadius:(float)radius;
- (void) setTextViewMargin:(UITextView *)textView valX:(float)x valY:(float)y valW:(float)w valH:(float)h;

- (NSString *) getFullPhotoUrl:(NSString *)url withType:(NSString *)type;
- (NSMutableArray *) getPointsFromString:(NSString *)str;

- (BOOL) checkStringNumeric:(NSString *) str;
- (NSString *) removeSpaceFromString:(NSString *) str;
- (NSString *) removeCharactersFromString:(NSString *)str withFormat:(NSArray *) arr;
- (NSString *) trimString:(NSString *)str;

- (NSString *) getCombinedTextByComma:(NSMutableArray *)arr;

- (CGFloat)getHeightForTextContent:(NSString *)text withWidth:(CGFloat)width withFontSize:(CGFloat)fontSize;

- (NSString *) md5:(NSString *) input;
- (BOOL)isFormEmpty:(NSMutableArray *)array;
- (void)setFormDic:(NSMutableArray *)array toDic:(NSMutableDictionary *)formDic;
- (BOOL)validateEmail:(NSString *)emailStr;
- (NSArray *)getSortedArray:(NSArray *)array;

- (BOOL)isEmptyString:(NSString *)str;

- (NSString *)getParamStr:(NSMutableDictionary *) dic;
- (UIImage *) getImageFromDic: (NSMutableDictionary *) dic;
- (NSMutableDictionary *)getDictionaryById:(NSMutableArray *)array withIdKey:(NSString *)idField withIdValue:(NSString *)idValue;

- (NSDate *)convertStringToDate:(NSString *)dateStr withFormat:(NSString *)formatStr;
- (NSString *)convertDateToString:(NSDate *)date withFormat:(NSString *)formatStr;
- (BOOL)isToday:(NSDate *)date;

- (UIImage *)cropImage:(UIImage *)image scaledToSize:(CGSize)newSize;
- (NSString *)getContentTypeForImageData:(NSData *)data;
- (NSString*)base64forData:(NSData*)theData;

- (NSString *)encodeToBase64String:(UIImage *)image byCompressionRatio:(float)compressionRatio;
- (NSString *)encodeMediaPathToBase64String:(NSString *)mediaPath;
- (UIImage *)decodeBase64ToImage:(NSString *)strEncodeData;
- (NSString *)getJsonStringFromDic:(NSMutableDictionary *)array;

- (void)showActivityIndicator:(UIView *)inView;
- (void)showActivityIndicatorColored:(UIView *)inView;
- (void)hideActivityIndicator;

// Custom Functions
- (void)customizeTabBar:(UIViewController *)view;
- (NSString *)getTimeDiffString:(NSString *)timeDiffStr;
- (NSString *)getCountNumberString:(NSString *)countNumberStr;
- (void)setFollowButton:(UIButton *)button withState:(BOOL)state;
- (NSMutableArray *)updatePostWithinArray:(NSMutableArray *)postsArray byPost:(NSMutableDictionary *)postDic;
- (NSMutableArray *)updateUserWithinArray:(NSMutableArray *)usersArray byUser:(NSMutableDictionary *)userDic;

//+ (id) httpCommonRequest:(NSString *) urlStr;
- (id) httpJsonRequest:(NSString *) urlStr withJSON:(NSMutableDictionary *)params;


@end