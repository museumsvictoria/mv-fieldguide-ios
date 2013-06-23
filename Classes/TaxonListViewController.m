//
//  TaxonListViewController.m
//  Field Guide 2010
//
//  Created by VC N on 1/08/10.
/*
 Copyright (c) 2011 Museum Victoria
 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */
//

#import "TaxonListViewController.h"
#import "DataFetcher.h"
#import "TaxonGroup.h"
//#import "AnimalListViewController.h"
//#import "FetchedAnimalListViewController.h"
#import "SimpleFetchedAnimalListViewController.h"
#import "Field_Guide_2010AppDelegate.h"

@implementation TaxonListViewController


#pragma mark -
#pragma mark View lifecycle

@synthesize rightViewReference;

- (void)viewDidLoad {
    [super viewDidLoad];
	
	taxonController = [[DataFetcher sharedInstance] fetchedResultsControllerForEntity:@"TaxonGroup" withPredicate:nil sortField:@"taxonName" ];
	

	NSError *fetchError;
	[taxonController performFetch:&fetchError];
	[taxonController retain];

    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(refresh) name:DidRefreshDatabaseNotificationName object:nil];
}

- (void)viewDidUnload {
    [super viewDidUnload];
    
    [NSNotificationCenter.defaultCenter removeObserver:self];
}



- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
	
}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

}

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


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return [[taxonController sections] count];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
	id <NSFetchedResultsSectionInfo> sectionInfo = [[taxonController sections] objectAtIndex:section];
    return [sectionInfo numberOfObjects];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Configure the cell...
    
	TaxonGroup *managedTaxon = [taxonController objectAtIndexPath:indexPath];
	[cell textLabel].text = [managedTaxon taxonName];
	NSString *path = [[NSBundle mainBundle] pathForResource:[managedTaxon.standardImage stringByDeletingPathExtension] ofType:@"png"];
	
	UIImage *theImage;
	if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
		theImage = [UIImage imageWithContentsOfFile:path];
	} else {
		theImage = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"missingthumbnail" ofType:@"jpg"]];
	}
	NSString *highlightpath = [[NSBundle mainBundle] pathForResource:[managedTaxon.highlightedImage stringByDeletingPathExtension] ofType:@"png"];
	
	UIImage *theHighlightedImage;
	if ([[NSFileManager defaultManager] fileExistsAtPath:highlightpath]) {
		theHighlightedImage = [UIImage imageWithContentsOfFile:highlightpath];
	} else {
		theHighlightedImage = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"missingthumbnail" ofType:@"jpg"]];
	}
	
	cell.imageView.image = theImage;
	cell.imageView.highlightedImage = theHighlightedImage;
	
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

#pragma mark -
#pragma mark Rotation support

// Ensure that the view controller supports rotation and that the split view can therefore show in both portrait and landscape.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}


- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation duration:(NSTimeInterval)duration {
}

#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here. Create and push another view controller.

	SimpleFetchedAnimalListViewController *newAnimalList = [[SimpleFetchedAnimalListViewController alloc] initWithNibName:@"SimpleFetchedAnimalListViewController" bundle:nil];
	newAnimalList.selectedTaxon = [taxonController objectAtIndexPath:indexPath];
	newAnimalList.title = [NSString stringWithFormat:@"%@", newAnimalList.selectedTaxon.taxonName];
	
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){ 
		newAnimalList.rightViewReference = self.rightViewReference;	
	}
	
	[self.navigationController pushViewController:newAnimalList animated:YES];
	[newAnimalList release];
}


#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc that aren't in use.
}

- (void)refresh {
    [taxonController performFetch:nil];
    [self.tableView reloadData];
}


- (void)dealloc {
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){ 
		[rightViewReference release];
	}
    
    [NSNotificationCenter.defaultCenter removeObserver:self];

    [super dealloc];
}


@end

