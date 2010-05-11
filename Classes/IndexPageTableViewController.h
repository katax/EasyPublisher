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
	NSMutableArray *contentsArray;//セルのコンテンツを格納する配列
	ContentsViewController *contentsViewController; //deallocでの解放不要
	NSInteger controllerSection;//ContentsViewControllerから呼び出されたときは1を、そうでないときは0を代入し、「戻る」セルの表示をコントロールする
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil contentsViewContoroller:(ContentsViewController *)_contentsViewContoroller;

@end
