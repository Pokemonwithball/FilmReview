//
//  PKQBuyMovicModel.h
//  FilmReview
//
//  Created by tarena on 15/11/14.
//  Copyright © 2015年 tarena. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PKQBuyMovieEntriesModel,PKQBuyMovieEntriesSiteModel,PKQBuyMovieEntriesImagesModel,PKQBuyMovieEntriesLocationModel,PKQBuyMovieEntriesLocationCoordinateModel;
@interface PKQBuyMovicModel : NSObject

@property (nonatomic, copy) NSString *title;

@property (nonatomic, assign) NSInteger total;

@property (nonatomic, strong) NSArray<PKQBuyMovieEntriesModel *> *entries;

@end
@interface PKQBuyMovieEntriesModel : NSObject

@property (nonatomic, strong) PKQBuyMovieEntriesSiteModel *site;

@property (nonatomic, copy) NSString *min_price;

@property (nonatomic, assign) BOOL has_promotion;

@property (nonatomic, assign) NSInteger all_show_count;

@property (nonatomic, assign) BOOL is_favorite;

@property (nonatomic, copy) NSString *earliest_show_date;

@property (nonatomic, assign) NSInteger left_show_count;

@property (nonatomic, copy) NSString *max_price;

@end

@interface PKQBuyMovieEntriesSiteModel : NSObject

@property (nonatomic, strong) NSArray<NSString *> *phone;

@property (nonatomic, strong) PKQBuyMovieEntriesImagesModel *images;

@property (nonatomic, assign) BOOL bookable;

@property (nonatomic, assign) BOOL has_tuan;

@property (nonatomic, assign) BOOL is_favorite;

@property (nonatomic, copy) NSString *title;

@property (nonatomic, copy) NSString *alt;

@property (nonatomic, copy) NSString *ID;

@property (nonatomic, strong) PKQBuyMovieEntriesLocationModel *location;

@property (nonatomic, copy) NSString *schedule_url;

@property (nonatomic, copy) NSString *abbreviated_title;

@end

@interface PKQBuyMovieEntriesImagesModel : NSObject

@property (nonatomic, copy) NSString *small;

@property (nonatomic, copy) NSString *large;

@property (nonatomic, copy) NSString *medium;

@end

@interface PKQBuyMovieEntriesLocationModel : NSObject

@property (nonatomic, copy) NSString *district;

@property (nonatomic, copy) NSString *address;

@property (nonatomic, strong) PKQBuyMovieEntriesLocationCoordinateModel *coordinate;

@property (nonatomic, copy) NSString *city;

@property (nonatomic, copy) NSString *map_url;

@end

@interface PKQBuyMovieEntriesLocationCoordinateModel : NSObject

@property (nonatomic, assign) CGFloat longitude;

@property (nonatomic, assign) CGFloat latitude;

@end

