//
//  ProductCell.h
//  ZilogCafe
//
//  Created by Camilo on 05-10-13.
//
//

#import <UIKit/UIKit.h>

@interface ProductCell : PFTableViewCell
@property (weak, nonatomic) IBOutlet UILabel *productName;
@property (weak, nonatomic) IBOutlet UILabel *productIsAvailable;
@property (weak, nonatomic) IBOutlet UILabel *productPrice;
@property (weak, nonatomic) IBOutlet PFImageView * productImage;



@end
