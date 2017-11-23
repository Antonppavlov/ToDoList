//
//  ViewController.h
//  ToDoList
//
//  Created by Anton Pavlov on 21.11.2017.
//  Copyright © 2017 Anton Pavlov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController

@property(nonatomic, strong) NSString *eventInfo;
@property(nonatomic, strong) NSDate *eventDate;
@property(nonatomic, assign) BOOL isDetail;


@end

