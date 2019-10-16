//
//  PGBook.m
//  PGBooks
//
//  Created by ipagong on 13/10/2019.
//  Copyright © 2019 ipagong. All rights reserved.
//

#import "PGBook.h"

@implementation PGBook

- (instancetype _Nullable)initWithAttributes:(NSDictionary *_Nullable)attrs
{
    self = [super init];
    if (!self) { return nil; }
    
    self.title      = [attrs valueForKey: @"title"];
    self.subtitle   = [attrs valueForKey: @"subtitle"];
    self.isbn13     = [attrs valueForKey: @"isbn13"];
    self.price      = [attrs valueForKey: @"price"];
    self.image      = [attrs valueForKey: @"image"];
    self.url        = [attrs valueForKey: @"url"];
    
    self.authors    = [attrs valueForKey: @"authors"];
    self.publisher  = [attrs valueForKey: @"publisher"];
    self.language   = [attrs valueForKey: @"language"];
    self.isbn10     = [attrs valueForKey: @"isbn10"];
    self.pages      = [attrs valueForKey: @"pages"];
    self.year       = [attrs valueForKey: @"year"];
    self.rating     = [attrs valueForKey: @"rating"];
    self.desc       = [attrs valueForKey: @"desc"];
    
    return self;
}

#pragma mark - NSCoding

- (id)initWithCoder:(NSCoder *)decoder {
    self = [super init];
    
    if (!self) { return nil; }
    
    self.title      = [decoder decodeObjectForKey: @"title"];
    self.subtitle   = [decoder decodeObjectForKey: @"subtitle"];
    self.isbn13     = [decoder decodeObjectForKey: @"isbn13"];
    self.price      = [decoder decodeObjectForKey: @"price"];
    self.image      = [decoder decodeObjectForKey: @"image"];
    self.url        = [decoder decodeObjectForKey: @"url"];
    
    self.authors    = [decoder decodeObjectForKey: @"authors"];
    self.publisher  = [decoder decodeObjectForKey: @"publisher"];
    self.language   = [decoder decodeObjectForKey: @"language"];
    self.isbn10     = [decoder decodeObjectForKey: @"isbn10"];
    self.pages      = [decoder decodeObjectForKey: @"pages"];
    self.year       = [decoder decodeObjectForKey: @"year"];
    self.rating     = [decoder decodeObjectForKey: @"rating"];
    self.desc       = [decoder decodeObjectForKey: @"desc"];
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject: self.title        forKey: @"title"];
    [encoder encodeObject: self.subtitle     forKey: @"subtitle"];
    [encoder encodeObject: self.isbn13       forKey: @"isbn13"];
    [encoder encodeObject: self.price        forKey: @"price"];
    [encoder encodeObject: self.image        forKey: @"image"];
    [encoder encodeObject: self.url          forKey: @"url"];
    [encoder encodeObject: self.authors      forKey: @"authors"];
    [encoder encodeObject: self.publisher    forKey: @"publisher"];
    [encoder encodeObject: self.language     forKey: @"language"];
    [encoder encodeObject: self.isbn10       forKey: @"isbn10"];
    [encoder encodeObject: self.pages        forKey: @"pages"];
    [encoder encodeObject: self.year         forKey: @"year"];
    [encoder encodeObject: self.rating       forKey: @"rating"];
    [encoder encodeObject: self.desc         forKey: @"desc"];
}

#pragma mark - NSCopying

- (id)copyWithZone:(NSZone *)zone {
    PGBook *book = [[self.class allocWithZone:zone] init];
    
    book->_title      = self.title;
    book->_subtitle   = self.subtitle;
    book->_isbn13     = self.isbn13;
    book->_price      = self.price;
    book->_image      = self.image;
    book->_url        = self.url;
    book->_authors    = self.authors;
    book->_publisher  = self.publisher;
    book->_language   = self.language;
    book->_isbn10     = self.isbn10;
    book->_pages      = self.pages;
    book->_year       = self.year;
    book->_rating     = self.rating;
    book->_desc       = self.desc;
    
    return book;
}

#pragma mark - Equality

- (NSUInteger)hash {
    return self.isbn13.hash;
}

- (BOOL)isEqual:(PGBook*)object {
    if ([object isKindOfClass:[PGBook class]] == NO) { return NO; }
    return [self.isbn13 isEqualToString:object.isbn13];
}

#pragma mark -

- (NSString *)etcs {
    NSMutableArray *result = [NSMutableArray array];
    
    if (self.year) {
        [result addObject:[NSString stringWithFormat:@"%@", self.year]];
    }
    
    if (self.pages) {
        [result addObject:[NSString stringWithFormat:@"(%@ pages)", self.pages]];
    }
    
    return [result componentsJoinedByString:@", "];
}

@end

