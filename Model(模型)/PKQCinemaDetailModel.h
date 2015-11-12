//
//  PKQCinemaDetailModel.h
//  FilmReview
//
//  Created by tarena on 15/11/12.
//  Copyright © 2015年 tarena. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PKQCinemaDetailLocationImagesModel,PKQCinemaDetailLocationModel,PKQCinemaDetailLocationCoordinateModel;
@interface PKQCinemaDetailModel : NSObject


@property (nonatomic, strong) PKQCinemaDetailLocationModel *location;

@property (nonatomic, copy) NSString *title;

@property (nonatomic, copy) NSString *alt;

@property (nonatomic, copy) NSString *how_to_drive;

@property (nonatomic, assign) BOOL is_favorite;

@property (nonatomic, strong) PKQCinemaDetailLocationImagesModel *images;

@property (nonatomic, copy) NSString *member_policy;

@property (nonatomic, copy) NSString *schedule_url;

@property (nonatomic, copy) NSString *ID;

@property (nonatomic, strong) NSArray<NSString *> *cast_devices;

@property (nonatomic, copy) NSString *vip_hall_count;

@property (nonatomic, assign) BOOL bookable;

@property (nonatomic, copy) NSString *website;

@property (nonatomic, assign) NSInteger hall_count;

@property (nonatomic, assign) BOOL has_tuan;

@property (nonatomic, strong) NSArray<NSString *> *phone;

@property (nonatomic, copy) NSString *abbreviated_title;

@property (nonatomic, copy) NSString *discount_policy;

@property (nonatomic, copy) NSString *parking;

@property (nonatomic, copy) NSString *online_ticket;

@property (nonatomic, copy) NSString *opentime;

@property (nonatomic, copy) NSString *desc;

@end
@interface PKQCinemaDetailLocationImagesModel : NSObject

@property (nonatomic, copy) NSString *small;

@property (nonatomic, copy) NSString *large;

@property (nonatomic, copy) NSString *medium;

@end

@interface PKQCinemaDetailLocationModel : NSObject

@property (nonatomic, copy) NSString *district;

@property (nonatomic, copy) NSString *address;

@property (nonatomic, strong) PKQCinemaDetailLocationCoordinateModel *coordinate;

@property (nonatomic, copy) NSString *city;

@property (nonatomic, copy) NSString *map_url;

@end

@interface PKQCinemaDetailLocationCoordinateModel : NSObject

@property (nonatomic, assign) CGFloat longitude;

@property (nonatomic, assign) CGFloat latitude;

@end

