//
//  VariableStore.m
//  Field Guide 2010
//
//  Created by Simon Sherrin on 23/03/11.
/*
 Copyright (c) 2011 Museum Victoria
 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */
//

#import "VariableStore.h"


@implementation VariableStore

@synthesize toolbarTint;
@synthesize animalDataVersion;

+ (VariableStore *)sharedInstance
{
    // the instance of this class is stored here
    static VariableStore *myInstance = nil;
	
    // check to see if an instance already exists
    if (nil == myInstance) {
        myInstance  = [[[self class] alloc] init];
        // initialize variables here
        // TODO:this should be done via .plist
        NSBundle *thisBundle = [NSBundle bundleForClass:[self class]];
        NSString *commonArrayPath;
        if((commonArrayPath =[thisBundle pathForResource:@"CustomSettings" ofType:@"plist"])) {
            NSDictionary *loadValues = [NSDictionary dictionaryWithContentsOfFile:commonArrayPath];
            NSNumber *redTint;
            NSNumber *greenTint;
            NSNumber *blueTint;
            
            @try {
                myInstance.animalDataVersion = (NSString*)[loadValues objectForKey:@"currentDataVersion"];
                
                NSNumber *redValue = [loadValues objectForKey:@"ToolbarTintRed"];
               // NSLog(@"RedString:%@", (NSString*)[loadValues objectForKey:@"ToolbarTintRed"]);
                if ([redValue floatValue] > 256|[redValue floatValue] < 0){
                    
                    redTint = [NSNumber numberWithFloat:1.0];
                    
                }else
                {
                    redTint = [NSNumber numberWithDouble:[redValue doubleValue]/256.0];
                    
                }
                NSNumber *greenValue = [loadValues objectForKey:@"ToolbarTintGreen"];
                if ([greenValue floatValue] > 256|[greenValue floatValue] < 0){
                    
                    greenTint = [NSNumber numberWithFloat:1.0];
                    
                }else
                {
                    greenTint = [NSNumber numberWithDouble:[greenValue doubleValue]/256.0];
                    
                }
                NSNumber *blueValue = [loadValues objectForKey:@"ToolbarTintBlue"];
                if ([blueValue floatValue] > 256|[blueValue floatValue] < 0){
                    
                    blueTint = [NSNumber numberWithFloat:1.0];
                    
                }else
                {
                    blueTint = [NSNumber numberWithDouble:[blueValue doubleValue]/256.0];
                    
                }
                 NSLog(@"RedValue: %f", [redValue doubleValue]);

            }
            @catch (NSException *exception) {
                redTint = [NSNumber numberWithDouble:0.0];
                greenTint = [NSNumber numberWithDouble:0.0];
                blueTint = [NSNumber numberWithDouble:0.0];
            }
            @finally {
                
            }
         
            NSLog(@"RedTint:%f", [redTint floatValue]);
            NSLog(@"RedTint Double:%f", [redTint doubleValue]);
                       
            myInstance.toolbarTint = [UIColor colorWithRed:[redTint floatValue] green:[greenTint floatValue] blue:[blueTint floatValue] alpha:1.0];
        
         }
    }
    // return the instance of this class
    return myInstance;
}

@end
