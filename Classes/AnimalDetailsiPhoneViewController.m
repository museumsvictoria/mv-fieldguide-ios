//
//  AnimalDetailsiPhoneViewController.m
//  Field Guide 2010
//
//  Created by Simon Sherrin on 30/01/11.
/*
 Copyright (c) 2011 Museum Victoria
 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */
//

#import "AnimalDetailsiPhoneViewController.h"
#import "Animal.h"
#import "MVPagingScollView.h"
#import "CommonName.h"
#import "AudioListViewController.h"
#import "MVPagingScollView.h"


@implementation AnimalDetailsiPhoneViewController

@synthesize animal, animalDetails, distributionWebView, scarcityWebView, infoView, audioView, tabBar, audioTab, imageTab, detailsTab, distributionTab, rarityTab, imageView;
// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
/*
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization.
    }
    return self;
}
*/
- (BOOL)hidesBottomBarWhenPushed{
	return TRUE;
}


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	self.hidesBottomBarWhenPushed = YES;
	self.navigationController.navigationBar.translucent = YES;
	//Setup ImageView
	pagingScrollView = [[MVPagingScollView alloc] initWithNibName:@"MVPagingScollView" bundle:nil];
	//CGRect imageViewFrame = self.view.frame;
	CGRect imageViewFrame = imageView.frame;



	//[self.view  insertSubview:pagingScrollView.view atIndex:1]; //at 1 due to web view
	[imageView insertSubview:pagingScrollView.view atIndex:0];
	//27/02 reordered next two lines to here from about insertSubview/
	pagingScrollView.view.frame = imageViewFrame;
	pagingScrollView.view.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;	
	[pagingScrollView newImageSet:[[self.animal images] allObjects]];
//	[pagingScrollView newImageSet:[self.animal sortedImages]];

	pagingScrollView.delegate = self;
	
	
	//Display Web Content
	NSString *path = [[NSBundle mainBundle] bundlePath];
	NSURL *baseURL = [NSURL fileURLWithPath:path];
	//	NSLog([self constructHTML]);

	animalDetails.opaque = NO;
	animalDetails.backgroundColor = [UIColor clearColor];
	distributionWebView.opaque = NO;
	distributionWebView.backgroundColor = [UIColor clearColor];
	scarcityWebView.opaque = NO;
	scarcityWebView.backgroundColor = [UIColor clearColor];
	NSString *htmlPath;
	NSString *distributionPath;
	NSString *scarcityPath;
	htmlPath = [[NSBundle mainBundle] pathForResource:@"template-iphone-details" ofType:@"html"];
	distributionPath = [[NSBundle mainBundle] pathForResource:@"template-iphone-distribution" ofType:@"html"];
	scarcityPath =[[NSBundle mainBundle] pathForResource:@"template-iphone-scarcity" ofType:@"html"];

	
	baseHTMLCode = [[NSMutableString alloc] initWithContentsOfFile:htmlPath];
	distributionHTMLCode = [[NSMutableString alloc] initWithContentsOfFile:distributionPath];
	scarcityHTMLCode = [[NSMutableString alloc] initWithContentsOfFile:scarcityPath];


	//Common Names is a set of strings
	NSMutableString *constructedCommonNames = [NSMutableString stringWithCapacity:1];
	//[constructedCommonNames appendFormat:@"%@", @"Hello"];
	
	for (CommonName *tmpCommonName in animal.commonNames)
	{
		[constructedCommonNames appendFormat:@"%@, ",tmpCommonName.commonName];
		
	}
	if ([constructedCommonNames length]>0){
		[constructedCommonNames deleteCharactersInRange:NSMakeRange([constructedCommonNames length]-2, 2)];
	}

	[self htmlTemplate:baseHTMLCode keyString:@"commonNames" replaceWith:[[constructedCommonNames copy] autorelease]];
	[self htmlTemplate:baseHTMLCode keyString:@"animalName" replaceWith:animal.animalName];
	[self htmlTemplate:baseHTMLCode keyString:@"scientificName" replaceWith:animal.scientificName];
	[self htmlTemplate:baseHTMLCode keyString:@"identifyingCharacteristics" replaceWith:animal.identifyingCharacteristics];
	[self htmlTemplate:baseHTMLCode keyString:@"distinctive" replaceWith:animal.distinctive];
	[self htmlTemplate:baseHTMLCode keyString:@"biology" replaceWith:animal.biology];
	[self htmlTemplate:baseHTMLCode keyString:@"habitat" replaceWith:animal.habitat];	
	[self htmlTemplate:baseHTMLCode keyString:@"phylum" replaceWith:animal.phylum];
	[self htmlTemplate:baseHTMLCode keyString:@"class" replaceWith:animal.animalClass];
	[self htmlTemplate:baseHTMLCode keyString:@"order" replaceWith:animal.order];
	[self htmlTemplate:baseHTMLCode keyString:@"family" replaceWith:animal.family];
	[self htmlTemplate:baseHTMLCode keyString:@"genus" replaceWith:animal.genusName];
	[self htmlTemplate:baseHTMLCode keyString:@"species" replaceWith:animal.species];
	[self htmlTemplate:distributionHTMLCode keyString:@"mapimage" replaceWith:animal.mapImage];
	[self htmlTemplate:distributionHTMLCode keyString:@"distribution" replaceWith:animal.distribution];	
	
	[self htmlTemplate:scarcityHTMLCode keyString:@"lcs" replaceWith:animal.lcs];
	[self htmlTemplate:scarcityHTMLCode keyString:@"ncs" replaceWith:animal.ncs];
	[self htmlTemplate:scarcityHTMLCode keyString:@"wcs" replaceWith:animal.wcs];
	[self htmlTemplate:baseHTMLCode keyString:@"native" replaceWith:animal.nativestatus];
	[self htmlTemplate:baseHTMLCode keyString:@"bite" replaceWith:animal.bite];
	[self htmlTemplate:baseHTMLCode keyString:@"diet" replaceWith:animal.diet];
	
	
	//NSString *baseHTMLCode = [[NSString alloc] initWithString:[self constructHTML]];

	[animalDetails loadHTMLString:baseHTMLCode baseURL:baseURL];
	[scarcityWebView loadHTMLString:scarcityHTMLCode baseURL:baseURL];
	[distributionWebView loadHTMLString:distributionHTMLCode baseURL:baseURL];

	
	//Hide audio Button if no audio
	if ([[animal audios] count] > 0) {
		//audioView.enabled = YES;
		audioTab.enabled = YES;
		audioList = [[AudioListViewController alloc] initWithNibName:@"AudioListViewController" bundle:nil];
		audioList.audioFilesArray = (NSArray *)[[animal audios] allObjects];
	}else {
		//audioView.enabled = NO;
		audioTab.enabled = NO;
	}
	 
	//Set up initial state.
	scarcityWebView.hidden = YES;
	distributionWebView.hidden = YES;
	tabBar.selectedItem = imageTab;
	
}

-(void) viewWillAppear:(BOOL)animated{
	[super viewWillAppear:animated];
	//27/02 Commented out next line to see what happens with spike. - No effect
	[pagingScrollView viewWillAppear:animated];
}

-(void) handleSingleTap:(UIGestureRecognizer *)sender{
	//if hidden, show,

	if (self.navigationController.navigationBarHidden == YES) {
		[self.navigationController setNavigationBarHidden:NO animated:NO];
		tabBar.hidden = NO;
		CGRect imageViewFrame = pagingScrollView.view.frame;
		imageViewFrame.origin.x = 0;
		imageViewFrame.origin.y = 0;
		imageViewFrame.size.height = imageViewFrame.size.height - 49;
		pagingScrollView.view.frame = imageViewFrame;
	//	NSLog(@"Navigation Bar Section");
	}else {
		[self.navigationController setNavigationBarHidden:YES animated:YES];
		tabBar.hidden = YES;
		CGRect imageViewFrame = pagingScrollView.view.frame;
		imageViewFrame.origin.x = 0;
		imageViewFrame.origin.y = 0;
		imageViewFrame.size.height = imageViewFrame.size.height + 49;
		pagingScrollView.view.frame = imageViewFrame;	
	}
	
	
}


-(void) htmlTemplate:(NSMutableString *)templateString keyString:(NSString *)stringToReplace replaceWith:(NSString *)replacementString{

	if (replacementString != nil && [replacementString length] > 0) {
		[templateString replaceOccurrencesOfString:[NSString stringWithFormat:@"<%%%@%%>",stringToReplace] withString:replacementString options:0 range:NSMakeRange(0, [templateString length])];
		[templateString	replaceOccurrencesOfString:[NSString stringWithFormat:@"<%%%@Class%%>",stringToReplace] withString:@" " options:0 range:NSMakeRange(0, [templateString length])];
	}else {
		NSLog(@"keystring %@ is nil", stringToReplace);
		[templateString replaceOccurrencesOfString:[NSString stringWithFormat:@"<%%%@%%>",stringToReplace] withString:@"" options:0 range:NSMakeRange(0, [templateString length])];
		[templateString	replaceOccurrencesOfString:[NSString stringWithFormat:@"<%%%@Class%%>",stringToReplace] withString:@"invisible" options:0 range:NSMakeRange(0, [templateString length])];
		
	}

}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {

	if (navigationType == UIWebViewNavigationTypeLinkClicked) {
		[[UIApplication sharedApplication] openURL:[request mainDocumentURL]];
		return NO;
	}
	
	return YES;
}

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item{
	//NSString *path = [[NSBundle mainBundle] bundlePath];
	//NSURL *baseURL = [NSURL fileURLWithPath:path];
	
	if (item == detailsTab) {
				self.navigationController.navigationBar.translucent = NO;
		//27/02 commented out remove from superview
		//	if (pagingScrollView.view.superview ==self.view ) {
	//		[pagingScrollView.view removeFromSuperview];
	//	}
		if (audioList.view.superview == self.view) {
			[audioList.view removeFromSuperview];
		}
		pagingScrollView.view.hidden = YES;
		scarcityWebView.hidden = YES;
		distributionWebView.hidden = YES;
		animalDetails.hidden = NO;
		
	}else if (item == imageTab) {
			if (audioList.view.superview == self.view) {
			[audioList.view removeFromSuperview];
		}
		self.navigationController.navigationBar.translucent = YES;

		pagingScrollView.view.hidden = NO;
		scarcityWebView.hidden = YES;
		distributionWebView.hidden = YES;
		animalDetails.hidden = YES;
		
	} else if (item == audioTab) {
	//	if (pagingScrollView.view.superview ==self.view ) {
	//		[pagingScrollView.view removeFromSuperview];
	//	}
		self.navigationController.navigationBar.translucent = NO;		 

		[self.view insertSubview:audioList.view atIndex:1];
		pagingScrollView.view.hidden = YES;
		scarcityWebView.hidden = YES;
		distributionWebView.hidden = YES;
		animalDetails.hidden = YES;
		
	} else if (item == distributionTab){
				self.navigationController.navigationBar.translucent = NO;

		if (audioList.view.superview == self.view) {
			[audioList.view removeFromSuperview];
		}

		pagingScrollView.view.hidden = YES;
		scarcityWebView.hidden = YES;
		distributionWebView.hidden = NO;
		animalDetails.hidden = YES;
		
	}else if (item == rarityTab){
				self.navigationController.navigationBar.translucent = NO;

		if (audioList.view.superview == self.view) {
			[audioList.view removeFromSuperview];
		}

		pagingScrollView.view.hidden = YES;
		scarcityWebView.hidden = NO;
		distributionWebView.hidden = YES;
		animalDetails.hidden = YES;
		
	}

	
}


// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return YES;
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{

	[pagingScrollView willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation duration:(NSTimeInterval)duration  {

	[pagingScrollView willAnimateRotationToInterfaceOrientation:interfaceOrientation duration:duration];

}
					 
					 
- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

-(IBAction)toggleInfo:(id)sender{
		//make webview fill screen.
	CGRect parentframe = self.view.frame;
	if (animalDetails.frame.origin.y == 0) {
		parentframe.origin.y = parentframe.size.height+1;
	}

	animalDetails.frame = parentframe;
	
}


- (void)viewDidUnload {
    [super viewDidUnload];
	self.animal = nil;
	[self.animalDetails setDelegate:nil];
	[self.distributionWebView setDelegate:nil];
	[self.scarcityWebView setDelegate:nil];
	self.animalDetails = nil;
	self.distributionWebView = nil;
	self.scarcityWebView = nil;
	self.infoView = nil;
	self.audioView = nil;
	self.imageView = nil;
	self.tabBar = nil;
	self.imageTab = nil;
	self.audioTab = nil;
	self.detailsTab = nil;
	self.distributionTab = nil;
	self.rarityTab = nil;

    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
	[animal release];
	[pagingScrollView release];
	[infoView release];
	[audioView release];
	[imageView release];
	[tabBar release];
	[audioList release];
	[baseHTMLCode release];
	[distributionHTMLCode release];
	[scarcityHTMLCode release];
	[distributionWebView release];
	[scarcityWebView release];
	[imageTab release];
	[audioTab release];
	[detailsTab release];
	[distributionTab release];
	[rarityTab release];	
    [super dealloc];
}


@end
