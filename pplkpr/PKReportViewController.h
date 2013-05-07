

#import <UIKit/UIKit.h>

@interface PKReportViewController : UIViewController<UITextFieldDelegate, FBFriendPickerDelegate> {

  IBOutlet UITextField *whoTextField;
  IBOutlet UITextField *howTextField;
  IBOutlet UISlider *ratingSlider;
  IBOutlet UIButton *submitButton;
  IBOutlet UILabel *label;
  NSString *whoString;
  NSString *howString;
  
  FBFriendPickerViewController *friendPickerController;
  UISearchBar *searchBar;
  NSString *searchText;
  
  int mode;

}


@property (nonatomic, retain) UITextField *whoTextField;
@property (nonatomic, retain) UITextField *howTextField;
@property (nonatomic, retain) UISlider *ratingSlider;
@property (nonatomic, retain) UIButton *submitButton;
@property (nonatomic, retain) UILabel *label;
@property (nonatomic, copy) NSString *whoString;
@property (nonatomic, copy) NSString *howString;

@property (retain, nonatomic) FBFriendPickerViewController *friendPickerController;
@property (retain, nonatomic) UISearchBar *searchBar;
@property (retain, nonatomic) NSString *searchText;

@property (nonatomic, assign) int mode;

- (void)fillTextBoxAndDismiss:(NSString *)text;
- (void)reset;
- (IBAction)pickFriendsButtonClick:(id)sender;
- (IBAction)sendReport:(id)sender;

@end


