    //
//  AnimalDetailiPad.m
//  Field Guide 2010
//
//  Created by Simon Sherrin on 5/09/10.
/*
 Copyright (c) 2011 Museum Victoria
 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */
//

#import "AnimalDetailiPad.h"
#import "Animal.h"
#import "Image.h"
#import "AnimalImageController.h"
#import "AudioListViewController.h"
#import "TaxonGroup.h"
#import "CustomSearchViewController.h"
#import "MVPagingScollView.h"
#import "CommonName.h"
#import "VariableStore.h"

@interface AnimalDetailiPad ()
@property (nonatomic, retain) UIPopoverController *popoverController;

@end


@implementation AnimalDetailiPad
@synthesize toolbar, popoverController, animal, detailDescriptionLabel, titleLabel, mainImage, markingsText, identifyingText, detailsHTML, player, commonName, scientificName, otherCommonNames ;
@synthesize imagePagingControl, imageHolder, animalImages, localAnimalImageController, animalImageControllers, playAudioButton, mapImage, biologyText, audioCredit,contentDetailHolder, startScreen;
@synthesize raiseDetails, detailsView, animalHTMLDetails, currentTaxonLabel, imageCredit, imageView, imageTextLayoutControl, parentSplitView;
@synthesize activityIndicator, progressLabel, orientationLock, progressView;

/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}
*/

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.*/
- (void)viewDidLoad {
    [super viewDidLoad];

	
	// Add for welcome screen. When user taps anywhere on Welcome screen, animal button tapped
	UITapGestureRecognizer *singleFingerTap = [[UITapGestureRecognizer alloc]
											   initWithTarget:self action:@selector(handleSingleTap:)];
    singleFingerTap.numberOfTapsRequired = 1;
   	[startButton addGestureRecognizer:singleFingerTap];
    [singleFingerTap release];
	
	//self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
	self.animalImageControllers = [[NSMutableArray alloc] init];
	contentDetailHolder.contentSize = CGSizeMake(contentDetailHolder.frame.size.width, 387);
	toolbar.tintColor  = [VariableStore sharedInstance].toolbarTint;
	titleLabel.text = NSLocalizedString(@"Welcome", nil) ;
	
	//Setup Popover
	audioPopoverViewController = [[AudioListViewController alloc] init];
	audioPopoverController = [[UIPopoverController alloc] initWithContentViewController:audioPopoverViewController];
	audioPopoverController.passthroughViews = [NSArray arrayWithObject:toolbar];
	searchViewController = [[CustomSearchViewController alloc] init];
	searchViewController.rightViewReference = self;
	searchPopoverController = [[UIPopoverController alloc] initWithContentViewController:searchViewController];
	searchPopoverController.passthroughViews =[NSArray arrayWithObject:toolbar];
	detailsTopLeft = 551;
	detailsViewRaised = NO;
	currentTaxonLabel = NSLocalizedString(@"Animals", nil) ;
	//self.startScreen.contentSize = self.startScreen.frame.size;
	aboutHTML.opaque = NO;
	aboutHTML.backgroundColor = [UIColor clearColor];
	welcomeHTML.opaque = NO;
	welcomeHTML.backgroundColor = [UIColor clearColor];
	NSString *path = [[NSBundle mainBundle] bundlePath];
	NSURL *baseURL = [NSURL fileURLWithPath:path];
	NSString *aboutPath = [[NSBundle mainBundle] pathForResource:@"about" ofType:@"html"];
	NSString *welcomePath = [[NSBundle mainBundle] pathForResource:@"welcome" ofType:@"html"];
	NSMutableString *aboutHTMLCode = [[NSMutableString alloc] initWithContentsOfFile:aboutPath];
	NSMutableString *welcomeHTMLCode = [[NSMutableString alloc] initWithContentsOfFile:welcomePath];
	[aboutHTML loadHTMLString:aboutHTMLCode	baseURL:baseURL];
	[welcomeHTML loadHTMLString:welcomeHTMLCode baseURL:baseURL];
	// 9:30pm 24/01/11 Scroll View Test
	

	testMVPagingScrollView = [[MVPagingScollView alloc] initWithNibName:@"MVPagingScollView" bundle:nil];
	CGRect imageViewFrame = self.imageView.frame;

	NSLog(@"FrameSize:%f,%f", imageViewFrame.size.width, imageViewFrame.size.height);
	NSLog(@"OriginSize:%f,%f", imageViewFrame.origin.x, imageViewFrame.origin.y);
	imageViewFrame.origin.x = 0;
	imageViewFrame.origin.y = 0;
	testMVPagingScrollView.view.frame = imageViewFrame;
	testMVPagingScrollView.view.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
	[self.imageView addSubview:testMVPagingScrollView.view];
	[aboutHTMLCode release]; //added 26/02/2011
	[welcomeHTMLCode release]; // added 26/02/2011
}


#pragma mark -
#pragma mark Managing the detail item

/*
 When setting the detail item, update the view and dismiss the popover controller if it's showing.
 */
- (void)setAnimal:(Animal *)newAnimal {
    NSLog(@"Set Animal");
		//startScreen.hidden = YES;	
	aboutHTML.hidden = YES;
	welcomeHTML.hidden =YES;
	webBackImage.hidden = YES;
	startButton.hidden = YES; //remove tap to begin gesture recogniser
	
	if (animal != newAnimal) {
		[animal release];
		animal = [newAnimal retain];
        // Update the view.
        [self configureView];
	}
    
	[self dismissAllPopovers];
}

-(void) dismissAllPopovers{
	if (popoverController != nil) {
        [popoverController dismissPopoverAnimated:YES];
    }		
	if (audioPopoverController !=nil) {
		[audioPopoverController dismissPopoverAnimated:YES];
	}
	if (searchPopoverController !=nil) {
		//Hide search popover
		[searchPopoverController dismissPopoverAnimated:YES];
	}
	
}

-(void) handleSingleTap:(UIGestureRecognizer *)sender{
	startButton.hidden = YES;
	[startButton removeGestureRecognizer:sender];
	[self touchToBegin:sender];
	
	
}

- (void) touchToBegin:(id)sender{

	startButton.hidden = YES;
	UIBarButtonItem *tmpCast = (UIBarButtonItem *) [[toolbar items] objectAtIndex:0];

	[popoverController presentPopoverFromBarButtonItem:tmpCast permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];	
}

#pragma mark Audio
- (BOOL)prepAudio
{

	NSError *error;
	NSString *tmpAudioLocation;
	NSArray *tmpArray = [[animal audios] allObjects];
	if ( [tmpArray count] > 0 )
	{
	
	self.audioCredit.text = [[tmpArray objectAtIndex:0] credit];
	tmpAudioLocation = [[NSBundle mainBundle] pathForResource:[[[tmpArray objectAtIndex:0]  filename] stringByDeletingPathExtension] ofType:@"mp3"];
	if (![[NSFileManager defaultManager] fileExistsAtPath:tmpAudioLocation]) return NO;
	NSLog(@"Audio location %@", tmpAudioLocation);
	self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:tmpAudioLocation] error:&error];
	if (!self.player)
	{
		NSLog(@"Error: %@", [error localizedDescription]);
		return NO;
	}
	
	[self.player prepareToPlay];
	NSLog(@"After player prepare");
		return YES;
	}
	return NO;
}

- (void)playAudio:(id)sender{
		NSLog(@"Trying to play audio");
	if (self.player) [self.player play];
}

- (void) showAudio:(id)sender{
	if (searchPopoverController !=nil) {
		//Hide search popover
		[searchPopoverController dismissPopoverAnimated:YES];
	}
	if (popoverController !=nil) {
		[popoverController dismissPopoverAnimated:YES];
	}
	UIBarButtonItem *tmpCast = (UIBarButtonItem *)sender;
	[audioPopoverController setPopoverContentSize:[audioPopoverViewController contentSizeForViewInPopover]];

	[audioPopoverController presentPopoverFromBarButtonItem:tmpCast permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
}

#pragma mark -

#pragma mark Search Popover

- (void) showSearch:(id)sender{
	
	if (audioPopoverController !=nil) {
		//Hide audio popover
		[audioPopoverController dismissPopoverAnimated:YES];
	}
	if (popoverController !=nil) {
		[popoverController dismissPopoverAnimated:YES];
	}
	UIBarButtonItem *tmpCast = (UIBarButtonItem *)sender;
	[searchPopoverController presentPopoverFromBarButtonItem:tmpCast permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
	
}

#pragma mark -

- (void)configureView {
    // Update the user interface for the detail item.
	startButton.hidden = YES;
    toolbar.tintColor = [VariableStore sharedInstance].toolbarTint;
	titleLabel.text = animal.animalName;
	commonName.text = animal.animalName;
	//if portrait mode and first button is popover
	if (self.interfaceOrientation== UIInterfaceOrientationPortraitUpsideDown || self.interfaceOrientation == UIInterfaceOrientationPortrait)  {
		NSLog(@"CurrentTaxonLabel:%@", currentTaxonLabel);
		UIBarButtonItem *barButtonItem = [[toolbar items] objectAtIndex:0];
		if ([currentTaxonLabel length] >13) {
			barButtonItem.title = [currentTaxonLabel stringByReplacingCharactersInRange:NSMakeRange(10, [currentTaxonLabel length]-10) withString:@"..."];
		}else{
			
		barButtonItem.title = currentTaxonLabel;
		}
	}
	//Set up Scientific Name;
	if (animal.species != nil) {
		scientificName.text = [NSString stringWithFormat:@"%@ %@",[animal genusName], [animal species]];
	} else if ([animal genusName] != nil) {
		scientificName.text = [NSString stringWithFormat:@"%@ sp", [animal genusName] ];
	} else {
		scientificName.text = @" ";
	}
	
	
	//Set Up images controller
	
	self.animalImages = [animal sortedImages];
	imagePagingControl.numberOfPages = [animalImages count];
	imagePagingControl.currentPage = 0;

	NSLog(@"Before Image Controller Init");
	[testMVPagingScrollView newImageSet:self.animalImages];
	
	//Set Image Credit to First Page
	imageCredit.text = [NSString stringWithFormat:NSLocalizedString(@"Credit: %@",nil), [(Image *)[animalImages objectAtIndex:0] credit]];
	
	NSString *path = [[NSBundle mainBundle] bundlePath];
	NSURL *baseURL = [NSURL fileURLWithPath:path];
//	NSLog([self constructHTML]);
	NSLog(@"Set up Web Details");
	animalHTMLDetails.opaque = NO;
	animalHTMLDetails.backgroundColor = [UIColor clearColor];
	NSLog(@"Load HTML into WebView");
	//NSString *baseHTMLCode = @"<html><body style='background-color: transparent; color:white;'><%genus%><%species%><br/>Now there's just a question of freeing the order.</body></html>";
	//Code for checking for design versions
	NSString *htmlPath;
	NSLog(@"ID: %@", animal.catalogID);
	if ([[NSFileManager defaultManager] fileExistsAtPath:[[NSBundle mainBundle] pathForResource:animal.catalogID ofType:@"html"]]) {
		 htmlPath = [[NSBundle mainBundle] pathForResource:animal.catalogID ofType:@"html"];
	}else {
		htmlPath = [[NSBundle mainBundle] pathForResource:@"template-ipad" ofType:@"html"];
	}
	
        
	NSMutableString *baseHTMLCode = [[NSMutableString alloc] initWithContentsOfFile:htmlPath];
	
    //Common Names is a set of strings
	NSMutableString *constructedCommonNames = [NSMutableString stringWithCapacity:1];
	
	for (CommonName *tmpCommonName in animal.commonNames)
	{
		[constructedCommonNames appendFormat:@"%@, ",tmpCommonName.commonName];
		
	}
	if ([constructedCommonNames length]>0){
		[constructedCommonNames deleteCharactersInRange:NSMakeRange([constructedCommonNames length]-2, 2)];
	}
    
    //Replace template fields in HTML with values.
	[self htmlTemplate:baseHTMLCode keyString:@"commonNames" replaceWith:[[constructedCommonNames copy] autorelease]];
	[self htmlTemplate:baseHTMLCode keyString:@"animalName" replaceWith:animal.animalName];
	[self htmlTemplate:baseHTMLCode keyString:@"scientificName" replaceWith:[animal scientificName]];
	[self htmlTemplate:baseHTMLCode keyString:@"identifyingCharacteristics" replaceWith:animal.identifyingCharacteristics];
	[self htmlTemplate:baseHTMLCode keyString:@"distinctive" replaceWith:animal.distinctive];
	[self htmlTemplate:baseHTMLCode keyString:@"biology" replaceWith:animal.biology];
	[self htmlTemplate:baseHTMLCode keyString:@"habitat" replaceWith:animal.habitat];
	[self htmlTemplate:baseHTMLCode keyString:@"mapimage" replaceWith:animal.mapImage];
	[self htmlTemplate:baseHTMLCode keyString:@"distribution" replaceWith:animal.distribution];
	[self htmlTemplate:baseHTMLCode keyString:@"phylum" replaceWith:animal.phylum];
	[self htmlTemplate:baseHTMLCode keyString:@"class" replaceWith:animal.animalClass];
	[self htmlTemplate:baseHTMLCode keyString:@"order" replaceWith:animal.order];
	[self htmlTemplate:baseHTMLCode keyString:@"family" replaceWith:animal.family];
	[self htmlTemplate:baseHTMLCode keyString:@"genus" replaceWith:animal.genusName];
	[self htmlTemplate:baseHTMLCode keyString:@"species" replaceWith:animal.species];
	[self htmlTemplate:baseHTMLCode keyString:@"lcs" replaceWith:animal.lcs];
	[self htmlTemplate:baseHTMLCode keyString:@"ncs" replaceWith:animal.ncs];
	[self htmlTemplate:baseHTMLCode keyString:@"wcs" replaceWith:animal.wcs];
	[self htmlTemplate:baseHTMLCode keyString:@"native" replaceWith:animal.nativestatus];
	[self htmlTemplate:baseHTMLCode keyString:@"bite" replaceWith:animal.bite];
	[self htmlTemplate:baseHTMLCode keyString:@"diet" replaceWith:animal.diet];

	[animalHTMLDetails loadHTMLString:baseHTMLCode baseURL:baseURL];
	[baseHTMLCode release];

	
	//Enable or disable audio buttons

	if ([[animal audios] count] > 0){
		playAudioButton.enabled = YES;	
		audioCredit.hidden = YES;
		audioPopoverViewController.audioFilesArray = (NSArray *)[[animal audios] allObjects];
	}else {
		playAudioButton.enabled = NO;
		//playAudioButton.hidden = YES;
		audioCredit.hidden = YES;
	}

}


#pragma mark -

#pragma mark infoView
- (void) showInfoView:(id)sender{
	startButton.hidden = YES;
	if (aboutHTML.hidden) {
	titleLabel.text =NSLocalizedString(@"About", nil);
	aboutHTML.hidden = NO;
	welcomeHTML.hidden = YES;
	webBackImage.hidden = NO;
	}else {
		if (animal != nil) {
		titleLabel.text = animal.animalName;			
		}else {
			titleLabel.text = NSLocalizedString(@"Welcome",nil);
			welcomeHTML.hidden = NO;
		}
		aboutHTML.hidden = YES;
		webBackImage.hidden = YES;
	}

	
	
}

-(void) makeToolbarButtonsInactive{
	for (id toolbarItem in [toolbar items]) {
		if ([toolbarItem respondsToSelector:@selector(enabled)]) {
			
			UIBarButtonItem *tempButton = (UIBarButtonItem *)toolbarItem;
			tempButton.enabled = NO;
		}
	}



}

-(void) makeToolbarButtonsActive{
	for (id toolbarItem in [toolbar items]) {
		if ([toolbarItem respondsToSelector:@selector(enabled)]) {
			
			UIBarButtonItem *tempButton = (UIBarButtonItem *)toolbarItem;
			tempButton.enabled = YES;
		}
	}
		 self.playAudioButton.enabled = NO;
}

-(void) hideProgress{

	progressLabel.hidden = YES;
	toolbar.userInteractionEnabled = YES;
	progressView.hidden = YES;
}



-(void) updateProgressBar:(float)loadprogress{
	progressView.progress = loadprogress;
}

#pragma mark -
	

#pragma mark Split view support

-(BOOL)isFullScreen{
	if (imageTextLayoutControl.selectedSegmentIndex ==2) {
		return YES;
	}else {
		return NO;
	}

	
}

- (void)splitViewController: (UISplitViewController*)svc willHideViewController:(UIViewController *)aViewController withBarButtonItem:(UIBarButtonItem*)barButtonItem forPopoverController: (UIPopoverController*)pc {
    
	aViewController.navigationController.navigationBar.tintColor  = [VariableStore sharedInstance].toolbarTint;
	if ([currentTaxonLabel length] >13) {
		barButtonItem.title = [currentTaxonLabel stringByReplacingCharactersInRange:NSMakeRange(10, [currentTaxonLabel length]-10) withString:@"..."];
	}else{
		
		barButtonItem.title = currentTaxonLabel;
	}
	NSLog(@"CurrentTaxonLabel:%@", currentTaxonLabel);
    NSMutableArray *items = [[toolbar items] mutableCopy];
    [items insertObject:barButtonItem atIndex:0];
    [toolbar setItems:items animated:YES];
    [items release];
    self.popoverController = pc;
}

//Called when the navigation Popover is about to be displayed UISplitView Delegate Method
- (void)splitViewController:(UISplitViewController*)svc popoverController:(UIPopoverController*)pc willPresentViewController:(UIViewController *)aViewController{
	if (searchPopoverController !=nil) {
		//Hide search popover
		[searchPopoverController dismissPopoverAnimated:YES];
	}
	if (audioPopoverController !=nil) {
		[audioPopoverController dismissPopoverAnimated:YES];
	}

	
}

// Called when the view is shown again in the split view, invalidating the button and popover controller.
- (void)splitViewController: (UISplitViewController*)svc willShowViewController:(UIViewController *)aViewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem {
    
    NSMutableArray *items = [[toolbar items] mutableCopy];
    [items removeObjectAtIndex:0];
    [toolbar setItems:items animated:YES];
    [items release];
    self.popoverController = nil;
	aViewController.navigationController.navigationBar.barStyle = UIBarStyleDefault;
	aViewController.navigationController.navigationBar.tintColor  = [VariableStore sharedInstance].toolbarTint;
}

- (void)willHideViewController:(UIViewController *)aViewController withBarButtonItem:(UIBarButtonItem*)barButtonItem forPopoverController: (UIPopoverController*)pc {
    
	aViewController.navigationController.navigationBar.tintColor  = [VariableStore sharedInstance].toolbarTint;
    barButtonItem.title = currentTaxonLabel;
	NSLog(@"CurrentTaxonLabel:%@", currentTaxonLabel);
    NSMutableArray *items = [[toolbar items] mutableCopy];
    [items insertObject:barButtonItem atIndex:0];
    [toolbar setItems:items animated:YES];
    [items release];
    self.popoverController = pc;
}


// Called when the view is shown again in the split view, invalidating the button and popover controller.
- (void) willShowViewController:(UIViewController *)aViewController{
    if (self.popoverController !=nil) {
		[self.popoverController dismissPopoverAnimated:YES];
	}
	
    NSMutableArray *items = [[toolbar items] mutableCopy];
    [items removeObjectAtIndex:0];
    [toolbar setItems:items animated:YES];
    [items release];
    self.popoverController = nil;
	aViewController.navigationController.navigationBar.barStyle = UIBarStyleDefault;
	aViewController.navigationController.navigationBar.tintColor  = [VariableStore sharedInstance].toolbarTint;
}

- (void) showNavigationPopover:(id)sender{
	if (searchPopoverController !=nil) {
		//Hide search popover
		[searchPopoverController dismissPopoverAnimated:YES];
	}
	if (audioPopoverController !=nil) {
		[audioPopoverController dismissPopoverAnimated:YES];
	}
	UIBarButtonItem *tmpCast = (UIBarButtonItem *)sender;
	[self.popoverController presentPopoverFromBarButtonItem:tmpCast permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
	
}


#pragma mark ImageScrollView support

- (void)scrollViewDidScroll:(UIScrollView *)sender {
    // We don't want a "feedback loop" between the UIPageControl and the scroll delegate in
    // which a scroll event generated from the user hitting the page control triggers updates from
    // the delegate method. We use a boolean to disable the delegate logic when the page control is used.
    if (pageControlUsed) {
        // do nothing - the scroll was initiated from the page control, not the user dragging
        return;
    }
	
    // Switch the indicator when more than 50% of the previous/next page is visible
    CGFloat pageWidth = imageHolder.frame.size.width;
   // NSLog(@"Frame Width: %f", imageHolder.frame.size.width);

	int page = floor((imageHolder.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
	
	//check bounds first
	if (page >= 0 && page <= ([animalImages count]-1) ) //avoid trying to call outside the range of the array.
	{
		
		imagePagingControl.currentPage = page;
	//Need to update credit in label
	imageCredit.text = [NSString stringWithFormat:NSLocalizedString(@"Credit: %@",nil), [(Image *)[animalImages objectAtIndex:page] credit]]; 
	}

	
    // A possible optimization would be to unload the views+controllers which are no longer visible
}

// At the begin of scroll dragging, reset the boolean used when scrolls originate from the UIPageControl
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    pageControlUsed = NO;
}

// At the end of scroll animation, reset the boolean used when scrolls originate from the UIPageControl
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    pageControlUsed = NO;
}

- (IBAction)changePage:(id)sender{
	//int page = imagePagingControl.currentPage;	// update the scroll view to the appropriate page
	/* 9:30pm 24/01/11 Commented out for Scroll Page text 
    CGRect frame = imageHolder.frame;
    NSLog(@"Frame Width: %f", frame.size.width);
	NSLog(@"Origin:%f", frame.size.width * page);
	frame.origin.x = frame.size.width * page;
    frame.origin.y = 0;
    [imageHolder scrollRectToVisible:frame animated:YES];
	NSLog(@"ContentOffset:%f, ContentSize:%f", imageHolder.contentOffset.x, imageHolder.contentSize.width);
    imageCredit.text = [NSString stringWithFormat:@"Credit: %@", [(Image *)[animalImages objectAtIndex:page] credit]]; 
	// Set the boolean used when scrolls originate from the UIPageControl. See scrollViewDidScroll: above.
    pageControlUsed = YES;
	*/
}
#pragma mark -
#pragma mark HTML Handlers

/*- (NSMutableString*)constructHTML{
	NSLog(@"Start constructHTML");	
	NSMutableString	*constructedHTML = [[NSMutableString alloc] initWithString:[self loadHTML]];
	NSLog(@"Start modifyHTL");
	[self htmlTemplate:constructedHTML keyString:@"identifyingCharacteristics" replaceWith:animal.identifier];
	[self htmlTemplate:constructedHTML keyString:@"distinctive" replaceWith:animal.distinctive];
	[self htmlTemplate:constructedHTML keyString:@"biology" replaceWith:animal.biology];
	[self htmlTemplate:constructedHTML keyString:@"habitat" replaceWith:animal.habitat];
	[self htmlTemplate:constructedHTML keyString:@"mapimage" replaceWith:animal.mapImage];
	[self htmlTemplate:constructedHTML keyString:@"phylum" replaceWith:animal.genus.family.order.animalClass.phylum.phylumName];
	[self htmlTemplate:constructedHTML keyString:@"class" replaceWith:animal.genus.family.order.animalClass.animalClassName];
	[self htmlTemplate:constructedHTML keyString:@"order" replaceWith:animal.genus.family.order.orderName];
	[self htmlTemplate:constructedHTML keyString:@"family" replaceWith:animal.genus.family.familyName];
	[self htmlTemplate:constructedHTML keyString:@"genus" replaceWith:animal.genus.genusName];
	[self htmlTemplate:constructedHTML keyString:@"species" replaceWith:animal.species];
	
	

	[constructedHTML autorelease];	
	
	return constructedHTML;
	
}
*/
- (NSMutableString*)loadHTML{
//	NSLog(@"Start loadHTML");
	NSString *htmlPath = [[NSBundle mainBundle] pathForResource:@"template-ipad" ofType:@"html"];

	NSMutableString *loadedHTML = [[NSMutableString alloc] initWithContentsOfFile:htmlPath];
	[htmlPath release];
	[loadedHTML autorelease];
	return loadedHTML;
	
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {

	if (navigationType == UIWebViewNavigationTypeLinkClicked) {
		[[UIApplication sharedApplication] openURL:[request mainDocumentURL]];
		return NO;
	}
	
	return YES;
}

-(void) htmlTemplate:(NSMutableString *)templateString keyString:(NSString *)stringToReplace replaceWith:(NSString *)replacementString{
	
	if (replacementString != nil && [replacementString length] > 0) {
		[templateString replaceOccurrencesOfString:[NSString stringWithFormat:@"<%%%@%%>",stringToReplace] withString:replacementString options:0 range:NSMakeRange(0, [templateString length])];
		[templateString	replaceOccurrencesOfString:[NSString stringWithFormat:@"<%%%@Class%%>",stringToReplace] withString:@" " options:0 range:NSMakeRange(0, [templateString length])];
	}else {
		[templateString replaceOccurrencesOfString:[NSString stringWithFormat:@"<%%%@%%>",stringToReplace] withString:@"" options:0 range:NSMakeRange(0, [templateString length])];
		[templateString	replaceOccurrencesOfString:[NSString stringWithFormat:@"<%%%@Class%%>",stringToReplace] withString:@"invisible" options:0 range:NSMakeRange(0, [templateString length])];

	}

}

#pragma mark -
#pragma mark Rotation support

// Ensure that the view controller supports rotation and that the split view can therefore show in both portrait and landscape.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	NSLog(@"AnimalDetail : shouldAutoRotate");
    return !orientationLock;
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation{
	NSLog(@"Animal Detail: didRotateFromInterface");

		[animalHTMLDetails reload];
}
	
- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
	NSLog(@"AnimalDetailiPad:willRotateToInterfaceOrientation");
	[testMVPagingScrollView willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
	//[animalHTMLDetails reload];
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation duration:(NSTimeInterval)duration {

	CGRect tmpStartContents = self.startScreen.frame;
	tmpStartContents.size.height = 960;
	self.startScreen.contentSize = tmpStartContents.size;

	
	//Resize Interface Layout
	CGRect currentDetailsRect = detailsView.frame;
	CGRect currentImageRect = imageView.frame;
	CGRect currentParentViewRect = self.view.frame;
	
	if (imageTextLayoutControl.selectedSegmentIndex == 0) {
		currentDetailsRect.origin.y = 44;
		currentDetailsRect.size.height = currentParentViewRect.size.height - 44;

	}else {
		if (imageTextLayoutControl.selectedSegmentIndex==1) {
			currentDetailsRect.origin.y = detailsTopLeft;
			currentDetailsRect.size.height = currentParentViewRect.size.height - detailsTopLeft;
			currentImageRect.size.height = detailsTopLeft - 44;
		}else {
			currentDetailsRect.origin.y = currentParentViewRect.size.height;
			currentImageRect.size.height = currentParentViewRect.size.height-44;
			currentParentViewRect.origin.x =0;
		}
		
	}
	detailsView.frame = currentDetailsRect;
	imageView.frame = currentImageRect;
	self.view.frame = currentParentViewRect;
	[testMVPagingScrollView willAnimateRotationToInterfaceOrientation:interfaceOrientation duration:duration];


	
}

- (void)changeDetailsView:(id)sender{

		//Can Change Position
		CGRect currentDetailsRect = detailsView.frame;
		CGRect currentImageRect = imageView.frame;
		CGRect currentParentViewRect = self.view.frame;
		
		if (imageTextLayoutControl.selectedSegmentIndex == 0) {
			currentDetailsRect.origin.y = 44;
			currentDetailsRect.size.height = currentParentViewRect.size.height - 44;

		}else {
			if (imageTextLayoutControl.selectedSegmentIndex==1) {
				currentDetailsRect.origin.y = detailsTopLeft;
				currentDetailsRect.size.height = currentParentViewRect.size.height - detailsTopLeft;
				currentImageRect.size.height = detailsTopLeft - 44;
			}else {
				currentDetailsRect.origin.y = currentParentViewRect.size.height;
				currentImageRect.size.height = currentParentViewRect.size.height-44;

			}

		}

	 
	 [UIView animateWithDuration:0.1 animations:^{
		detailsView.frame = currentDetailsRect;
		 imageView.frame = currentImageRect;
		 self.view.frame = currentParentViewRect;
			
		}];

			NSLog(@"New origin: %f", currentDetailsRect.origin.y);
		
	
}

-(void)layoutControlChanged:(id)sender{

	[self dismissAllPopovers];
	UISegmentedControl *layoutControl = (UISegmentedControl *)sender;
	CGRect currentDetailsRect = detailsView.frame;
	CGRect currentParentViewRect = self.view.bounds;
	CGRect currentImageRect = imageView.frame;
	CGRect currentParentFrame = self.view.frame;
	BOOL imageViewWidthChanged;
	
	if (layoutControl.selectedSegmentIndex == 0) {
		//Full Text Display
		currentDetailsRect.origin.y = 44;
		currentDetailsRect.size.height = currentParentViewRect.size.height - 44;

	}else {
		if (layoutControl.selectedSegmentIndex == 1) {
			//standard layout
			currentDetailsRect.origin.y = detailsTopLeft;
			currentDetailsRect.size.height = currentParentViewRect.size.height - detailsTopLeft;
			currentImageRect.size.height = detailsTopLeft - 44;

		} else {
			//selected segment = 2
			NSLog(@"Full Screen");
			currentDetailsRect.origin.y = currentParentViewRect.size.height;
			currentImageRect.size.height = currentParentViewRect.size.height-44	;	


			//UISplitViewCode
			if (self.interfaceOrientation== UIInterfaceOrientationLandscapeLeft || self.interfaceOrientation == UIInterfaceOrientationLandscapeRight)  {

				imageViewWidthChanged = YES;
			}
		}

	}
	[UIView animateWithDuration:1.0 animations:^{
	
		detailsView.frame = currentDetailsRect;
		imageView.frame = currentImageRect;
		self.view.frame = currentParentFrame;	
	}];
	
	[testMVPagingScrollView refreshLayout];
	
			
}


- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}


- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
	
	[localAnimalImageController release];
	[audioPopoverViewController release];
    [super dealloc];
}


@end
