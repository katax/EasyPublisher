//
//  ContentsViewController.h
//  ContractForSE
//
//  Created by kata on 10/04/19.
//  Copyright 2010 katax. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ContentsViewController : UIViewController{
	
	CGPoint touchLocation;
	BOOL isShowControlPad;
	
	NSInteger pagePosition;
	
	IBOutlet UIView *controlPadView;
	IBOutlet UILabel *pagePositionLabel;
	
	IBOutlet UIImageView *previousPageImageView;
	IBOutlet UIImageView *mainImageView;
	IBOutlet UIImageView *nextPageImageView;
	
	IBOutlet UIButton *favoriteButton;
	IBOutlet UIButton *favoriteMemoButton;
	UITextField *alertViewTextField;//deallocでの解放不要
	
	IBOutlet UILabel *pageNumberLabel;
}

@property(nonatomic) NSInteger pagePosition;

-(IBAction)favoriteMemoButtonPushed;
-(void)favoriteButtonSelectedChange:(BOOL)selected;
-(IBAction)favoriteButtonPushed;

-(NSInteger)isFavorite:(NSInteger)targetPagePosition;
-(void)loadPage:(NSInteger)pagePositionInteger;

-(IBAction)returnToTitlePage;
-(IBAction)showIndexPage;
-(IBAction)showIndexPageForFavorite;
-(void)showControlPadView;
-(IBAction)closeControlPadView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil initialPage:(NSInteger)initialPageInteger;
@end
