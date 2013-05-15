//
//  SearchTableViewController.m
//  Field Guide 2010
//
//  Created by Simon Sherrin on 9/01/11.
/*
 Copyright (c) 2011 Museum Victoria
 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */
//
#import "DataFetcher.h"
#import "TaxonGroup.h"
#import "Animal.h"
#import "Image.h"
#import "SearchTableViewController.h"


@implementation SearchTableViewController

@synthesize searchResults;

#pragma mark -
#pragma mark View lifecycle


- (void)viewDidLoad {
    [super viewDidLoad];

    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
	NSLog(@"SearchTableViewController: ViewDidLoad");
	self.navigationItem.title = NSLocalizedString(@"Search", nil);
	//searchBar = [[UISearchBar alloc] init];
	//searchBar.delegate = self;
	self.tableView.tableHeaderView = searchBar;
	[searchBar sizeToFit];
	searchBar.autocorrectionType = UITextAutocorrectionTypeNo;

}


/*
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}
*/
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
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
	NSLog(@"NumberofRowsInSection");
	NSLog(@"SearchResults:%d", [self.searchResults count]);
	if (self.searchResults == nil) {
		NSLog(@"Search Count = 1");
		return 1;
		
	}else {
		NSLog(@"SearchResults:%d", [self.searchResults count]);
		return [self.searchResults count];
	//	return 1;	
	}

	
   
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"Cell for Row");
	
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
  NSLog(@"Search Results in Cell: %d", [self.searchResults count]);
/*	if (self.searchResults != nil){
    // Configure the cell...
		NSLog(@"In Cell configuration");
    Animal *tmpAnimal = (Animal *)[self.searchResults objectAtIndex:indexPath.row] ;
	NSLog(@"Search Results in Cell: %d", indexPath.row);
		NSLog(@"Animal Name: %@", [tmpAnimal animalName]);
	//	NSLog(@"Index %d", [indexPath indexAtPosition:1]);
	//	NSLog(@"Animal Name: %@", tmpAnimal.animalName);
	//	NSLog(@"Animal Diet: %@", tmpAnimal.diet);
	[cell textLabel].text = [tmpAnimal animalName];
	if (tmpAnimal.species != nil) {
		[cell detailTextLabel].text = [NSString stringWithFormat:@"%@ %@",[[tmpAnimal genus] genusName], [tmpAnimal species]];
	} else if ([[tmpAnimal genus] genusName] != nil) {
		[cell detailTextLabel].text = [NSString stringWithFormat:@"%@ sp", [[tmpAnimal genus] genusName]];
	} else {
		[cell detailTextLabel].text = @" ";
	}
	//[cell detailTextLabel].text = [NSString stringWithFormat:@"%@ %@", [[tmpAnimal genus] genusName], [tmpAnimal species]];
	
    //[cell detailTextLabel].text = [NSString stringWithFormat:@"%@", [tmpAnimal species]];
	if ([[tmpAnimal images] count]>0) {
		//	NSLog(@"Image Name: %@",[[(Image *)[[tmpAnimal images] anyObject] filename] stringByDeletingPathExtension] );
		//	NSString *path = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%@_75",[[(Image *)[[tmpAnimal images] anyObject] filename] stringByDeletingPathExtension]] ofType:@"jpg"];
		NSString *path = [[NSBundle mainBundle] pathForResource:[tmpAnimal.thumbnail stringByDeletingPathExtension] ofType:@"jpg"];
		
		UIImage *theImage;
		if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
			theImage = [UIImage imageWithContentsOfFile:path];
		} else {
			theImage = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"missingthumbnail" ofType:@"jpg"]];
		}
		
		
		cell.imageView.image = theImage;
		//cell.imageView.contentMode =  UIViewContentModeScaleToFill;
		
	}else {
		cell.imageView.image = nil;
	}
    }
	else {
	*/	NSLog(@"Initial Search Cell");
		cell.textLabel.text = @"Search box...should be a search bar up there";
	//}

	return cell;
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
        // Delete the row from the data source.
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
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


#pragma mark -
#pragma mark Table view delegate

-(NSIndexPath *) tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath{
	NSLog(@"WillSelectRow");
if (letUserSelectRow) {
	return indexPath;
}else {
	return nil;
}
	
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here. Create and push another view controller.
    /*
    <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
    // ...
    // Pass the selected object to the new view controller.
    [self.navigationController pushViewController:detailViewController animated:YES];
    [detailViewController release];
    */
}

#pragma mark SearchHandling

-(void) searchBarTextDidBeginEditing: (UISearchBar *) theSearchBar
{
	NSLog(@"SearchBarTextDidBeginEditing");
	searching = YES;
	letUserSelectRow = NO;
	self.tableView.scrollEnabled = YES;
//	self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneSearching_Clicked:)] autorelease];
	
}

- (void) searchBar: (UISearchBar *) theSearchBar txtDidChange:(NSString *)searchText{
	NSLog(@"Search Text Did Change");
	//[searchResults removeAllObjects];
	
	if ([searchText length] > 0) {
		searching = YES;
		letUserSelectRow = YES;
		[self searchAnimals];
		
	}
	else {
		searching = NO;
		letUserSelectRow = NO;
		self.tableView.scrollEnabled = YES;
	}

	[self.tableView reloadData];
}


- (void) searchBarSearchButtonClicked:(UISearchBar *) theSearchBar{

	[self searchAnimals];	

	[self.tableView reloadData];

}

- (void) searchAnimals {
//	NSManagedObjectContext *currentContext = [[FlickrFetcher sharedInstance] managedObjectContext];	
//	NSPredicate *searchPredicate = [NSPredicate predicateWithFormat:@"animalName like '*%@*'", searchBar.text];

	NSPredicate *searchPredicate = [NSPredicate predicateWithFormat:@"animalName='Brolga'"];
	self.searchResults = [[DataFetcher sharedInstance] fetchManagedObjectsForEntity:@"Animal" withPredicate:searchPredicate];

//	self.searchResults = currentResults;
}

- (void) doneSearching_Clicked:(id) sender{
	NSLog(@"doneSearching");
	searchBar.text =@"";
	[searchBar resignFirstResponder];
	letUserSelectRow = YES;
	searching = NO;
	//self.navigationItem.rightBarButtonItem = nil;
	self.tableView.scrollEnabled = YES;
	
	[self.tableView reloadData];
	
}

- (CGSize)contentSizeForViewInPopover{

		return CGSizeMake(320,480);		
	}
	
#pragma mark -


#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
	
}


- (void)dealloc {
	[searchBar release];
    [super dealloc];
}


@end

