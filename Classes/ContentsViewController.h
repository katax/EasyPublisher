//
//  ContentsViewController.h
//  ContractForSE
//
//  Created by kata on 10/04/19.
//  Copyright 2010 katax. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ContentsViewController : UIViewController{
	
	CGPoint touchLocation;//タッチ開始時の座標
	BOOL isShowControlPad;//コントロールパッドが表示されているか
	
	NSInteger pagePosition;//表示中のページ
	
	//ControlPad関連
	IBOutlet UIView *controlPadView;
	IBOutlet UILabel *pagePositionLabel;

	//コンテンツを表示するImageView
	IBOutlet UIImageView *previousPageImageView;
	IBOutlet UIImageView *mainImageView;
	IBOutlet UIImageView *nextPageImageView;

	//favorite(スター)関連
	IBOutlet UIButton *favoriteButton;
	IBOutlet UIButton *favoriteMemoButton;
	UITextField *alertViewTextField;//deallocでの解放不要
	
	//page番号
	IBOutlet UILabel *pageNumberLabel;
}

@property(nonatomic) NSInteger pagePosition;

//favorite(スター)関連
-(IBAction)favoriteMemoButtonPushed;
-(void)favoriteButtonSelectedChange:(BOOL)selected;
-(IBAction)favoriteButtonPushed;
-(NSInteger)isFavorite:(NSInteger)targetPagePosition;

//ページの読み込み
-(void)loadPage:(NSInteger)pagePositionInteger;

//ControlPad関連
-(IBAction)returnToTitlePage;
-(IBAction)showIndexPage;
-(IBAction)showIndexPageForFavorite;
-(void)showControlPadView;
-(IBAction)closeControlPadView;

//初期化
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil initialPage:(NSInteger)initialPageInteger;
@end
