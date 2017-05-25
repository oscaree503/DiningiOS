//
//  MLKMenuPopover.m
//  MLKMenuPopover
//
//  Created by NagaMalleswar on 20/11/14.
//  Copyright (c) 2014 NagaMalleswar. All rights reserved.
//

#import "MLKMenuPopover.h"
#import "MLKMenuPopOverTableViewCell.h"
#import <QuartzCore/QuartzCore.h>



#define FONT_SIZE                       12
#define CELL_IDENTIFIER                 @"MenuPopoverCell"

#define MENU_TABLE_VIEW_FRAME           CGRectMake(0, 0, frame.size.width, frame.size.height)
#define MENU_POINTER_RECT               CGRectMake(frame.origin.x, frame.origin.y, 23, 11)

#define MENU_ITEM_COUNT                 7
#define MENU_ITEM_HEIGHT                (self.frame.size.height / MENU_ITEM_COUNT)
#define MENU_ITEM_MARGIN_TOP            0
#define MENU_ITEM_MARGIN_LEFT           12.0f
#define MENU_ITEM_CONTENT_MARGIN_LEFT   10.0f
#define MENU_ITEM_IMAGEVIEW_WIDTH       28.0f

#define SEPARATOR_MARGIN        30
#define SEPARATOR_HEIGHT        8
#define CONTAINER_BG_COLOR      RGBA(0, 0, 0, 0.4f)

#define ZERO                    0.0f
#define ONE                     1.0f
#define ANIMATION_DURATION      0.4f

#define MENU_POINTER_TAG        1011
#define MENU_TABLE_VIEW_TAG     1012

#define LANDSCAPE_WIDTH_PADDING 50

@interface MLKMenuPopover ()

@property(nonatomic,retain) NSMutableArray *menuItems, *menuItemsCommented, *menuItemsReviewed, *menuItemsLiked;

@property(nonatomic,retain) UIButton *containerButton;

- (void)hide;

@end

@implementation MLKMenuPopover

@synthesize menuPopoverDelegate;
@synthesize menuItems, menuItemsCommented, menuItemsLiked, menuItemsReviewed;
@synthesize containerButton;

- (id)initWithFrame:(CGRect)frame withPointerFrame:(CGRect)pointerFrame menuItems:(NSMutableArray *)aMenuItems {
    self = [super initWithFrame:frame];
    
    if (self)
    {
        menuItems = [[NSMutableArray alloc] init];
        menuItemsCommented = [[NSMutableArray alloc] init];
        menuItemsLiked = [[NSMutableArray alloc] init];
        
        menuItems = aMenuItems;
        
        for(NSMutableDictionary *dic in menuItems) {
            if([[dic objectForKey:@"user_action"] isEqualToString:@"commented"] || [[dic objectForKey:@"user_action"] isEqualToString:@"reviewed"]) {
                [menuItemsCommented addObject:dic];
            } else if([[dic objectForKey:@"user_action"] isEqualToString:@"liked"]) {
                [menuItemsLiked addObject:dic];
            }
        }
        // Adding Container Button which will take care of hiding menu when user taps outside of menu area
        self.containerButton = [[UIButton alloc] init];
        [self.containerButton setBackgroundColor:CONTAINER_BG_COLOR];
        [self.containerButton addTarget:self action:@selector(dismissMenuPopover) forControlEvents:UIControlEventTouchUpInside];
        [self.containerButton setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleBottomMargin];
        
        // Adding Menu Options Pointer
        CGRect rect = MENU_POINTER_RECT;
        rect.origin.x = pointerFrame.origin.x + ((pointerFrame.size.width - MENU_POINTER_RECT.size.width) / 2.0f);
        UIImageView *menuPointerView = [[UIImageView alloc] initWithFrame:rect];
        menuPointerView.image = [UIImage imageNamed:@"options_pointer"];
        menuPointerView.tag = MENU_POINTER_TAG;

        [self.containerButton addSubview:menuPointerView];
        
        // Adding menu Items table
        UITableView *menuItemsTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 11, frame.size.width, frame.size.height)];
        
        menuItemsTableView.dataSource = self;
        menuItemsTableView.delegate = self;
        menuItemsTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        
        menuItemsTableView.scrollEnabled = YES;
        menuItemsTableView.showsHorizontalScrollIndicator = NO;
        menuItemsTableView.showsVerticalScrollIndicator = NO;
        menuItemsTableView.bounces = YES;
        menuItemsTableView.backgroundColor = [UIColor clearColor];
        menuItemsTableView.tag = MENU_TABLE_VIEW_TAG;
        
        UIImageView *bgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Menu_PopOver_BG"]];
        menuItemsTableView.backgroundView = bgView;
        
        UIView *noDataView = [[UIView alloc] initWithFrame:CGRectMake(0, 11, frame.size.width, frame.size.height)];
        noDataView.backgroundColor = [UIColor whiteColor];
        
        UILabel *noDataLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, noDataView.frame.size.width, noDataView.frame.size.height)];
        [noDataLabel setText:@"No Recent Activity"];
        [noDataLabel setTextColor:appController.appMainColor];
        [noDataLabel setFont:[UIFont systemFontOfSize:12.0f]];
        [noDataLabel.layer setShadowColor:[UIColor clearColor].CGColor];
        [noDataLabel.layer setShadowOpacity:0];
        [noDataLabel setTextAlignment:NSTextAlignmentCenter];
        
        [noDataView addSubview:noDataLabel];
        
        [menuItemsTableView setHidden:!([menuItems count] > 0)];
        [noDataView setHidden:([menuItems count] > 0)];
        
        [self addSubview:noDataView];
        [self addSubview:menuItemsTableView];
        
        [self.containerButton addSubview:self];
    }
    [self setShadowOnView:self];
    return self;
}

- (void)setShadowOnView:(UIView *)view {
//    UIBezierPath *shadowPath = [UIBezierPath bezierPathWithRect:view.bounds];
//    view.layer.masksToBounds = NO;
//    view.layer.shadowColor = [UIColor whiteColor].CGColor;
//    view.layer.shadowOffset = CGSizeMake(5.0f, 5.0f);
//    view.layer.shadowOpacity = 0.5f;
//    view.layer.shadowPath = shadowPath.CGPath;
//    
    view.layer.shadowColor = [UIColor whiteColor].CGColor;
    view.layer.shadowOffset = CGSizeMake(4, 4);
    view.layer.shadowOpacity = 0.4;
    view.layer.shadowRadius = 2.0f;
}
#pragma mark - UITableViewDatasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)theTableView {
    return 2;
}

- (CGFloat)tableView:(UITableView*)tableView heightForHeaderInSection:(NSInteger)section {
    return (section == 0) ? 5.0f : SEPARATOR_HEIGHT;
}

- (CGFloat)tableView:(UITableView*)tableView heightForFooterInSection:(NSInteger)section {
    return (section == 0) ? SEPARATOR_HEIGHT : 7;
}

- (UIView*)tableView:(UITableView*)tableView viewForHeaderInSection:(NSInteger)section {
    if(section == 0) {
        return [[UIView alloc] initWithFrame:CGRectZero];
    } else {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, SEPARATOR_HEIGHT)];
        
        if([menuItemsCommented count] > 0 && [menuItemsLiked count] > 0) {
            CGRect frame = view.frame;
            frame.origin.x += SEPARATOR_MARGIN;
            frame.size.width -= (SEPARATOR_MARGIN * 2);
            frame.origin.y = 0;
            frame.size.height = 0.5f;
            
            UILabel *separatorLabel = [[UILabel alloc] initWithFrame:frame];
            [separatorLabel setBackgroundColor:appController.appMainColor];
            [view addSubview:separatorLabel];
        }
        view.backgroundColor = [UIColor clearColor];
        return view;
    }
}

- (UIView*)tableView:(UITableView*)tableView viewForFooterInSection:(NSInteger)section {
    return [[UIView alloc] initWithFrame:CGRectZero];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return MENU_ITEM_HEIGHT;
}

- (NSInteger)tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section {
    return (section == 0) ? [menuItemsCommented count] : [menuItemsLiked count];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    // Remove seperator inset
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    // Prevent the cell from inheriting the Table View's margin settings
    if ([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]) {
        [cell setPreservesSuperviewLayoutMargins:NO];
    }
    // Explictly set your cell's layout margins
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = CELL_IDENTIFIER;
    
    MLKMenuPopOverTableViewCell *cell = (MLKMenuPopOverTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[MLKMenuPopOverTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }

    // Set Cell Frame
    
    CGRect cellFrame = CGRectMake(MENU_ITEM_MARGIN_LEFT, MENU_ITEM_MARGIN_TOP, tableView.frame.size.width - (MENU_ITEM_MARGIN_LEFT * 2), MENU_ITEM_HEIGHT - (MENU_ITEM_MARGIN_TOP * 2));
    CGRect imageViewFrame = CGRectMake(cellFrame.origin.x, cellFrame.origin.y + (MENU_ITEM_HEIGHT - MENU_ITEM_IMAGEVIEW_WIDTH) / 2.0f, MENU_ITEM_IMAGEVIEW_WIDTH, MENU_ITEM_IMAGEVIEW_WIDTH);
    
    [cell.userPicImageView setFrame:imageViewFrame];
    [commonUtils setRoundedRectBorderImage:cell.userPicImageView withBorderWidth:1.0f withBorderColor:appController.appMainColor withBorderRadius:6.0f];
    
    CGRect contentFrame = CGRectMake(cellFrame.origin.x + MENU_ITEM_IMAGEVIEW_WIDTH + MENU_ITEM_CONTENT_MARGIN_LEFT, cellFrame.origin.y, cellFrame.size.width - MENU_ITEM_CONTENT_MARGIN_LEFT - MENU_ITEM_IMAGEVIEW_WIDTH, cellFrame.size.height);
    
    [cell.contentLabel setFrame:contentFrame];

    // Set Cell Data
    
    NSMutableDictionary *dic;
    if(indexPath.section == 0) {
        dic = [menuItemsCommented objectAtIndex:indexPath.row];
    } else {
        dic = [menuItemsLiked objectAtIndex:indexPath.row];
    }
    
    NSString *appendString = @" commented on your photo";
    if([[dic objectForKey:@"user_action"] isEqualToString:@"reviewed"]) {
        appendString = @" gave you a review";
    } else if([[dic objectForKey:@"user_action"] isEqualToString:@"liked"]) {
        appendString = @" liked your photo";
    }
    
    [cell.contentLabel setText:[[dic objectForKey:@"user_full_name"] stringByAppendingString:appendString]];
    [commonUtils setImageViewAFNetworking:cell.userPicImageView withImageUrl:[commonUtils getFullPhotoUrl:[dic objectForKey:@"user_photo_url"] withType:@"user"] withPlaceholderImage:[UIImage imageNamed:@"user_profile_default"]];
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self hide];
    [self.menuPopoverDelegate menuPopover:self didSelectMenuItemAtSection:indexPath.section didSelectMenuItemAtIndex:indexPath.row];
}

#pragma mark - Actions

- (void)dismissMenuPopover
{
    [self hide];
}

- (void)showInView:(UIView *)view
{
    self.containerButton.alpha = ZERO;
    self.containerButton.frame = view.bounds;
    [view addSubview:self.containerButton];
        
    [UIView animateWithDuration:ANIMATION_DURATION
                     animations:^{
                         self.containerButton.alpha = ONE;
                     }
                     completion:^(BOOL finished) {}];
}

- (void)hide
{
    [UIView animateWithDuration:ANIMATION_DURATION
                     animations:^{
                         self.containerButton.alpha = ZERO;
                     }
                     completion:^(BOOL finished) {
                         [self.containerButton removeFromSuperview];
                     }];
}

#pragma mark - Orientation Methods

- (void)layoutUIForInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    BOOL landscape = (interfaceOrientation == UIInterfaceOrientationLandscapeLeft || interfaceOrientation == UIInterfaceOrientationLandscapeRight);
    
    UIImageView *menuPointerView = (UIImageView *)[self.containerButton viewWithTag:MENU_POINTER_TAG];
    UITableView *menuItemsTableView = (UITableView *)[self.containerButton viewWithTag:MENU_TABLE_VIEW_TAG];
    
    if( landscape )
    {
        menuPointerView.frame = CGRectMake(menuPointerView.frame.origin.x + LANDSCAPE_WIDTH_PADDING, menuPointerView.frame.origin.y, menuPointerView.frame.size.width, menuPointerView.frame.size.height);
        
        menuItemsTableView.frame = CGRectMake(menuItemsTableView.frame.origin.x + LANDSCAPE_WIDTH_PADDING, menuItemsTableView.frame.origin.y, menuItemsTableView.frame.size.width, menuItemsTableView.frame.size.height);
    }
    else
    {
        menuPointerView.frame = CGRectMake(menuPointerView.frame.origin.x - LANDSCAPE_WIDTH_PADDING, menuPointerView.frame.origin.y, menuPointerView.frame.size.width, menuPointerView.frame.size.height);
        
        menuItemsTableView.frame = CGRectMake(menuItemsTableView.frame.origin.x - LANDSCAPE_WIDTH_PADDING, menuItemsTableView.frame.origin.y, menuItemsTableView.frame.size.width, menuItemsTableView.frame.size.height);
    }
}

@end
