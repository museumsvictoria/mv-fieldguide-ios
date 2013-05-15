    //
//  MVPagingScollView.m
//  Field Guide 2010
//
//  Created by Simon Sherrin on 25/01/11.
/*
 Copyright (c) 2011 Museum Victoria
 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 *///

#import "MVPagingScollView.h"
#import "ImageScrollView.h"
#import "Image.h"
@implementation MVPagingScollView
#define PAD  10

@synthesize images, scrollViewImageCredit, delegate, pagingScrollView, pageControl;
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


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	//If iPhone, move the credit label down 10
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
		CGRect creditFrame = scrollViewImageCredit.frame;
		creditFrame.origin.y = creditFrame.origin.y + 10;
		scrollViewImageCredit.frame = creditFrame;
		
	}
	
	pagingScrollView.contentSize = [self contentSizeForPaging];
	pagingScrollView.delegate = self;
	
	UITapGestureRecognizer *singleFingerDTap = [[UITapGestureRecognizer alloc]
												initWithTarget:self action:@selector(handleDoubleTap:)];
    singleFingerDTap.numberOfTapsRequired = 2;
	
    [self.view addGestureRecognizer:singleFingerDTap];
    [singleFingerDTap release];
	UITapGestureRecognizer *singleFingerTap = [[UITapGestureRecognizer alloc]
											   initWithTarget:self action:@selector(handleSingleTap:)];
    singleFingerTap.numberOfTapsRequired = 1;
    [singleFingerTap requireGestureRecognizerToFail:singleFingerDTap];
	[self.view addGestureRecognizer:singleFingerTap];
    [singleFingerTap release];
	
	scrollViewImageCredit.text = @"New Text";
	currentPages = [[NSMutableSet alloc] init];
	queuedPages	= [[NSMutableSet alloc] init];
	NSLog(@"before tiling images");
	[self tilePages];

}

- (void)viewWillAppear:(BOOL)animated{
	[super viewWillAppear:animated];
	NSLog(@"pagingScrollVIew:viewWillAppear");
	pagingScrollView.contentSize =[self contentSizeForPaging];
	
}

- (void)layoutSubviews 
{
	NSLog(@"MVPagingLayoutSubviews");	
  // [super layoutSubviews]; Commented out - shouldn't be called 

}
-(void)newImageSet:(NSArray *)newImages{
	NSLog(@"New Images Set");
	self.images = newImages;
	pageControl.numberOfPages = [self.images count];
	pagingScrollView.contentSize = [self contentSizeForPaging];
	[self setImageCredit:(Image*)[self.images objectAtIndex:0]];
	//Remove Current Pages From display
	for (ImageScrollView *page in currentPages) {
            [queuedPages addObject:page];
            [page removeFromSuperview];
    }
    [currentPages minusSet:queuedPages];	
	//Scroll to page
	[pagingScrollView scrollRectToVisible:[self frameForPageAtIndex:0] animated:YES];
	[self tilePages];
}

-(void) setImageCredit:(Image*)currentImage{
	if (currentImage !=nil) {
		self.scrollViewImageCredit.text = [NSString stringWithFormat:NSLocalizedString(@"Credit: %@",nil), [currentImage credit]];	
	}

}

- (CGRect) frameForPageAtIndex:(NSUInteger) index{
	CGRect bounds = self.view.bounds;
	CGRect pageFrame = bounds;
	pageFrame.size.width -= ( 2* PAD);
	pageFrame.origin.x = (bounds.size.width * index) + PAD;
	return pageFrame;
	
}


- (CGSize) contentSizeForPaging{
	
	CGRect bounds = pagingScrollView.bounds;
	return CGSizeMake(bounds.size.width * [self.images count], bounds.size.height);
	
}

- (CGRect) frameSizeForPaging{
	CGRect parentFrame = self.view.bounds;
	parentFrame.origin.x -= PAD;
	parentFrame.size.width += (2 * PAD );
	return parentFrame;
}

-(UIImage *) imageAtIndex:(NSUInteger)index{
	NSLog(@"imageAtIndex:%d", index);
	Image  *currentImage = (Image *) [self.images objectAtIndex:index];
	NSString *path = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%@",[[currentImage filename] stringByDeletingPathExtension]] ofType:@"jpg"];					
	NSLog(@"imagepath:%@", path);
	return [UIImage imageWithContentsOfFile:path];	
}

- (NSData *) dataForImageAtIndex:(NSUInteger)index{
	Image  *currentImage = (Image *) [self.images objectAtIndex:index];
	NSString *path = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%@",[[currentImage filename] stringByDeletingPathExtension]] ofType:@"jpg"];		
	return [NSData dataWithContentsOfFile:path];
}


- (void)configurePage:(ImageScrollView *)page forIndex:(NSUInteger)index
{
	NSLog(@"ConfigurePage");
	//page.delegate = self;
	page.index = index;
	page.frame = [self frameForPageAtIndex:index];	
	[page displayImage:[self imageAtIndex:index]];	
	// trial async code 
	/*
	Image  *currentImage = (Image *) [self.images objectAtIndex:index];
	NSString *path = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%@",[[currentImage filename] stringByDeletingPathExtension]] ofType:@"jpg"];		
	dispatch_queue_t imageLoadQueue = dispatch_queue_create("imageLoading", NULL);
	dispatch_async(imageLoadQueue, ^{
		NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
		NSData *imageData = 	[NSData dataWithContentsOfFile:path];
		UIImage *tmpImage = [UIImage imageWithData:imageData];	
		dispatch_async(dispatch_get_main_queue(), ^{
			[page displayImage:tmpImage];
		});
		[pool drain];
	});
	dispatch_release(imageLoadQueue);
	 */
}



- (IBAction)changePage:(id)sender{
	int page = pageControl.currentPage;	
	changedByPageControl = YES;
	[self setImageCredit:(Image*)[self.images objectAtIndex:page]];
	//Need to move scroll view to page X
	[pagingScrollView scrollRectToVisible:[self frameForPageAtIndex:page] animated:YES];
}


- (void)tilePages 
{
    // Calculate which pages are visible
    CGRect visibleBounds = pagingScrollView.bounds;
 /* 27/02 */
	int firstNeededPageIndex = floorf(CGRectGetMinX(visibleBounds) / CGRectGetWidth(visibleBounds)); //added -1 to get the image offscreen on the left added
    int lastNeededPageIndex  = floorf((CGRectGetMaxX(visibleBounds)-1) / CGRectGetWidth(visibleBounds)); //added + 1 to get the image offscreen to the right added
    firstNeededPageIndex = MAX(firstNeededPageIndex, 0);
    lastNeededPageIndex  = MIN(lastNeededPageIndex, [self.images count] - 1);
	
	//load all images
	//int firstNeededPageIndex = 0;
	//int lastNeededPageIndex = [self.images count]-1;
	
	
	
//	NSLog(@"first page:%d", firstNeededPageIndex);
//	NSLog(@"lastPageindex:%d", lastNeededPageIndex);
    // Recycle no-longer-visible pages 
    for (ImageScrollView *page in currentPages) {
        if (page.index < firstNeededPageIndex || page.index > lastNeededPageIndex) {
            [queuedPages addObject:page];
            [page removeFromSuperview];
        }
    }
    [currentPages minusSet:queuedPages];
    
    // add missing pages
    for (int index = firstNeededPageIndex; index <= lastNeededPageIndex; index++) {
        if (![self isDisplayingPageForIndex:index]) {
            ImageScrollView *page = [self dequeueRecycledPage];
            if (page == nil) {
                page = [[[ImageScrollView alloc] init] autorelease];
            }
            [self configurePage:page forIndex:index];
            [pagingScrollView addSubview:page];
			page.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
            [currentPages addObject:page];
        }
    } 
	if (changedByPageControl) {
        // do nothing - the scroll was initiated from the page control, not the user dragging
        
    }else {
		CGFloat pageWidth = pagingScrollView.bounds.size.width;
		int currentpage = floor((pagingScrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
		if (currentpage >= 0 && currentpage <= ([self.images count]-1) ) //avoid trying to call outside the range of the array.
		{
		pageControl.currentPage = currentpage;
		[self setImageCredit:(Image*)[self.images objectAtIndex:currentpage]];
		}
	}

}

// At the begin of scroll dragging, reset the boolean used when scrolls originate from the UIPageControl
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    changedByPageControl = NO;
}

// At the end of scroll animation, reset the boolean used when scrolls originate from the UIPageControl
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    changedByPageControl = NO;
}

- (ImageScrollView *)dequeueRecycledPage
{
    ImageScrollView *page = [queuedPages anyObject];
    if (page) {
        [[page retain] autorelease];
        [queuedPages removeObject:page];
    }
    return page;
}

- (BOOL)isDisplayingPageForIndex:(NSUInteger)index
{
    BOOL foundPage = NO;

    for (ImageScrollView *page in currentPages) {
        if (page.index == index) {
            foundPage = YES;
            break;
        }
    }
    return foundPage;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self tilePages];
}




- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Overriden to allow any orientation.
    return YES;
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    // here, our pagingScrollView bounds have not yet been updated for the new interface orientation. So this is a good
    // place to calculate the content offset that we will need in the new orientation
    CGFloat offset = pagingScrollView.contentOffset.x;
    CGFloat pageWidth = pagingScrollView.bounds.size.width;
    	NSLog(@"MVPagingView:willRotateToInterfaceOrientation");
	NSLog(@"contentOffset:%f ", offset);
    if (offset >= 0) {
        firstVisiblePageIndexBeforeRotation = floorf(offset / pageWidth);
        percentScrolledIntoFirstVisiblePage = (offset - (firstVisiblePageIndexBeforeRotation * pageWidth)) / pageWidth;
    } else {
        firstVisiblePageIndexBeforeRotation = 0;
        percentScrolledIntoFirstVisiblePage = offset / pageWidth;
    }    
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    // recalculate contentSize based on current orientation
    pagingScrollView.contentSize = [self contentSizeForPaging];
    NSLog(@"pagingScrollView.contentSize:%f,%f", pagingScrollView.contentSize.width, pagingScrollView.contentSize.height);
    // adjust frames and configuration of each visible page
    for (ImageScrollView *page in currentPages) {
        CGPoint restorePoint = [page pointToCenterAfterRotation];
        CGFloat restoreScale = [page scaleToRestoreAfterRotation];
        page.frame = [self frameForPageAtIndex:page.index];
        [page setMaxMinZoomScalesForCurrentBounds];
        [page restoreCenterPoint:restorePoint scale:restoreScale];
        
    }
    
    // adjust contentOffset to preserve page location based on values collected prior to location
    CGFloat pageWidth = pagingScrollView.bounds.size.width;
    CGFloat newOffset = (firstVisiblePageIndexBeforeRotation * pageWidth) + (percentScrolledIntoFirstVisiblePage * pageWidth);
    pagingScrollView.contentOffset = CGPointMake(newOffset, 0);
}

- (void)refreshLayout{
	// Resizing isn't happing - probably due to layoutView on imageView;
	// recalculate contentSize based on current orientation
	//NSLog(@"Refresh View");
	//int currentpage = pageControl.currentPage;
	//NSLog(@"CurrentPage:%d", pageControl.currentPage);
	//pagingScrollView.contentSize = [self contentSizeForPaging];
//	[pagingScrollView scrollRectToVisible:[self frameForPageAtIndex:currentpage] animated:YES];
    // adjust frames and configuration of each visible page
 for (ImageScrollView *page in currentPages) {
       CGPoint restorePoint = [page pointToCenterAfterRotation];
        CGFloat restoreScale = [page scaleToRestoreAfterRotation];
	 /*   	 [UIView animateWithDuration:1.0 animations:^{
     		page.frame = [self frameForPageAtIndex:page.index];   
		 }];*/
     [page setMaxMinZoomScalesForCurrentBounds];
     [page restoreCenterPoint:restorePoint scale:restoreScale];
	 [page setZoomScale:(page.minimumZoomScale +0.1) animated:NO];
	 [page setZoomScale:page.minimumZoomScale animated:YES];
    }	
	

}

-(void) handleSingleTap:(UIGestureRecognizer *)sender{
	//Pass to Parent - Needs to bubble up to top level
	NSLog(@"MVPaging - HandleSingleTap");
	if ([self.delegate respondsToSelector:@selector(handleSingleTap:)]) {
		[self.delegate handleSingleTap:sender];		
	}
	
}
-(void) handleDoubleTap:(UIGestureRecognizer *)sender{
	//Pass to Parent - Needs to bubble up to top level
	NSLog(@"MVPaging - HandleDoubleTap");
//	if ([self.delegate respondsToSelector:@selector(handleSingleTap:)]) {
//		[self.delegate handleSingleTap:sender];		
//	}
	
}



- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}





- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
	self.delegate = nil;
	self.images = nil;
	self.scrollViewImageCredit = nil;
	self.pagingScrollView = nil;
	self.pageControl = nil;
	
	//currentPages = nil;
	//queuedPages = nil;
}


- (void)dealloc {
	[pagingScrollView release];
	[pageControl release];
	[images release];
	[scrollViewImageCredit release];
	[currentPages release];
	[queuedPages release];
    [super dealloc];
	
}


@end
