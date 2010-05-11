//
//  StartViewController.h
//  ContractForSE
//
//  Created by kata on 10/04/19.
//  Copyright 2010 katax. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AboutViewController;

@interface StartViewController : UIViewController {
    IBOutlet UIView *aboutView;//deallocで解放不要
	IBOutlet UIScrollView *thanksScrollView;
	IBOutlet UIScrollView *noticeScrollView;
}

-(IBAction)showIndexPageTableView;
-(IBAction)showIndexPageTableViewForFavorite;
-(IBAction)showContentsViewFromFirstPage;
-(void)showContentsViewFromContinuation:(BOOL)animated;
-(IBAction)showContentsViewFromContinuation;

-(IBAction)sendFeedBack;
-(IBAction)closeAboutView;	
@end
