//
//  BusinessCell.m
//  Yelp
//
//  Created by Ali YAZDAN PANAH on 10/24/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

#import "BusinessCell.h"
#import "UIImageView+AFNetworking.h"

@interface BusinessCell ()
@property (weak, nonatomic) IBOutlet UIImageView *thumbImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;
@property (weak, nonatomic) IBOutlet UIImageView *ratingImageView;
@property (weak, nonatomic) IBOutlet UILabel *ratingLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *categoryLabel;

@end

@implementation BusinessCell

- (void)awakeFromNib {
  // Initialization code
  self.nameLabel.preferredMaxLayoutWidth = self.nameLabel.frame.size.width;
  self.thumbImageView.layer.cornerRadius = 5.0;
  self.thumbImageView.clipsToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
  [super setSelected:selected animated:animated];
  
  // Configure the view for the selected state
}

-(void)setBusiness:(Business *)business{
  _business = business;
  [self.thumbImageView setImageWithURL:[NSURL URLWithString:self.business.imageUrl]];
  self.nameLabel.text = self.business.name;
  [self.ratingImageView setImageWithURL:[NSURL URLWithString:self.business.ratingImageUrl]];
  self.ratingLabel.text = [NSString stringWithFormat:@"%ld Reviews",(long)self.business.numReviews];
  self.addressLabel.text = self.business.address;
  self.distanceLabel.text = [NSString stringWithFormat:@"%0.2f mi",self.business.distance];
  [self layoutSubviews];
}

-(void)layoutSubviews{
  self.nameLabel.preferredMaxLayoutWidth = self.nameLabel.frame.size.width;
}

@end
