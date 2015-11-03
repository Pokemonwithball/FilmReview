//
//  PKQStillsModel.h
//  FilmReview
//
//  Created by tarena on 15/10/25.
//  Copyright © 2015年 tarena. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PKQStillsModel : NSObject
@property (strong,nonatomic) NSArray *entry;
@end


@interface PKQStillsEntryModel : NSObject
//第4个里面的href
@property (strong,nonatomic)NSArray *link;
@end

@interface PKQStillsEntryLinkModel : NSObject
@property (strong,nonatomic) NSString *rel;
@property (strong,nonatomic) NSString *href;

@end