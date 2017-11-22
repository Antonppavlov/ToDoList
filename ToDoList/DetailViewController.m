//
//  ViewController.m
//  ToDoList
//
//  Created by Anton Pavlov on 21.11.2017.
//  Copyright © 2017 Anton Pavlov. All rights reserved.
//
#import "DetailViewController.h"

@interface DetailViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (weak, nonatomic) IBOutlet UIButton *buttonSave;


@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.buttonSave.enabled = NO;
    self.datePicker.minimumDate = [NSDate date];
    
    
    [self.buttonSave addTarget:self action:@selector(save) forControlEvents:UIControlEventTouchUpInside];
    [self.datePicker addTarget:self action:@selector(datePickerValueChange) forControlEvents:UIControlEventValueChanged];
    
    UITapGestureRecognizer * handleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleEndEditing)];
    [self.view addGestureRecognizer:handleTap];

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) datePickerValueChange{
    
    self.eventDate = self.datePicker.date;
    NSLog(@"self.eventDate: %@", self.eventDate);
}

- (void) save{
    if(self.eventDate){
        if([self.eventDate compare:[NSDate date]] == NSOrderedSame){
            [self showAlertWithMessage:@"Дата будущего события не может совпадать с текущей датой"];
        }
         else if([self.eventDate compare:[NSDate date]] == NSOrderedAscending){
              [self showAlertWithMessage:@"Дата будущего события не может быть ранее текущей даты"];
        }else{
             [self setNotification];
        }

    }else{
           [self showAlertWithMessage:@"Для сохранения события значение даты должно быть поздним"];
    }
    
    
}

-(void) setNotification{
    NSString * eventInfo = self.textField.text;
    
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"HH:mm dd.MMMM.yyyy";
    
    NSString * eventDate = [dateFormatter stringFromDate:self.eventDate];
    
    NSDictionary * dict = [[NSDictionary alloc] initWithObjectsAndKeys:
                           eventInfo,@"eventInfo",
                           eventDate,@"eventDate",
                           nil];
    
    
    UILocalNotification * notification = [[UILocalNotification alloc] init];
    notification.userInfo = dict;
    notification.timeZone= [NSTimeZone defaultTimeZone];
    notification.fireDate = self.eventDate;
    notification.alertBody = eventInfo;
    notification.applicationIconBadgeNumber = 1;
    notification.soundName = UILocalNotificationDefaultSoundName;
    
    [[UIApplication sharedApplication] scheduleLocalNotification:notification];
    
}

- (void) handleEndEditing{
    if(self.textField.text.length>0){
        self.buttonSave.enabled =YES;
    }
   [self.view endEditing:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    if([textField isEqual:self.textField]){
         [self.view endEditing:YES];
       
            if(self.textField.text.length>0){
                self.buttonSave.enabled =YES;
                 return YES;
            }else{
                [self showAlertWithMessage:@"Для сохранения события введите текст в текстовое поле"];
            }
          self.buttonSave.enabled =NO;
        
    }
    
     return NO;
   
}

- (void) showAlertWithMessage: (NSString *) message{
    
    UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"Внимание!" message:message delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    [alert show];
}

@end
