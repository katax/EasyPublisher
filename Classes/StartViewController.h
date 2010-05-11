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
	IBOutlet UIButton *sendFeedBackButton;
}

-(IBAction)showIndexPageTableView;
-(IBAction)showIndexPageTableViewForFavorite;
-(IBAction)showContentsViewFromFirstPage;
-(void)showContentsViewFromContinuation:(BOOL)animated;
-(IBAction)showContentsViewFromContinuation;

//iボタンを押して表示する画面の操作
-(IBAction)sendFeedBack;
-(IBAction)closeAboutView;	
@end
