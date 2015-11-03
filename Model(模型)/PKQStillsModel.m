//
//  PKQStillsModel.m
//  FilmReview
//
//  Created by tarena on 15/10/25.
//  Copyright © 2015年 tarena. All rights reserved.
//

#import "PKQStillsModel.h"
#import "MJExtension.h"
@implementation PKQStillsModel
-(NSDictionary*)objectClassInArray{
    return @{@"entry":[PKQStillsEntryModel class]};
}

@end

@implementation PKQStillsEntryModel
- (NSDictionary*)objectClassInArray{
    return @{@"link":[PKQStillsEntryLinkModel class]};
}

@end

@implementation PKQStillsEntryLinkModel

-(NSDictionary *)replacedKeyFromPropertyName{
    return @{@"rel":@"@rel",@"href":@"@href"};
}

@end
