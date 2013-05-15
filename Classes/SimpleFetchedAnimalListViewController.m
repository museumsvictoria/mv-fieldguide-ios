//
//  SimpleFetchedAnimalListViewController.m
//  Field Guide 2010
//
//  Created by VC N on 1/03/11.
/*
 Copyright (c) 2011 Museum Victoria
 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */
//

#import "SimpleFetchedAnimalListViewController.h"
//#import "AnimalListViewController.h"
#import "TaxonGroup.h"
#import "Animal.h"


#import "AnimalDetailiPad.h"
#import "SubTaxonGroup.h"
#import "AnimalDetailsiPhoneViewController.h"
#import "DataFetcher.h"

@implementation SimpleFetchedAnimalListViewController


#pragma mark -
#pragma mark View lifecycle

@synthesize selectedTaxon, rightViewReference;

- (void)viewDidLoad {
    [super viewDidLoad];
	//NSLog(@"SFALCV:viewDidLoad");
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
		self.clearsSelectionOnViewWillAppear = NO;
	}
	NSString *searchTerm = [NSString stringWithFormat:@"taxon.taxonName ='%@'",selectedTaxon.taxonName];
	NSPredicate *searchPredicate = [NSPredicate predicateWithFormat:searchTerm];
	animalController = [[DataFetcher sharedInstance] fetchedResultsControllerForEntity:@"Animal" withPredicate:searchPredicate sortField:@"animalName" sectionNameKeyPath:@"subTaxon"  ];
	

	NSError *fetchError;
	[animalController performFetch:&fetchError];
	[animalController retain];
	
}



- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
	[self.tableView scrollToNearestSelectedRowAtScrollPosition:UITableViewScrollPositionNone animated:NO];
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
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
	    tableView.rowHeight = 75;
	NSLog(@"Number of Sections: %d",[[animalController sections] count] );
        return [[animalController sections] count];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
   	id <NSFetchedResultsSectionInfo> sectionInfo = [[animalController sections] objectAtIndex:section];
	NSLog (@"Number of Rows in Section: %d", [sectionInfo numberOfObjects]);
    return [sectionInfo numberOfObjects];
}

- (NSString *) tableView:(UITableView *)sender titleForHeaderInSection:(NSInteger)section {
		id <NSFetchedResultsSectionInfo> sectionInfo = [[animalController sections] objectAtIndex:section];
		return [sectionInfo name];
	
}


-(void) configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath{
	Animal *tmpAnimal = [animalController objectAtIndexPath:indexPath];
	[cell textLabel].text = [tmpAnimal animalName];
	[cell textLabel].font = [UIFont fontWithName:@"Helvetica-Bold" size:16];
	[cell textLabel].textColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:1];
	if ([tmpAnimal scientificName] != nil && [tmpAnimal scientificName]!=@" ") {
		[cell detailTextLabel].text = [tmpAnimal scientificName];
		[cell detailTextLabel].font = [UIFont fontWithName:@"Helvetica-Oblique" size:14];
		[cell detailTextLabel].textColor = [UIColor colorWithRed:0.258 green:.258 blue:.258 alpha:1];	
	} else{
		if (tmpAnimal.family!=nil && tmpAnimal.family!=@"") {
			[cell detailTextLabel].text = [NSString stringWithFormat:@"Family: %@", tmpAnimal.family];
			[cell detailTextLabel].font = [UIFont fontWithName:@"Helvetica" size:14];
			[cell detailTextLabel].textColor = [UIColor colorWithRed:0.258 green:.258 blue:.258 alpha:1];	
		} else {
			if (tmpAnimal.order!=nil && tmpAnimal.order!=@"") {
				[cell detailTextLabel].text = [NSString stringWithFormat:@"Order: %@", tmpAnimal.order];
				[cell detailTextLabel].font = [UIFont fontWithName:@"Helvetica" size:14];
				[cell detailTextLabel].textColor = [UIColor colorWithRed:0.258 green:.258 blue:.258 alpha:1];	
			}else {
				if (tmpAnimal.animalClass!=nil && tmpAnimal.animalClass!=@"") {
					[cell detailTextLabel].text = [NSString stringWithFormat:@"Class: %@", tmpAnimal.animalClass];
					[cell detailTextLabel].font = [UIFont fontWithName:@"Helvetica" size:14];
					[cell detailTextLabel].textColor = [UIColor colorWithRed:0.258 green:.258 blue:.258 alpha:1];							
				}else {
					[cell detailTextLabel].text = [NSString stringWithFormat:@"Phylum: %@", tmpAnimal.phylum];
					[cell detailTextLabel].font = [UIFont fontWithName:@"Helvetica" size:14];
					[cell detailTextLabel].textColor = [UIColor colorWithRed:0.258 green:.258 blue:.258 alpha:1];
				}
			}
			
		}
		
		
	}
	
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


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
			cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Configure the cell...
    [self configureCell:cell atIndexPath:indexPath];
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

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}
#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	Animal *tmpAnimal  = [animalController objectAtIndexPath:indexPath];	
	
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
		
	{
		NSLog( @"Animal Selected %@", tmpAnimal.animalName);
		rightViewReference.currentTaxonLabel = selectedTaxon.taxonName;
		rightViewReference.animal  = tmpAnimal;
		
	}
	else{
		// Navigation logic may go here. Create and push another view controller.
		/* Commented out 30th January 2011
		 AnimalDetailImage *detailViewController = [[AnimalDetailImage alloc] initWithNibName:@"AnimalDetailImage" bundle:nil];
		 // ...
		 // Pass the selected object to the new view controller.
		 detailViewController.animal = tmpAnimal;
		 detailViewController.title = tmpAnimal.animalName;
		 [self.navigationController pushViewController:detailViewController animated:YES];
		 [detailViewController release];
		 */
		//New iPhone View
		AnimalDetailsiPhoneViewController *detailViewController = [[AnimalDetailsiPhoneViewController alloc] initWithNibName:@"AnimalDetailsiPhoneViewController" bundle:nil];
		detailViewController.animal = tmpAnimal;
		detailViewController.title = tmpAnimal.animalName;
		[self.navigationController pushViewController:detailViewController animated:YES];
		[detailViewController release];
	}
}


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
	[animalController release];
}


- (void)dealloc {
    [super dealloc];
}


@end

