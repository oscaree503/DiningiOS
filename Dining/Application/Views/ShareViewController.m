//
//  ShareViewController.m
//  Dining
//
//  Created by Polaris on 12/24/15.
//  Copyright (c) 2015 Polaris. All rights reserved.
//

#import "ShareViewController.h"
#import "ShareCollectionViewCell.h"
#import <CoreImage/CoreImage.h>

@interface ShareViewController ()<UICollectionViewDataSource, UICollectionViewDelegate>

@property (strong, nonatomic) IBOutlet UICollectionView *collectionviewShare;

@property (strong, nonatomic) IBOutlet UIImageView *imgOriginal;
@property (strong, nonatomic) IBOutlet UIImageView *imgBW;
@property (strong, nonatomic) IBOutlet UIImageView *imgSepia;
@property (strong, nonatomic) IBOutlet UIImageView *imgContrast;


@property (strong, nonatomic) IBOutlet UILabel *lblFoodName;

@property (strong, nonatomic) IBOutlet UILabel *lblFoodReview;
@end

@implementation ShareViewController{
    NSMutableArray *imageArray;
    NSUInteger sel_cell;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _collectionviewShare.dataSource = self;
    _collectionviewShare.delegate = self;
    
    [self initUI];
    
    sel_cell = [appController.yelpArray count];
    
    _lblFoodReview.text = @"";
    
    _collectionviewShare.scrollEnabled = YES;
    [_collectionviewShare setPagingEnabled:NO];
    
    
    imageArray = [[NSMutableArray alloc] init];
    
    for (int i=0;i<5;i++){
        [commonUtils showActivityIndicator:self.view];
        
        NSURL *url = [NSURL URLWithString:[[appController.yelpArray objectAtIndex:i] objectForKey:@"FoodImageURL"]];
        NSData *data = [NSData dataWithContentsOfURL:url];
        [imageArray addObject:[UIImage imageWithData:data]];
    }
    [commonUtils hideActivityIndicator];
    
}
-(void)viewWillAppear:(BOOL)animated{
    _lblFoodName.text = appController.user_foodName;
    _lblFoodReview.text = appController.user_foodReview;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void) initUI{
    
    int kCellsPerRow = 3, kCellsPerCol = 1;
    UICollectionViewFlowLayout *flowLayout = (UICollectionViewFlowLayout*) _collectionviewShare.collectionViewLayout;
    CGFloat availableWidthForCells = CGRectGetWidth(_collectionviewShare.frame) - flowLayout.sectionInset.left - flowLayout.sectionInset.right - flowLayout.minimumInteritemSpacing * (kCellsPerRow - 1);
    CGFloat cellWidth = availableWidthForCells / (float)kCellsPerRow;
    
    CGFloat availableHeightForCells = CGRectGetHeight(_collectionviewShare.frame) - flowLayout.sectionInset.top - flowLayout.sectionInset.bottom - flowLayout.minimumInteritemSpacing * (kCellsPerCol - 1);
    CGFloat cellHeight = availableHeightForCells / (float)kCellsPerCol;
    
    flowLayout.itemSize = CGSizeMake(cellWidth, cellHeight);

}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return [imageArray count];
}

-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{

    ShareCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"shareCollectionCell" forIndexPath:indexPath];
//    NSDictionary *yelpInfo = [appController.yelpArray objectAtIndex:indexPath.row];
    
//    [cell.imgFood setImageWithURL:[NSURL URLWithString:yelpInfo[@"image_url"]]];
    [cell.imgFood setImage:[imageArray objectAtIndex:indexPath.row]];
        
    if (sel_cell < [appController.yelpArray count]) {
        
        if (sel_cell == indexPath.row) {
            [cell.viewMask setHidden:NO];
            [cell.imgCheck setHidden:NO];
        } else {
            [cell.viewMask setHidden:YES];
            [cell.imgCheck setHidden:YES];
        }
    } else {
        
        [cell.viewMask setHidden:YES];
        [cell.imgCheck setHidden:YES];
    }

    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    ShareCollectionViewCell *cell;
    
//    NSLog(@"%ld", (long)indexPath.row);
    sel_cell = indexPath.row;
    
    for (long iCell=0; iCell< [imageArray count]; iCell++) {
        
        NSIndexPath *iPath = [NSIndexPath indexPathForRow:iCell inSection:0];
        cell =(ShareCollectionViewCell*)[_collectionviewShare cellForItemAtIndexPath:iPath];
        
        if (indexPath.row == iCell) {
            
            [cell.viewMask setHidden:NO];
            [cell.imgCheck setHidden:NO];
            cell.isCheck = 1;
            
        } else {
            
            [cell.viewMask setHidden:YES];
            [cell.imgCheck setHidden:YES];
            cell.isCheck = 0;

        }
        
    }
    
//    NSString *imgName = [appController.collectionArray objectAtIndex:indexPath.row];
    
    UIImage *sel_image;
    
    sel_image = [imageArray objectAtIndex:indexPath.row];
    
    _imgOriginal.image = sel_image;
    _imgBW.image = [self convertImageToGrayScale:sel_image];
    _imgSepia.image = [self sepiaFilter:sel_image];
    _imgContrast.image = [self contrastFilter:sel_image];
    
    _lblFoodReview.text = [[appController.yelpArray objectAtIndex:indexPath.row] objectForKey:@"FoodReview"];
    
}
- (UIImage *)sepiaFilter:(UIImage *)image {
    
    CIImage *bgnImage = [[CIImage alloc] initWithImage:image];
    CIContext *imgContext = [CIContext contextWithOptions:nil];
    
    CIFilter *imgFilter = [CIFilter filterWithName:@"CISepiaTone" keysAndValues: kCIInputImageKey, bgnImage, @"inputIntensity", [NSNumber numberWithFloat:1.5], nil];
    CIImage *myOutputImage = [imgFilter outputImage];
    
    CGImageRef cgImgRef = [imgContext  createCGImage:myOutputImage fromRect:[myOutputImage extent]];
    UIImage *newImgWithFilter = [UIImage imageWithCGImage:cgImgRef];
    
    return newImgWithFilter;
}
- (IBAction)onCloseBtn:(id)sender {
//    [self dismissViewControllerAnimated:YES completion:nil];
}

- (UIImage *)contrastFilter:(UIImage *)image {
    
    CIImage *bgnImage = [[CIImage alloc] initWithImage:image];
    CIContext *imgContext = [CIContext contextWithOptions:nil];
    
    CIFilter *imgFilter = [CIFilter filterWithName:@"CIColorControls" keysAndValues: kCIInputImageKey, bgnImage, @"inputContrast", [NSNumber numberWithFloat:1.2], nil];
    
    CIImage *myOutputImage = [imgFilter outputImage];
    
    CGImageRef cgImgRef = [imgContext  createCGImage:myOutputImage fromRect:[myOutputImage extent]];
    UIImage *newImgWithFilter = [UIImage imageWithCGImage:cgImgRef];
    
    return newImgWithFilter;
}


- (UIImage *)convertImageToGrayScale:(UIImage *)image {
    
    
    // Create image rectangle with current image width/height
    CGRect imageRect = CGRectMake(0, 0, image.size.width, image.size.height);
    
    // Grayscale color space
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceGray();
    
    // Create bitmap content with current image size and grayscale colorspace
    CGContextRef context = CGBitmapContextCreate(nil, image.size.width, image.size.height, 8, 0, colorSpace, kCGImageAlphaNone);
    
    // Draw image into current context, with specified rectangle
    // using previously defined context (with grayscale colorspace)
    CGContextDrawImage(context, imageRect, [image CGImage]);
    
    // Create bitmap image info from pixel data in current context
    CGImageRef imageRef = CGBitmapContextCreateImage(context);
    
    // Create a new UIImage object
    UIImage *newImage = [UIImage imageWithCGImage:imageRef];
    
    // Release colorspace, context and bitmap information
    CGColorSpaceRelease(colorSpace);
    CGContextRelease(context);
    CFRelease(imageRef);
    
    // Return the new grayscale image
    return newImage;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
