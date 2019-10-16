//
//  PGBook.h
//  PGBooks
//
//  Created by ipagong on 13/10/2019.
//  Copyright © 2019 ipagong. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
     "title": "Learning C++ by Building Games with Unreal Engine 4, 2nd Edition",
     "subtitle": "A beginner's guide to learning 3D game development with C++ and UE4",
     "isbn13": "9781788476249",
     "price": "$35.99",
     "image": "https://itbook.store/img/books/9781788476249.png",
     "url": "https://itbook.store/books/9781788476249"
 */

/*
     "error": "0",
     "title": "Build Reactive Websites with RxJS",
     "subtitle": "Master Observables and Wrangle Events",
     "authors": "Randall Koutnik",
     "publisher": "The Pragmatic Programmers",
     "language": "English",
     "isbn10": "1680502956",
     "isbn13": "9781680502954",
     "pages": "194",
     "year": "2018",
     "rating": "5",
     "desc": "Upgrade your skill set, succeed at work, and above all, avoid the many headaches that come with modern front-end development. Simplify your codebase with hands-on examples pulled from real-life applications. Master the mysteries of asynchronous state management, detangle puzzling race conditions, an...",
     "price": "$28.98",
     "image": "https://itbook.store/img/books/9781680502954.png",
     "url": "https://itbook.store/books/9781680502954"
 */

@interface PGBook : NSObject

@property (nonatomic, strong, nonnull)  NSString * title;
@property (nonatomic, strong, nonnull)  NSString * subtitle;
@property (nonatomic, strong, nonnull)  NSString * isbn13;
@property (nonatomic, strong, nonnull)  NSString * price;
@property (nonatomic, strong, nonnull)  NSString * image;
@property (nonatomic, strong, nonnull)  NSString * url;

@property (nonatomic, strong, nullable) NSString * authors;
@property (nonatomic, strong, nullable) NSString * publisher;
@property (nonatomic, strong, nullable) NSString * language;
@property (nonatomic, strong, nullable) NSString * isbn10;
@property (nonatomic, strong, nullable) NSString * pages;
@property (nonatomic, strong, nullable) NSString * year;
@property (nonatomic, strong, nullable) NSString * rating;
@property (nonatomic, strong, nullable) NSString * desc;

- (instancetype _Nullable)initWithAttributes:(NSDictionary *_Nullable)attrs;

- (nullable NSString *)etcs;

@end

