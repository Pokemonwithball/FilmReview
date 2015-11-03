//
//  PKQSearchMovieModel.h
//  FilmReview
//
//  Created by tarena on 15/11/2.
//  Copyright © 2015年 tarena. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PKQSearchMovieSubjectModel,PKQSearchMovieSubjectImagesModel,PKQSearchMovieSubjectRatingModel,PKQSearchMovieSubjectCastsModel,PKQSearchMovieSubjectCastsAvatarsModel,PKQSearchMovieSubjectDirectorsModel,PKQSearchMovieSubjectDirectorsAvatarsModel;
@interface PKQSearchMovieModel : NSObject

@property (nonatomic, strong) NSArray<PKQSearchMovieSubjectModel *> *subjects;

@property (nonatomic, copy) NSString *title;

@property (nonatomic, assign) NSInteger count;

@property (nonatomic, assign) NSInteger total;

@property (nonatomic, assign) NSInteger start;

@end
@interface PKQSearchMovieSubjectModel : NSObject

@property (nonatomic, strong) PKQSearchMovieSubjectRatingModel *rating;

@property (nonatomic, copy) NSString *alt;

@property (nonatomic, copy) NSString *ID;

@property (nonatomic, copy) NSString *original_title;

@property (nonatomic, assign) NSInteger collect_count;

@property (nonatomic, strong) NSArray<NSString *> *pubdates;

@property (nonatomic, copy) NSString *mainland_pubdate;

@property (nonatomic, strong) NSArray<PKQSearchMovieSubjectDirectorsModel *> *directors;

@property (nonatomic, copy) NSString *title;

@property (nonatomic, copy) NSString *year;

@property (nonatomic, strong) PKQSearchMovieSubjectImagesModel *images;

@property (nonatomic, strong) NSArray<NSString *> *genres;

@property (nonatomic, strong) NSArray<PKQSearchMovieSubjectCastsModel *> *casts;

@property (nonatomic, strong) NSArray<NSString *> *durations;

@property (nonatomic, assign) BOOL has_video;

@property (nonatomic, copy) NSString *subtype;

@end

@interface PKQSearchMovieSubjectImagesModel : NSObject

@property (nonatomic, copy) NSString *small;

@property (nonatomic, copy) NSString *large;

@property (nonatomic, copy) NSString *medium;

@end

@interface PKQSearchMovieSubjectRatingModel : NSObject

@property (nonatomic, copy) NSString *stars;

@property (nonatomic, strong) NSNumber *average;
@property (nonatomic,strong) NSDictionary* details;
@property (nonatomic, assign) NSInteger max;

@property (nonatomic, assign) NSInteger min;

@end



@interface PKQSearchMovieSubjectCastsModel : NSObject

@property (nonatomic, copy) NSString *ID;

@property (nonatomic, copy) NSString *name_en;

@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSString *alt;

@property (nonatomic, strong) PKQSearchMovieSubjectCastsAvatarsModel *avatars;

@end

@interface PKQSearchMovieSubjectCastsAvatarsModel : NSObject

@property (nonatomic, copy) NSString *small;

@property (nonatomic, copy) NSString *large;

@property (nonatomic, copy) NSString *medium;

@end

@interface PKQSearchMovieSubjectDirectorsModel : NSObject

@property (nonatomic, copy) NSString *ID;

@property (nonatomic, copy) NSString *name_en;

@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSString *alt;

@property (nonatomic, strong) PKQSearchMovieSubjectDirectorsAvatarsModel *avatars;

@end

@interface PKQSearchMovieSubjectDirectorsAvatarsModel : NSObject

@property (nonatomic, copy) NSString *small;

@property (nonatomic, copy) NSString *large;

@property (nonatomic, copy) NSString *medium;

@end

