//
//  ContentsViewController.m
//  ContractForSE
//
//  Created by kata on 10/04/19.
//  Copyright 2010 katax. All rights reserved.
//

#import "ContentsViewController.h"
#import "QuartzCore/CALayer.h"
#import "IndexPageTableViewController.h"

#define kTotalPageNumber 264

@implementation ContentsViewController
@synthesize pagePosition;
#pragma mark -
#pragma mark TouchControl
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	UITouch *touch = [touches anyObject];
	touchLocation = [touch locationInView:self.view];
	[UIView beginAnimations:@"favoriteButtonHide" context:nil];
	favoriteButton.alpha=0.0f;
	favoriteMemoButton.alpha=0.0f;
	[UIView commitAnimations]; 
	
	isShowControlPad=YES;
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
	UITouch *touch = [touches anyObject];
	CGPoint location = [touch locationInView:self.view];
	mainImageView.center=CGPointMake([UIScreen mainScreen].bounds.size.width/2+(location.x-touchLocation.x),mainImageView.center.y);
	nextPageImageView.center=CGPointMake(mainImageView.center.x+[UIScreen mainScreen].bounds.size.width,mainImageView.center.y);
	previousPageImageView.center=CGPointMake(mainImageView.center.x-[UIScreen mainScreen].bounds.size.width,mainImageView.center.y);
	
	if((isShowControlPad)&&((abs(touchLocation.x-location.x)>18)||(abs(touchLocation.y-location.y)>25))){
		isShowControlPad=NO;
	}

}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
	NSInteger scrollDirection=0;
	CGFloat mainImageViewXPosition=[UIScreen mainScreen].bounds.size.width/2;

	if((mainImageView.center.x<[UIScreen mainScreen].bounds.size.width/3)&&(pagePosition<kTotalPageNumber)){
		mainImageViewXPosition=-[UIScreen mainScreen].bounds.size.width/2;
		scrollDirection=1;
	}else if((mainImageView.center.x>[UIScreen mainScreen].bounds.size.width/3*2)&&(pagePosition>1)){
		scrollDirection=-1;
		mainImageViewXPosition=[UIScreen mainScreen].bounds.size.width*1.5;
	}else{
		[self favoriteButtonSelectedChange:favoriteButton.selected];
	}

	[UIView beginAnimations:@"ImageViewScroll" context:[NSNumber numberWithInteger:scrollDirection]];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
	mainImageView.center=CGPointMake(mainImageViewXPosition,mainImageView.center.y);
	if(scrollDirection!=0){
		[UIView setAnimationDidStopSelector:@selector(animationFinished:finished:context:)];
	}
	nextPageImageView.center=CGPointMake(mainImageView.center.x+[UIScreen mainScreen].bounds.size.width,mainImageView.center.y);
	previousPageImageView.center=CGPointMake(mainImageView.center.x-[UIScreen mainScreen].bounds.size.width,mainImageView.center.y);
	
	if(controlPadView.alpha!=0.0f){
		[self closeControlPadView];
	}else if(isShowControlPad){
		[self showControlPadView];
	}
	
	//NSLog(@"%f %f",touchLocation.x-endLocation.x,touchLocation.y-endLocation.y);
	
	[UIView commitAnimations];
	
}

- (void)animationFinished:(NSString *)animationID finished:(BOOL)finished context:(void *)context {
	NSInteger scrollDirection=[(NSNumber *)context integerValue];

	if(scrollDirection==1){
		pagePosition++;
	}else {
		pagePosition--;
	}
	[self loadPage:pagePosition];
	mainImageView.center=CGPointMake([UIScreen mainScreen].bounds.size.width/2,mainImageView.center.y);
	nextPageImageView.center=CGPointMake(mainImageView.center.x+[UIScreen mainScreen].bounds.size.width,mainImageView.center.y);
	previousPageImageView.center=CGPointMake(mainImageView.center.x-[UIScreen mainScreen].bounds.size.width,mainImageView.center.y);
	
}

#pragma mark -
#pragma mark favoriteControll
-(IBAction)favoriteMemoButtonPushed{
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"メモ" message:@"メモを入力してください" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK",@"キャンセル", nil];
	alertViewTextField = [[UITextField alloc] initWithFrame:CGRectMake(12, 45, 260, 25)];	
	alertViewTextField.text=([[favoriteMemoButton titleForState:UIControlStateNormal] isEqualToString:@"メモ未記入"])?@"":[favoriteMemoButton titleForState:UIControlStateNormal];
	[alert setTransform:CGAffineTransformMakeTranslation(0, 75)];	
	[alertViewTextField setBorderStyle:UITextBorderStyleRoundedRect];
	[alertViewTextField setClearButtonMode:UITextFieldViewModeAlways];
	[alertViewTextField setPlaceholder:@"メモ未記入"];
	[alertViewTextField setReturnKeyType:UIReturnKeyDone];
	[alert addSubview:alertViewTextField];	
	[alertViewTextField release];
	[alert show];	
	[alertViewTextField becomeFirstResponder];
	[alert release];
}

-(void)favoriteButtonSelectedChange:(BOOL)selected{
	[favoriteButton setSelected:selected];

	[UIView beginAnimations:@"favoriteButtonHide" context:nil];
	if(favoriteButton.selected){
		favoriteButton.alpha=1.0f;
		favoriteMemoButton.alpha=1.0f;	
	} else {
		favoriteButton.alpha=0.25f;
		favoriteMemoButton.alpha=0.0f;
	}
	[UIView commitAnimations];
}

-(IBAction)favoriteButtonPushed{
	[self favoriteButtonSelectedChange:!favoriteButton.selected];
	NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
	NSMutableArray *tempArray=[NSMutableArray arrayWithArray:[userDefaults objectForKey:@"favoriteMemoArray"]];
	if(tempArray==nil){
		tempArray=[NSMutableArray array];
	}
	
	for (int i=0;i<[tempArray count];i++) {
		if([[[tempArray objectAtIndex:i] objectForKey:@"page"] integerValue]==pagePosition){
			[tempArray removeObjectAtIndex:i];
			i--;
		}
	}
	
	
	if(favoriteButton.selected){
		NSString *titleString=nil;
		if([self isFavorite:pagePosition]==-1){
			titleString=@"メモ未記入";
		}else {
			titleString=[[[[NSUserDefaults standardUserDefaults] objectForKey:@"favoriteMemoArray"] objectAtIndex:[self isFavorite:pagePosition]] objectForKey:@"title"];
		}
		[favoriteMemoButton setTitle:(titleString)?titleString:@"メモ未記入" forState:UIControlStateNormal];
		[tempArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:[favoriteMemoButton titleForState:UIControlStateNormal],@"title",[NSNumber numberWithInteger:pagePosition],@"page",nil]];
		
	}
	[userDefaults setObject:tempArray forKey:@"favoriteMemoArray"];
}

-(NSInteger)isFavorite:(NSInteger)targetPagePosition{
	NSArray *tempArray=[[NSUserDefaults standardUserDefaults] objectForKey:@"favoriteMemoArray"];
	if(tempArray==nil){
		return -1;
	}
	
	for(int i=0;i<[tempArray count];i++){ //(NSDictionary *tempDictionary in tempArray){
		if([[[tempArray objectAtIndex:i] objectForKey:@"page"] integerValue]==targetPagePosition){
			return i;
		}
	}
	return -1;
}

#pragma mark -
#pragma mark PageLoading
-(void)loadPage:(NSInteger)pagePositionInteger{
	previousPageImageView.image=[UIImage imageNamed:[NSString stringWithFormat:@"%i.png",pagePositionInteger-1]];
	mainImageView.image=[UIImage imageNamed:[NSString stringWithFormat:@"%i.png",pagePositionInteger]];
	nextPageImageView.image=[UIImage imageNamed:[NSString stringWithFormat:@"%i.png",pagePositionInteger+1]];
	NSInteger favoritePosition=[self isFavorite:pagePosition];
	[self favoriteButtonSelectedChange:(favoritePosition!=-1)];
	if(favoriteButton.selected){
		NSString *titleString=[[[[NSUserDefaults standardUserDefaults] objectForKey:@"favoriteMemoArray"] objectAtIndex:favoritePosition] objectForKey:@"title"];
		[favoriteMemoButton setTitle:(titleString)?titleString:@"メモ未記入" forState:UIControlStateNormal];
	}
	pageNumberLabel.text=[NSString stringWithFormat:@"%i",pagePositionInteger];
}

#pragma mark -
#pragma mark controlPadView
-(IBAction)returnToTitlePage{
	//[self.navigationController setNavigationBarHidden:NO animated:YES];
	//[self.navigationController popViewControllerAnimated:YES];
	[self dismissModalViewControllerAnimated:YES];
}

-(IBAction)showIndexPage{
	IndexPageTableViewController *indexPageTableViewController=[[IndexPageTableViewController alloc] initWithNibName:@"IndexPageTableViewController" bundle:nil contentsViewContoroller:self viewMode:0];
	[self presentModalViewController:indexPageTableViewController animated:YES];
	[indexPageTableViewController release];
	[self closeControlPadView];
	
}

-(IBAction)showIndexPageForFavorite{
	IndexPageTableViewController *indexPageTableViewController=[[IndexPageTableViewController alloc] initWithNibName:@"IndexPageTableViewController" bundle:nil contentsViewContoroller:self viewMode:1];
	[self presentModalViewController:indexPageTableViewController animated:YES];
	[indexPageTableViewController release];
	[self closeControlPadView];
	
}


-(void)showControlPadView{
	pagePositionLabel.text=[NSString stringWithFormat:@"%i / %i",pagePosition,kTotalPageNumber];
	[controlPadView setAlpha:1.0f];
}

-(IBAction)closeControlPadView{
	[UIView beginAnimations:@"controlPadViewHide" context:nil];
	[controlPadView setAlpha:0.0f];
	[UIView commitAnimations];		
}

#pragma mark -
#pragma mark alertViewのdelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
	[alertViewTextField resignFirstResponder];
	
	if(buttonIndex==alertView.firstOtherButtonIndex){
		NSString *titleString=([alertViewTextField.text length]==0)?@"メモ未記入":alertViewTextField.text;
		NSMutableArray *tempArray=[NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"favoriteMemoArray"]];
		NSInteger favoritePosition=[self isFavorite:pagePosition];
		if(favoritePosition!=-1){
			NSMutableDictionary *tempDictionary=[NSMutableDictionary dictionaryWithDictionary:[tempArray objectAtIndex:favoritePosition]];
			[tempDictionary setObject:titleString forKey:@"title"];
			[tempArray removeObjectAtIndex:favoritePosition];
			[tempArray insertObject:tempDictionary atIndex:favoritePosition];
		}
		
		[[NSUserDefaults standardUserDefaults] setObject:tempArray forKey:@"favoriteMemoArray"];
		[favoriteMemoButton setTitle:titleString forState:UIControlStateNormal];
	}
}	


#pragma mark -
#pragma mark ViewControllerDelegates


 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
		pagePosition=1;
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil initialPage:(NSInteger)initialPageInteger{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
		pagePosition=(initialPageInteger==0)?1:initialPageInteger;
    }
    return self;
}


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	[controlPadView setAlpha:0.0f];
	CALayer *layer = [controlPadView layer];
    [layer setMasksToBounds:YES];
    [layer setCornerRadius:25.0f];
	
}

- (void)viewWillAppear:(BOOL)animated{
	[super viewWillAppear:animated];
	[self loadPage:pagePosition];		
}

- (void)viewDidDisappear:(BOOL)animated{
	[super viewDidDisappear:animated];
	[[NSUserDefaults standardUserDefaults] setInteger:pagePosition forKey:@"bookmark-0"];
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
	[controlPadView release];
	[pagePositionLabel release];
	[previousPageImageView release];
	[mainImageView release];
	[nextPageImageView release];
	[favoriteButton release];
	[favoriteMemoButton release];
    [super dealloc];
}


@end
