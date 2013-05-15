//
//  AnimalDetailsiPhoneViewController.h
//  Field Guide 2010
//
/*
 Copyright (c) 2011 Museum Victoria
 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */
//

#import <UIKit/UIKit.h>
@class Animal;
@class MVPagingScollView;
@class AudioListViewController;

@interface AnimalDetailsiPhoneViewController : UIViewController {

	Animal *animal;
	MVPagingScollView *pagingScrollView;
	UIWebView *animalDetails;
	UIWebView *distributionWebView;
	UIWebView *scarcityWebView;
	NSMutableString *distributionHTMLCode;
	NSMutableString *scarcityHTMLCode;
	NSMutableString *baseHTMLCode;
	UIButton *infoView;
	UIButton *audioView;
	UIView *imageView;
	UITabBar *tabBar;
	AudioListViewController *audioList;
	UITabBarItem *audioTab;
	UITabBarItem *imageTab;
	UITabBarItem *detailsTab;
	UITabBarItem *distributionTab;
	UITabBarItem *rarityTab;
	
	
}

@property (retain, nonatomic) IBOutlet UIWebView *animalDetails;
@property (retain, nonatomic) IBOutlet UIWebView *distributionWebView;
@property (retain, nonatomic) IBOutlet UIWebView *scarcityWebView;

@property (retain, nonatomic) IBOutlet UIButton *infoView;
@property (retain, nonatomic) IBOutlet UIButton *audioView;
@property (retain, nonatomic) IBOutlet UIView *imageView;
@property (retain, nonatomic) IBOutlet UITabBar *tabBar;

@property (retain, nonatomic) IBOutlet UITabBarItem *audioTab;
@property (retain, nonatomic) IBOutlet UITabBarItem *imageTab;
@property (retain, nonatomic) IBOutlet UITabBarItem *detailsTab;
@property (retain, nonatomic) IBOutlet UITabBarItem *distributionTab;
@property (retain, nonatomic) IBOutlet UITabBarItem *rarityTab;
@property (retain, nonatomic) Animal *animal;

-(IBAction)toggleInfo:(id)sender;
-(void) htmlTemplate:(NSMutableString *)templateString keyString:(NSString *)stringToReplace replaceWith:(NSString *)replacementString;
- (BOOL)hidesBottomBarWhenPushed;
@end
