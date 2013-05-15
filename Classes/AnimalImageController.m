    //
//  AnimalImageController.m
//  Field Guide 2010
//
//  Created by Simon Sherrin on 14/09/10.
/*
 Copyright (c) 2011 Museum Victoria
 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */
//

#import "AnimalImageController.h"
#import "Image.h"


@implementation AnimalImageController

/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}
*/

@synthesize currentImage, caption, credit, imageView, parentIndex;

- (id)initWithAnimalImage:(Image *)newImage{

	if (self == [super initWithNibName:@"AnimalImageController" bundle:nil]) {
		NSLog(@"Before setting current Image in init");
		self.currentImage = newImage;
		parentIndex = 0;
    }
    return self;
	
}

- (void)changeImage:(Image *)newImage{
	self.currentImage = newImage;
	NSLog(@"Start of View Did Load");
	NSString *path = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%@",[[currentImage filename] stringByDeletingPathExtension]] ofType:@"jpg"];
    UIImage *tmpImage = [UIImage imageWithContentsOfFile:path];
	imageView.contentMode = UIViewContentModeScaleAspectFit;
	NSLog(@"Before Rect Frame Set");
	CGRect frame = self.view.superview.frame;
	frame.origin.x = frame.size.width * parentIndex;
	frame.origin.y = 0;

	self.view.frame = frame;
	NSLog(@"Attempt to set Image");
	imageView.image = tmpImage;
	//caption.text = @"Here is the Caption";
	/* Commented out to try new labeling.
	NSLog(@"Attempt to set Caption");
	NSLog(currentImage.caption);
	caption.text = currentImage.caption;
	NSLog(@"Attempt to set Credit,%@", currentImage.credit);
	credit.text = [NSString stringWithFormat:@"Credit: %@", currentImage.credit];
	*/
}



/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.*/
- (void)viewDidLoad {
    [super viewDidLoad];
	//load image into view
	NSLog(@"Start of View Did Load");
	NSString *path = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%@",[[currentImage filename] stringByDeletingPathExtension]] ofType:@"jpg"];
    UIImage *tmpImage = [UIImage imageWithContentsOfFile:path];
	imageView.contentMode = UIViewContentModeScaleAspectFit;
	NSLog(@"Before Rect Frame Set");
	if (self.view.superview != nil){
		CGRect frame = self.view.superview.frame;
		NSLog(@"superview: %@", [[self.view.superview class] description]);
		NSLog(@"framesize: %f, %f", frame.size.width, frame.size.height);
		frame.origin.x = frame.size.width * parentIndex;
		frame.origin.y = 0;
		NSLog(@"orign: %f, %f", frame.origin.x, frame.origin.y);
		self.view.frame = frame;
	}
	NSLog(@"Attempt to set Image");
	imageView.image = tmpImage;
	/* Commented out for new credit option
	NSLog(@"Attempt to set Caption");
	NSLog(currentImage.caption);
	caption.text = currentImage.caption;
	NSLog(@"Attempt to set Credit,%@", currentImage.credit);
	credit.text = [NSString stringWithFormat:@"Credit: %@", currentImage.credit];
	 */
}

- (void)didMoveToSuperview{
	NSLog(@"Did move to Superview");
	CGRect frame = self.view.superview.frame;
	NSLog(@"superview: %@", [[self.view.superview class] description]);
	NSLog(@"framesize: %f, %f", frame.size.width, frame.size.height);
	frame.origin.x = frame.size.width * parentIndex;
	frame.origin.y = 0;
	NSLog(@"orign: %f, %f", frame.origin.x, frame.origin.y);
	self.view.frame = frame;
	
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Overriden to allow any orientation.
	NSLog(@"AutoRotate confirmed");
    return YES;
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation{
	NSLog(@"Before Rect Frame Set");
	CGRect frame = self.view.superview.frame;
	frame.origin.x = frame.size.width * parentIndex;
	frame.origin.y = 0;
	//frame.size.width = 768;
	//frame.size.height = 506;
	self.view.frame = frame;
	
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
    [currentImage release];
	[imageView release];
	[credit release];
	[caption release];
	
	[super dealloc];
	
}


@end
