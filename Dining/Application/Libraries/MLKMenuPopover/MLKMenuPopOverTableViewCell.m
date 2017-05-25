//
//  MLKMenuPopOverTableViewCell.m
//  Tatshare
//
//  Created by Mac on 11/6/15.
//  Copyright (c) 2015 Silver. All rights reserved.
//

#import "MLKMenuPopOverTableViewCell.h"

#define CELL_WIDTH 320.0f
#define IMAGEVIEW_WIDTH 24.0f
@implementation MLKMenuPopOverTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@synthesize contentLabel, userPicImageView;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(IMAGEVIEW_WIDTH, 0, CELL_WIDTH - IMAGEVIEW_WIDTH, IMAGEVIEW_WIDTH)];
        contentLabel.textColor = [UIColor blackColor];
        contentLabel.font = [UIFont systemFontOfSize:10.0f];

        contentLabel.clipsToBounds = YES;
        contentLabel.shadowColor = [UIColor whiteColor];
        contentLabel.shadowOffset = CGSizeZero;
        contentLabel.opaque = YES;
        contentLabel.backgroundColor = [UIColor clearColor];
        
        [self addSubview:contentLabel];
        
        userPicImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, IMAGEVIEW_WIDTH, IMAGEVIEW_WIDTH)];
        [self addSubview:userPicImageView];
    }
    return self;
}

@end
