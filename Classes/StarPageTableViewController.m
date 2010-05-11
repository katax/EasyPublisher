//
//  StarPageTableViewController.m
//  ContractForSE
//
//  Created by kata on 10/04/19.
//  Copyright 2010 katax. All rights reserved.
//

#import "StarPageTableViewController.h"
#import "ContentsViewController.h"
#import "IndexTableViewCell.h"

@implementation StarPageTableViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil contentsViewContoroller:(ContentsViewController *)_contentsViewContoroller{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
		if(_contentsViewContoroller){
			contentsViewController=_contentsViewContoroller;
			controllerSection=1;
		}else {
			contentsViewController=nil;
			controllerSection=0;
		}
		
		[self.navigationItem setTitle:@"スターのリスト"];
		[(UITableView *)self.view setEditing:YES];
		contentsArray=[[NSMutableArray alloc] initWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"favoriteMemoArray"]];
		
    }
    return self;
}

/*
 - (id)initWithStyle:(UITableViewStyle)style {
 // Override initWithStyle: if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
 if (self = [super initWithStyle:style]) {
 }
 return self;
 }
 */


- (void)viewDidLoad {
    [super viewDidLoad];
	
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
	//	NSArray *testArray=[NSArray arrayWithObjects:
	//						[NSDictionary dictionaryWithObjectsAndKeys:@"title1",@"title",[NSNumber numberWithInteger:1],@"page",nil],
	//						[NSDictionary dictionaryWithObjectsAndKeys:@"title2",@"title",[NSNumber numberWithInteger:2],@"page",nil],nil];
	//	[testArray writeToFile:[NSHomeDirectory() stringByAppendingPathComponent:@"Documents/temp.xml"] atomically:YES];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}	

/*
 - (void)viewDidAppear:(BOOL)animated {
 [super viewDidAppear:animated];
 }
 */
/*
 - (void)viewWillDisappear:(BOOL)animated {
 [super viewWillDisappear:animated];
 }
 */
/*
 - (void)viewDidDisappear:(BOOL)animated {
 [super viewDidDisappear:animated];
 }
 */

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

#pragma mark -
#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1+controllerSection;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	if((section==0)&&(controllerSection==1)){
		return 1;
	}
	
	return [contentsArray count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
	static NSString *BackCellIdentifier=@"Back";
    
	UITableViewCell *backCell = [tableView dequeueReusableCellWithIdentifier:BackCellIdentifier];
	IndexTableViewCell *cell = (IndexTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	
	if((indexPath.section==0)&&(controllerSection==1)){
		if (backCell == nil) {
			backCell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:BackCellIdentifier] autorelease];
		}		
	}else {
		if (cell == nil) {
			UIViewController *viewController = [[UIViewController alloc] initWithNibName: @"IndexTableViewCell" bundle: nil];
			cell = (IndexTableViewCell *)viewController.view;
			[viewController release];
		}
	}
    
	if((indexPath.section==0)&&(controllerSection==1)){
		backCell.textLabel.text=@"戻る";
		backCell.textLabel.textColor=[UIColor blueColor];
		backCell.textLabel.textAlignment=UITextAlignmentCenter;
		return backCell;
	}else {
		NSMutableString *tempStr=[[NSMutableString alloc] initWithString:[[contentsArray objectAtIndex:indexPath.row] objectForKey:@"title"]];
		[tempStr replaceOccurrencesOfString:@"#" withString:@"\n" options:0 range:NSMakeRange(0, [tempStr length])];
		cell.titleLabel.text=tempStr;
		[tempStr release];
		cell.pageLabel.text=[(NSNumber *)[[contentsArray objectAtIndex:indexPath.row] objectForKey:@"page"] stringValue];
		return cell;
	}
	
    // Set up the cell...
	
    return nil;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	if(contentsViewController){
		if((indexPath.section!=0)||(controllerSection!=1)){
			contentsViewController.pagePosition=[[[contentsArray objectAtIndex:indexPath.row] objectForKey:@"page"] integerValue];
		}
		[self dismissModalViewControllerAnimated:YES];
	}else {
		contentsViewController=[[ContentsViewController alloc] initWithNibName:@"ContentsViewController" bundle:nil initialPage:[[[contentsArray objectAtIndex:indexPath.row] objectForKey:@"page"] integerValue]];
		[self presentModalViewController:contentsViewController animated:YES];
		[contentsViewController release];
		[self performSelector:@selector(delayedPopViewController) withObject:nil afterDelay:0.5];
	}
}

-(void)delayedPopViewController{
	[self.navigationController popViewControllerAnimated:NO];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
	if((indexPath.section==0)&&(controllerSection==1)){
		return NO;
	}
	return YES;
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
	if((indexPath.section==0)&&(controllerSection==1)){
		return NO;
	}
	return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [contentsArray removeObjectAtIndex:indexPath.row]; // 削除ボタンが押された行のデータを配列から削除
		[tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
		[[NSUserDefaults standardUserDefaults] setObject:contentsArray forKey:@"favoriteMemoArray"];
		
    }
	else if (editingStyle == UITableViewCellEditingStyleInsert) {
    }
}


- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
	if(fromIndexPath.section == toIndexPath.section) {
		if(contentsArray && toIndexPath.row < [contentsArray count]) {
			id item = [[contentsArray objectAtIndex:fromIndexPath.row] retain];
			[contentsArray removeObject:item];
			[contentsArray insertObject:item atIndex:toIndexPath.row];
            [item release]; 
			[[NSUserDefaults standardUserDefaults] setObject:contentsArray forKey:@"favoriteMemoArray"];
		}
	}
}

- (NSIndexPath *)tableView:(UITableView *)tableView targetIndexPathForMoveFromRowAtIndexPath:(NSIndexPath *)sourceIndexPath toProposedIndexPath:(NSIndexPath *)proposedDestinationIndexPath{
	if(sourceIndexPath.section!=proposedDestinationIndexPath.section){
		return sourceIndexPath;
	}
	return proposedDestinationIndexPath;
}

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */


/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
 
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:YES];
 }   
 else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }   
 }
 */


/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
 }
 */


/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */


- (void)dealloc {
	[contentsArray release];
    [super dealloc];
}


@end

