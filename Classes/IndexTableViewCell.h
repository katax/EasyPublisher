//
//  IndexTableViewCell.h
//  ContractForSE
//
//  Created by kata on 10/04/22.
//  Copyright 2010 katax. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface IndexTableViewCell : UITableViewCell {
	IBOutlet UILabel *pageLabel;
	IBOutlet UILabel *titleLabel;
}

@property(nonatomic,retain)	IBOutlet UILabel *pageLabel;
@property(nonatomic,retain)	IBOutlet UILabel *titleLabel;

@end
