//
//  MVPagingScollView.h
//  Field Guide 2010
//
//  Created by Simon Sherrin on 25/01/11.
/*
 Copyright (c) 2011 Museum Victoria
 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */
//

#import <UIKit/UIKit.h>
@class ImageScrollView;
@class Image;
@interface MVPagingScollView : UIViewController  <UIScrollViewDelegate>{
			UIScrollView *pagingScrollView;
			NSArray *images;
			UIPageControl *pageControl;
			UILabel	*scrollViewImageCredit;
			BOOL changedByPageControl;
			NSMutableSet *currentPages;
			NSMutableSet *queuedPages;
			int           firstVisiblePageIndexBeforeRotation;
			CGFloat       percentScrolledIntoFirstVisiblePage;
			id  delegate;
}

@property (retain, nonatomic) IBOutlet UIScrollView *pagingScrollView;
@property (retain, nonatomic) IBOutlet UIPageControl *pageControl;
@property (retain, nonatomic) NSArray *images;
@property (retain, nonatomic) IBOutlet UILabel *scrollViewImageCredit;
@property (nonatomic, assign) id delegate;
- (CGSize) contentSizeForPaging;
- (CGRect) frameSizeForPaging;
- (CGRect) frameForPageAtIndex:(NSUInteger) index;
- (void) newImageSet:(NSArray *)newImages;
- (BOOL)isDisplayingPageForIndex:(NSUInteger)index;
- (ImageScrollView *)dequeueRecycledPage;
- (IBAction)changePage:(id)sender;
- (void) refreshLayout;
- (void) handleSingleTap:(UIGestureRecognizer *)sender;
- (void) tilePages;
- (void) setImageCredit:(Image*)currentImage;
@end
