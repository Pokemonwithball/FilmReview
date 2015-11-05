//
//  PKQCinemaMovieModel.h
//  FilmReview
//
//  Created by tarena on 15/11/5.
//  Copyright © 2015年 tarena. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PKQCinemaMovieEntriesModel,PKQCinemaMovieEntriesSubjectModel,PKQCinemaMovieEntriesSubjectImagesModel,PKQCinemaMovieEntriesHallModel,PKQCinemaMovieEntriesSiteModel,PKQCinemaMovieEntriesSiteImagesModel,PKQCinemaMovieEntriesSiteImagesLocationModel,PKQCinemaMovieEntriesSiteImagesLocationCoordinateModel;
@interface PKQCinemaMovieModel : NSObject

@property (nonatomic, copy) NSString *title;

@property (nonatomic, assign) NSInteger total;

@property (nonatomic, strong) NSArray<PKQCinemaMovieEntriesModel *> *entries;

@end
@interface PKQCinemaMovieEntriesModel : NSObject

@property (nonatomic, strong) PKQCinemaMovieEntriesSubjectModel *subject;

@property (nonatomic, copy) NSString *ID;

@property (nonatomic, assign) BOOL early;

@property (nonatomic, assign) BOOL is_promotion;

@property (nonatomic, copy) NSString *bookid;

@property (nonatomic, copy) NSString *version;

@property (nonatomic, strong) NSArray *through_subjects;

@property (nonatomic, strong) PKQCinemaMovieEntriesHallModel *hall;

@property (nonatomic, copy) NSString *time;

@property (nonatomic, assign) BOOL has_throughs;

@property (nonatomic, assign) NSInteger source;

@property (nonatomic, copy) NSString *special;

@property (nonatomic, copy) NSString *price;

@property (nonatomic, copy) NSString *date;

@property (nonatomic, copy) NSString *language;

@property (nonatomic, strong) PKQCinemaMovieEntriesSiteModel *site;

@property (nonatomic, assign) NSInteger duration;

@property (nonatomic, assign) BOOL bookable;

@end

@interface PKQCinemaMovieEntriesSubjectModel : NSObject

@property (nonatomic, copy) NSString *rating;

@property (nonatomic, copy) NSString *pubdate;

@property (nonatomic, strong) PKQCinemaMovieEntriesSubjectImagesModel *images;

@property (nonatomic, copy) NSString *ID;

@property (nonatomic, copy) NSString *title;

@property (nonatomic, assign) NSInteger collection;

@property (nonatomic, copy) NSString *orignal_title;

@property (nonatomic, copy) NSString *stars;

@property (nonatomic, assign) NSInteger wish;

@property (nonatomic, copy) NSString *original_title;

@end

@interface PKQCinemaMovieEntriesSubjectImagesModel : NSObject

@property (nonatomic, copy) NSString *large;

@property (nonatomic, copy) NSString *small;

@property (nonatomic, copy) NSString *medium;

@end

@interface PKQCinemaMovieEntriesHallModel : NSObject

@property (nonatomic, copy) NSString *ID;

@property (nonatomic, copy) NSString *title;

@end

@interface PKQCinemaMovieEntriesSiteModel : NSObject

@property (nonatomic, strong) NSArray<NSString *> *phone;

@property (nonatomic, strong) PKQCinemaMovieEntriesSiteImagesModel *images;

@property (nonatomic, assign) BOOL bookable;

@property (nonatomic, assign) BOOL has_tuan;

@property (nonatomic, assign) BOOL is_favorite;

@property (nonatomic, copy) NSString *title;

@property (nonatomic, copy) NSString *alt;

@property (nonatomic, copy) NSString *ID;

@property (nonatomic, strong) PKQCinemaMovieEntriesSiteImagesLocationModel *location;

@property (nonatomic, copy) NSString *schedule_url;

@property (nonatomic, copy) NSString *abbreviated_title;

@end

@interface PKQCinemaMovieEntriesSiteImagesModel : NSObject

@property (nonatomic, copy) NSString *small;

@property (nonatomic, copy) NSString *large;

@property (nonatomic, copy) NSString *medium;

@end

@interface PKQCinemaMovieEntriesSiteImagesLocationModel : NSObject

@property (nonatomic, copy) NSString *district;

@property (nonatomic, copy) NSString *address;

@property (nonatomic, strong) PKQCinemaMovieEntriesSiteImagesLocationCoordinateModel *coordinate;

@property (nonatomic, copy) NSString *city;

@property (nonatomic, copy) NSString *map_url;

@end

@interface PKQCinemaMovieEntriesSiteImagesLocationCoordinateModel : NSObject

@property (nonatomic, assign) CGFloat longitude;

@property (nonatomic, assign) CGFloat latitude;

@end

