//
//  Animal.h
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

#import <CoreData/CoreData.h>

@class Audio;
@class CommonName;
@class Genus;
@class Image;
@class StatusTypes;
@class TaxonGroup;

@interface Animal :  NSManagedObject  
{
}

@property (nonatomic, retain) NSString * distribution;
@property (nonatomic, retain) NSString * animalName;
@property (nonatomic, retain) NSString * biology;
@property (nonatomic, retain) NSString * species;
@property (nonatomic, retain) NSString * identifyingCharacteristics;
@property (nonatomic, retain) NSString * size;
@property (nonatomic, retain) NSString * distinctive;
@property (nonatomic, retain) NSString * habitat;
@property (nonatomic, retain) NSNumber * nocturnal;
@property (nonatomic, retain) NSString * diet;
@property (nonatomic, retain) NSString * bite;
@property (nonatomic, retain) NSString * thumbnail;
@property (nonatomic, retain) NSString * nativestatus;
@property (nonatomic, retain) NSString * foodplant;
@property (nonatomic, retain) NSString * mapImage;
@property (nonatomic, retain) NSString * subTaxon;
@property (nonatomic, retain) NSString * catalogID;
@property (nonatomic, retain) NSString * lcs;
@property (nonatomic, retain) NSString * ncs;
@property (nonatomic, retain) NSString * wcs;
@property (nonatomic, retain) NSSet* commonNames;
@property (nonatomic, retain) NSSet* audios;
@property (nonatomic, retain) NSSet* images;
@property (nonatomic, retain) TaxonGroup * taxon;
@property (nonatomic, retain) NSString * order;
@property (nonatomic, retain) NSString * animalClass;
@property (nonatomic, retain) NSString * family;
@property (nonatomic, retain) NSString * phylum;
@property (nonatomic, retain) NSString * genusName;

@end


@interface Animal (CoreDataGeneratedAccessors)

- (void)addCommonNamesObject:(CommonName *)value;
- (void)removeCommonNamesObject:(CommonName *)value;
- (void)addCommonNames:(NSSet *)value;
- (void)removeCommonNames:(NSSet *)value;

- (void)addAudiosObject:(Audio *)value;
- (void)removeAudiosObject:(Audio *)value;
- (void)addAudios:(NSSet *)value;
- (void)removeAudios:(NSSet *)value;

- (void)addImagesObject:(Image *)value;
- (void)removeImagesObject:(Image *)value;
- (void)addImages:(NSSet *)value;
- (void)removeImages:(NSSet *)value;


- (NSString *) scientificName;
- (NSArray * ) sortedImages;
@end

