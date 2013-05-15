//
//  AnimalDetailiPad.h
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

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@class Animal;
@class AnimalImageController;
@class AudioListViewController;
@class SearchTableViewController;
@class CustomSearchViewController;
@class PagingScrollView;
@class MVPagingScollView;

@interface AnimalDetailiPad : UIViewController <UIPopoverControllerDelegate, UISplitViewControllerDelegate, UIScrollViewDelegate>  {
	AVAudioPlayer *player;
    UIPopoverController *popoverController;
    UIToolbar *toolbar;
    UILabel *detailDescriptionLabel;
	UILabel *commonName;
	UILabel *scientificName;
	UILabel *otherCommonNames;
	
//	UIButton *playAudioButton;	
	UIBarButtonItem *playAudioButton;
	Animal *animal;
	UIImageView *mainImage;
	UILabel *markingsText;
	UILabel *identifyingText;
	UILabel *biologyText;
	UIWebView *detailsHTML;
	//TaxonListViewController *leftViewController;
	UILabel *titleLabel;
	UIPageControl *imagePagingControl;
	UIScrollView *imageHolder;
	NSArray *animalImages;
	AnimalImageController *localAnimalImageController;
	NSMutableArray *animalImageControllers;
	UIImageView *mapImage;
	UILabel *audioCredit;
	UIScrollView *contentDetailHolder;
	UIScrollView *startScreen;
	// To be used when scrolls originate from the UIPageControl
    BOOL pageControlUsed;
	// Audio Popup
	UIPopoverController *audioPopoverController;
	AudioListViewController *audioPopoverViewController;
	UIPopoverController *searchPopoverController;
	SearchTableViewController *searchPopoverViewController;
	CustomSearchViewController *searchViewController;
	UIButton  *raiseDetails;
	UIView *detailsView;
	UIView *imageView;
	UIWebView *animalHTMLDetails;
	BOOL detailsViewRaised;
	int detailsTopLeft;
	int imageViewBottomLeft;
	NSString *currentTaxonLabel;
	UILabel *imageCredit;
	UISegmentedControl *imageTextLayoutControl;
	UISplitViewController *parentSplitView;
	IBOutlet UIWebView *aboutHTML;
	IBOutlet UIWebView *welcomeHTML;
	MVPagingScollView *testMVPagingScrollView;
	IBOutlet UIImageView *webBackImage;
	UIActivityIndicatorView *activityIndicator;
	IBOutlet UIProgressView *progressView;
	IBOutlet UILabel *progressLabel;
	IBOutlet UIView *startButton;
	BOOL orientationLock;
}
//@property (nonatomic, retain)IBOutlet UILabel *startScreen;
@property (nonatomic, retain) IBOutlet UIScrollView *startScreen;
@property (retain) AVAudioPlayer *player;
@property (nonatomic, retain) IBOutlet UILabel *commonName;
@property (nonatomic, retain) IBOutlet UILabel	*scientificName;
@property (nonatomic, retain) IBOutlet UILabel	*otherCommonNames;
@property (nonatomic, retain) IBOutlet UIToolbar *toolbar;
@property (nonatomic, retain) IBOutlet UILabel *titleLabel;
@property (nonatomic, retain) Animal *animal;
@property (nonatomic, retain) IBOutlet UILabel *detailDescriptionLabel;
@property (nonatomic, retain) IBOutlet UIImageView *mainImage;
@property (nonatomic, retain) IBOutlet UILabel *markingsText;
@property (nonatomic, retain) IBOutlet UILabel *identifyingText;
@property (nonatomic, retain) IBOutlet UIWebView *detailsHTML;
@property (nonatomic, retain) IBOutlet UIPageControl *imagePagingControl;
@property (nonatomic, retain) IBOutlet UIScrollView *imageHolder;
@property (nonatomic, retain) NSArray *animalImages;
@property (nonatomic, retain) AnimalImageController *localAnimalImageController;
@property (nonatomic, retain) NSMutableArray *animalImageControllers;
//@property (nonatomic, retain) IBOutlet UIButton *playAudioButton;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *playAudioButton;
@property (nonatomic, retain) IBOutlet UIImageView *mapImage;
@property (nonatomic, retain) IBOutlet UILabel *biologyText;
@property (nonatomic, retain) IBOutlet UILabel *audioCredit;
@property (nonatomic, retain) IBOutlet UIScrollView *contentDetailHolder;
@property (nonatomic, retain) IBOutlet UIButton *raiseDetails;
@property (nonatomic, retain) IBOutlet UIView *detailsView;
@property (nonatomic, retain) IBOutlet UIView *imageView;
@property (nonatomic, retain) IBOutlet UIWebView *animalHTMLDetails;
@property (nonatomic, retain) NSString *currentTaxonLabel;
@property (nonatomic, retain) IBOutlet UILabel *imageCredit;
@property (nonatomic, retain) IBOutlet UISegmentedControl *imageTextLayoutControl;
@property (nonatomic, retain) IBOutlet UISplitViewController *parentSplitView;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (nonatomic, retain) IBOutlet UILabel *progressLabel;
@property (nonatomic, retain) IBOutlet UIProgressView *progressView;
@property  BOOL orientationLock;

- (IBAction) showInfoView:(id)sender;
- (IBAction) changeDetailsView:(id)sender;
- (IBAction) layoutControlChanged:(id)sender;
- (IBAction) playAudio:(id)sender;
- (IBAction)changePage:(id)sender;
- (IBAction) showAudio:(id)sender;
- (IBAction) showSearch:(id)sender;
- (IBAction) touchToBegin:(id)sender;
//-(NSMutableString *)constructHTML;
-(NSMutableString	*)loadHTML;
-(void)htmlTemplate:(NSMutableString *)templateString keyString:(NSString *)stringToReplace replaceWith:(NSString *)replacementString;
-(BOOL)isFullScreen;
- (void)configureView;
-(void) makeToolbarButtonsInactive;
-(void) makeToolbarButtonsActive;
-(void) hideProgress;
-(void) updateProgressBar:(float)loadprogress;
-(void) dismissAllPopovers;
//@property (nonatomic, assign) IBOutlet TaxonListViewController *leftViewController;
@end
