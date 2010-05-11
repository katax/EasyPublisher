//
//  IndexPageTableViewController.h
//  ContractForSE
//
//  Created by kata on 10/04/19.
//  Copyright 2010 katax. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ContentsViewController;

@interface IndexPageTableViewController : UITableViewController {
	NSMutableArray *contentsArray;
	ContentsViewController *contentsViewController; //deallocでの解放不要
	NSInteger controllerSection;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil contentsViewContoroller:(ContentsViewController *)_contentsViewContoroller viewMode:(NSInteger)viewModeInteger;

@end
