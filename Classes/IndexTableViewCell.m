//
//  IndexTableViewCell.m
//  ContractForSE
//
//  Created by kata on 10/04/22.
//  Copyright 2010 katax. All rights reserved.
//

#import "IndexTableViewCell.h"


@implementation IndexTableViewCell
@synthesize pageLabel,titleLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        // Initialization code
    }
    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
	
    [super setSelected:selected animated:animated];
	
    // Configure the view for the selected state
}


- (void)dealloc {
	[titleLabel release];
	[pageLabel release];
    [super dealloc];
}


@end
