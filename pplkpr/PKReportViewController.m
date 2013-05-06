

#import "PKAppDelegate.h"
#import "PKReportViewController.h"


@implementation PKReportViewController


@synthesize whoTextField;
@synthesize howTextField;
@synthesize ratingSlider;
@synthesize submitButton;
@synthesize label;
@synthesize whoString;
@synthesize howString;

@synthesize selectedFriendsView = _friendResultText;
@synthesize friendPickerController = _friendPickerController;
@synthesize searchBar = _searchBar;
@synthesize searchText = _searchText;

@synthesize mode;


- (void)viewDidLoad {
  // When the user starts typing, show the clear button in the text field.
  whoTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
  howTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
  // When the view first loads, display the placeholder text that's in the
  // text field in the label.
  label.text = whoTextField.placeholder;
  mode = 0;
  
  self.searchBar = nil;
  
  [super viewDidLoad];
}

- (void)viewDidUnload {
    self.selectedFriendsView = nil;
    self.friendPickerController = nil;
    
    [super viewDidUnload];
}


- (void)dealloc {
	[whoTextField release];
	[howTextField release];
  [ratingSlider release];
  [submitButton release];
	[whoString release];
  [howString release];
  [label release];
  [super dealloc];
}


- (IBAction)pickFriendsButtonClick:(id)sender {
    // FBSample logic
    // if the session is open, then load the data for our view controller
    if (!FBSession.activeSession.isOpen) {
      NSLog(@"opening session");
        // if the session is closed, then we open it here, and establish a handler for state changes
        [FBSession openActiveSessionWithReadPermissions:nil
                                           allowLoginUI:YES
                                      completionHandler:^(FBSession *session,
                                                             FBSessionState state,
                                                          NSError *error) {
                                        NSLog(@"opening session return");
            if (error) {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                                    message:error.localizedDescription
                                                                   delegate:nil
                                                          cancelButtonTitle:@"OK"
                                                          otherButtonTitles:nil];
                [alertView show];
            } else if (session.isOpen) {
              NSLog(@"session is open");
                [self pickFriendsButtonClick:sender];
            } else NSLog(@"session is not open");
        }];
        return;
    }

    if (self.friendPickerController == nil) {
        // Create friend picker, and get data loaded into it.
        self.friendPickerController = [[FBFriendPickerViewController alloc] init];
        self.friendPickerController.title = @"Pick Friends";
        self.friendPickerController.delegate = self;
    }

    [self.friendPickerController loadData];
    [self.friendPickerController clearSelection];

    [self presentViewController:self.friendPickerController animated:YES  completion:^(void){[self addSearchBarToFriendPickerView];}];
       
}

- (void)facebookViewControllerDoneWasPressed:(id)sender {
    NSMutableString *text = [[NSMutableString alloc] init];
    
    // we pick up the users from the selection, and create a string that we use to update the text view
    // at the bottom of the display; note that self.selection is a property inherited from our base class
    for (id<FBGraphUser> user in self.friendPickerController.selection) {
        if ([text length]) {
            [text appendString:@", "];
        }
        [text appendString:user.name];
    }
    
    [self fillTextBoxAndDismiss:text.length > 0 ? text : @"<None>"];
}

- (void)facebookViewControllerCancelWasPressed:(id)sender {
    [self fillTextBoxAndDismiss:@"<Cancelled>"];
}

- (void)fillTextBoxAndDismiss:(NSString *)text {
    self.selectedFriendsView.text = text;
    
    [self dismissModalViewControllerAnimated:YES];
}

- (void)addSearchBarToFriendPickerView
{
  if (self.searchBar == nil) {
    CGFloat searchBarHeight = 44.0;
    self.searchBar =
    [[UISearchBar alloc]
     initWithFrame:
     CGRectMake(0,0,
                self.view.bounds.size.width,
                searchBarHeight)];
    self.searchBar.autoresizingMask = self.searchBar.autoresizingMask |
    UIViewAutoresizingFlexibleWidth;
    self.searchBar.delegate = self;
    self.searchBar.showsCancelButton = YES;
    
    [self.friendPickerController.canvasView addSubview:self.searchBar];
    CGRect newFrame = self.friendPickerController.view.bounds;
    newFrame.size.height -= searchBarHeight;
    newFrame.origin.y = searchBarHeight;
    self.friendPickerController.tableView.frame = newFrame;
  }
}

- (void) handleSearch:(UISearchBar *)searchBar {
  [searchBar resignFirstResponder];
  self.searchText = searchBar.text;
  [self.friendPickerController updateView];
}

- (void)searchBarSearchButtonClicked:(UISearchBar*)searchBar
{
  [self handleSearch:searchBar];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *) searchBar {
  self.searchText = nil;
  [searchBar resignFirstResponder];
}

- (BOOL)friendPickerViewController:(FBFriendPickerViewController *)friendPicker
                 shouldIncludeUser:(id<FBGraphUser>)user
{
  if (self.searchText && ![self.searchText isEqualToString:@""]) {
    NSRange result = [user.name
                      rangeOfString:self.searchText
                      options:NSCaseInsensitiveSearch];
    if (result.location != NSNotFound) {
      return YES;
    } else {
      return NO;
    }
  } else {
    return YES;
  }
  return YES;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)orientation
{
    return YES;
}

- (IBAction)sendReport:(id)sender {
	
	// Store the text of the text field in the 'string' instance variable.
	self.whoString = whoTextField.text;
	self.howString = howTextField.text;
  // Set the text of the label to the value of the 'string' instance variable.
  
  
  NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:@"http://pplkpr.jit.su/report?who=%@&how=%@&rating=%f", whoTextField.text, howTextField.text, ratingSlider.value]];
  NSURLRequest *theRequest=[NSURLRequest requestWithURL:URL
                                            cachePolicy:NSURLRequestUseProtocolCachePolicy
                                        timeoutInterval:60.0];
  
  
  // create the connection with the request
  // and start loading the data
  NSURLConnection *theConnection=[[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
  if (theConnection) {
    // Create the NSMutableData to hold the received data.
    // receivedData is an instance variable declared elsewhere.
    //label.text = [[NSString alloc] initWithData:[[NSMutableData data] retain] encoding:NSUTF8StringEncoding];
    label.text = @"success";
    [self reset];
  } else {
    // Inform the user that the connection failed.
    label.text = @"fail";
  }
  
}

- (void)reset {
  label.text = @"";
  whoTextField.text = @"";
  howTextField.text = @"";
  self.whoString = @"";
  self.howString = @"";
  ratingSlider.value = 0.5;
}

- (BOOL)textFieldShouldReturn:(UITextField *)theTextField {
	if (theTextField == whoTextField) {
    NSLog(@"returdn");
		[whoTextField resignFirstResponder];
	} else if (theTextField == howTextField) {
    [howTextField resignFirstResponder];
  }
	return YES;
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
  [whoTextField resignFirstResponder];
  whoTextField.text = self.whoString;
  [howTextField resignFirstResponder];
  howTextField.text = self.howString;
  [super touchesBegan:touches withEvent:event];
}



#pragma mark -

@end


