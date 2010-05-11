//
//  StartViewController.m
//  ContractForSE
//
//  Created by kata on 10/04/19.
//  Copyright 2010 katax. All rights reserved.
//

#import "StartViewController.h"
#import "IndexPageTableViewController.h"
#import "StarPageTableViewController.h"
#import "ContentsViewController.h"


@implementation StartViewController

#define SUPPORT_EMAIL_ADDRESS @"foo@bar.com"

#pragma mark -
#pragma mark ボタンアクション
-(IBAction)showIndexPageTableView{
	IndexPageTableViewController *indexPageTableViewController=[[IndexPageTableViewController alloc] initWithNibName:@"IndexPageTableViewController" bundle:nil contentsViewContoroller:nil];
	[self.navigationController pushViewController:indexPageTableViewController animated:YES];
	[indexPageTableViewController release];
}

-(IBAction)showIndexPageTableViewForFavorite{
	StarPageTableViewController *starPageTableViewController=[[StarPageTableViewController alloc] initWithNibName:@"IndexPageTableViewController" bundle:nil contentsViewContoroller:nil];
	[self.navigationController pushViewController:starPageTableViewController animated:YES];
	[starPageTableViewController release];
}

-(IBAction)showContentsViewFromFirstPage{
	ContentsViewController *contentsViewController=[[ContentsViewController alloc] initWithNibName:@"ContentsViewController" bundle:nil];
	[self presentModalViewController:contentsViewController animated:YES];
	[contentsViewController release];
}

-(void)showContentsViewFromContinuation:(BOOL)animated{
	ContentsViewController *contentsViewController=[[ContentsViewController alloc] initWithNibName:@"ContentsViewController" bundle:nil initialPage:[[NSUserDefaults standardUserDefaults] integerForKey:@"bookmark-0"]];
	[self presentModalViewController:contentsViewController animated:animated];
	[contentsViewController release];
}

-(IBAction)showContentsViewFromContinuation{
	[self showContentsViewFromContinuation:YES];
}


-(void)infoButtonPushed{
	if(self.navigationItem.leftBarButtonItem.tag==0){
		[UIView beginAnimations:nil context:nil];
		[UIView setAnimationDuration:0.5f];
		[UIView setAnimationTransition:UIViewAnimationTransitionCurlDown forView:self.view cache:YES];
		[self.view addSubview:aboutView];
		[UIView commitAnimations];
		self.navigationItem.leftBarButtonItem.tag=1;
		[self.navigationItem setTitle:@"インフォメーション"];
	}else{
		[self closeAboutView];
	}
}

#pragma mark -
#pragma mark iボタンを押して表示する画面の操作
-(IBAction)sendFeedBack{
	NSString *content = [NSString stringWithFormat:@"subject=ご意見・ご感想&body=【version:%@】【OS:%@】【端末:%@】",[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"],[[UIDevice currentDevice] systemVersion],[[UIDevice currentDevice] model]];
	NSString *mailto = [NSString stringWithFormat:@"mailto:%@?%@", SUPPORT_EMAIL_ADDRESS ,[content stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
	NSURL *url = [NSURL URLWithString:mailto];
	[[UIApplication sharedApplication] openURL:url];			
	
}

-(IBAction)closeAboutView{
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:0.5f];
	[UIView setAnimationTransition:UIViewAnimationTransitionCurlUp forView:self.view cache:YES];
	[aboutView removeFromSuperview];
	[UIView commitAnimations];
	[self.navigationItem setTitle:@"スタートページ"];
	self.navigationItem.leftBarButtonItem.tag=0;
}

#pragma mark -
#pragma mark ViewControllerのDelegates

/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
 - (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
 if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
 // Custom initialization
 }
 return self;
 }
 */


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	UIButton *infoButton=[UIButton buttonWithType:UIButtonTypeInfoLight];
	[infoButton addTarget:self action:@selector(infoButtonPushed) forControlEvents:UIControlEventTouchUpInside];
	self.navigationItem.leftBarButtonItem=[[[UIBarButtonItem alloc] initWithCustomView:infoButton] autorelease];
	
	if([[NSUserDefaults standardUserDefaults] integerForKey:@"bookmark-0"]>1){
		[self showContentsViewFromContinuation:NO];
	}
	
	if([SUPPORT_EMAIL_ADDRESS isEqualToString:@"foo@bar.com"]){
		sendFeedBackButton.hidden=YES;
	}
	
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
	[self.navigationItem setTitle:@"スタートページ"];
}	


/*
 // Override to allow orientations other than the default portrait orientation.
 - (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
 // Return YES for supported orientations
 return (interfaceOrientation == UIInterfaceOrientationPortrait);
 }
 */

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc {
	[aboutView release];
    [super dealloc];
}


@end
