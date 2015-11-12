//
//  PKQNaviCinemaModel.h
//  FilmReview
//
//  Created by tarena on 15/11/3.
//  Copyright © 2015年 tarena. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PKQNaviCinemaEntriesModel,PKQNaviCinemaEntriesImagesModel,PKQNaviCinemaEntriesLocationModel,PKQNaviCinemaEntriesLocationCoordinateModel;



@interface PKQSimpleCinemaModel : NSObject
//电影院的名字
@property (strong,nonatomic) NSString* name;
//电影院ID
@property (strong,nonatomic) NSString* ID;
//地区
@property (strong,nonatomic) NSString *district;

@end




@interface PKQNaviCinemaModel : NSObject

@property (nonatomic, strong) NSArray<PKQNaviCinemaEntriesModel *> *entries;

@property (nonatomic, assign) NSInteger total;

@property (nonatomic, copy) NSString *title;

@end
@interface PKQNaviCinemaEntriesModel : NSObject

@property (nonatomic, strong) NSArray<NSString *> *phone;

@property (nonatomic, strong) PKQNaviCinemaEntriesImagesModel *images;

@property (nonatomic, assign) BOOL bookable;

@property (nonatomic, assign) BOOL has_tuan;

@property (nonatomic, assign) BOOL is_favorite;

@property (nonatomic, copy) NSString *title;

@property (nonatomic, copy) NSString *alt;

@property (nonatomic, copy) NSString *ID;

@property (nonatomic, strong) PKQNaviCinemaEntriesLocationModel *location;

@property (nonatomic, copy) NSString *schedule_url;

@property (nonatomic, copy) NSString *abbreviated_title;

@end

@interface PKQNaviCinemaEntriesImagesModel : NSObject

@property (nonatomic, copy) NSString *small;

@property (nonatomic, copy) NSString *large;

@property (nonatomic, copy) NSString *medium;

@end

@interface PKQNaviCinemaEntriesLocationModel : NSObject

@property (nonatomic, copy) NSString *district;

@property (nonatomic, copy) NSString *address;

@property (nonatomic, strong) PKQNaviCinemaEntriesLocationCoordinateModel *coordinate;

@property (nonatomic, copy) NSString *city;

@property (nonatomic, assign) NSInteger distance;

@property (nonatomic, copy) NSString *map_url;

@end

@interface PKQNaviCinemaEntriesLocationCoordinateModel : NSObject

@property (nonatomic, strong) NSNumber* longitude;

@property (nonatomic, strong) NSNumber* latitude;

@end

