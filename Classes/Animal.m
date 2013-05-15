// 
//  Animal.m
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

#import "Animal.h"

#import "Audio.h"
#import "CommonName.h"
#import "Image.h"
#import "StatusTypes.h"
#import "TaxonGroup.h"

@implementation Animal 

@dynamic distribution;
@dynamic animalName;
@dynamic biology;
@dynamic species;
@dynamic identifyingCharacteristics;
@dynamic size;
@dynamic distinctive;
@dynamic habitat;
@dynamic nocturnal;
@dynamic diet;
@dynamic bite;
@dynamic commonNames;
@dynamic audios;
@dynamic images;
@dynamic taxon;
@dynamic thumbnail;
@dynamic nativestatus;
@dynamic foodplant;
@dynamic mapImage;
@dynamic subTaxon;
@dynamic catalogID;
@dynamic lcs;
@dynamic ncs;
@dynamic wcs;
@dynamic order;
@dynamic animalClass;
@dynamic family;
@dynamic phylum;
@dynamic genusName;

- (NSString *) scientificName {
	
	if (self.species != nil) {
		return [NSString stringWithFormat:@"%@ %@",self.genusName, self.species];
	} else if (self.genusName != nil) {
		return [NSString stringWithFormat:@"%@ sp", self.genusName];
	} else {
		return  @" ";
	}
	
	
}

-(NSArray *) sortedImages {
	NSLog(@"Sorted images");
	NSMutableArray *myImages = [NSMutableArray arrayWithCapacity:1];
	[myImages addObjectsFromArray:[[self images] allObjects]]; //Get random array
	if ([myImages count] > 1){
		NSLog(@"Call to sort using selector");
		NSSortDescriptor* desc = [[NSSortDescriptor alloc] initWithKey:@"order" ascending:YES];
		[myImages sortUsingDescriptors:[NSArray arrayWithObject:desc]];
		[desc release];
	}
	return [NSArray arrayWithArray:myImages];
}

@end
