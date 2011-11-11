//
//  SaveCourseViewController.m
//  iRow
//
//  Created by David van Leeuwen on 03-11-11.
//  Copyright (c) 2011 strApps. All rights reserved.
//

#import "CourseViewController.h"
#import "iRowAppDelegate.h"
#import "utilities.h"

@implementation CourseViewController

@synthesize course;

// this assumes that there is a non-nil current courseData
- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        self.title = @"Current Course";
        settings = Settings.sharedInstance;
        iRowAppDelegate * delegate = (iRowAppDelegate*)[[UIApplication sharedApplication] delegate];
        courseData = [(MapViewController*)[delegate.tabBarController.viewControllers objectAtIndex:1] courseData];
//        course = settings.currentCourse;
//        [self editPressed:self];
    }
    return self;
}

// if the course is set, we should update our copy of the courseData
-(void)setCourse:(Course *)c {
    course=c;
    if (c!=nil && c.course != nil) {
        courseData = [NSKeyedUnarchiver unarchiveObjectWithData:c.course];
    }
}

-(void)editPressed:(id)sender {
    leftBarItem = self.navigationController.navigationItem.leftBarButtonItem;
    [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(savePressed:)] animated:YES];
    [self.navigationItem setLeftBarButtonItem:[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelPressed:)] animated:YES];
    if (course == nil) {
        course = (Course*)[NSEntityDescription insertNewObjectForEntityForName:@"Course" inManagedObjectContext:settings.moc];
        if (courseData) {
            course.course = [NSKeyedArchiver archivedDataWithRootObject:courseData];
            course.waterway = courseData.waterway;
            course.distance = [NSNumber numberWithFloat:courseData.length];
        }
    } 
    self.editing = YES;
}

-(void)restoreButtons {
    [self.navigationItem setLeftBarButtonItem:leftBarItem animated:YES];
    [self.navigationItem setRightBarButtonItem:self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(editPressed:)] animated:YES];  
    self.editing = NO;
}

-(void)cancelPressed:(id)sender {
    [self restoreButtons];
    [settings.moc rollback];
    [self.tableView reloadData]; // restore old values
}

-(void)savePressed:(id)sender {
    [self restoreButtons];
    NSError * error;
    if (![settings.moc save:&error]) {
        NSLog(@"Error saving changes)");
//        if (completionBlock != nil) completionBlock(nil);
    } else {
//        NSLog(@"course saved %@", currentCourse);
//        if (completionBlock != nil) completionBlock(rower);
    }
    //    [self.navigationController popViewControllerAnimated:YES];
}

-(void)setEditing:(BOOL)e {
    editing = e;
    for (UITableViewCell * c in self.tableView.visibleCells) {
        UITextField * tf = (UITextField*)c.accessoryView;
        tf.enabled = e;
        tf.clearButtonMode = e ? UITextFieldViewModeAlways : UITextFieldViewModeNever;
        tf.borderStyle = editing ? UITextBorderStyleRoundedRect : UITextBorderStyleNone;
    } 
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    if (course==nil) [self editPressed:self];
    else self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(editPressed:)];
//    name = [NSString stringWithFormat:@"%@ – %@",courseData.waterway,dispLength(courseData.length)];
//    waterway = courseData.waterway;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    switch (section) {
        case 0:
            return 2;
            break;
        case 1:
            return 2;
        default:
            break;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellIdentifiers[2] = { @"Editable",@"Cell"};  
    
    NSString * cellIdentifier = cellIdentifiers[indexPath.section];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    switch (indexPath.section) {
        case 0: {
            UITextField * textField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 150, 22)];   
            textField.delegate = self;
            textField.textAlignment = UITextAlignmentRight;
            textField.tag = indexPath.row;
            textField.enabled = editing;
            textField.borderStyle = editing ? UITextBorderStyleRoundedRect : UITextBorderStyleNone;
            textField.autocapitalizationType = UITextAutocapitalizationTypeWords;
            textField.autocorrectionType = UITextAutocorrectionTypeNo;
            textField.clearButtonMode = editing ? UITextFieldViewModeAlways : UITextFieldViewModeNever;
            switch (indexPath.row) {
                case 0:
                    cell.textLabel.text = @"Course name";
                    textField.placeholder = @"name";
                    textField.text = course.name;
                    break;
                case 1:
                    cell.textLabel.text = @"Waterway";
                    textField.placeholder = @"waterway";
                    textField.text = course.waterway;
                default:
                    break;
            }
            cell.accessoryView = textField;
            break;
        }
        case 1:
            switch (indexPath.row) {
                case 0:
                    cell.textLabel.text = @"distance";
                    cell.detailTextLabel.text = dispLength(course.distance.floatValue);
                    break;
                case 1:
                    cell.textLabel.text = @"#pins";
                    cell.detailTextLabel.text = [NSString stringWithFormat:@"%d",courseData.count];
                    break;
                case 2:
                    cell.textLabel.text = @"date";
                    break;
                default:
                    break;
            }
        default:
            break;
    }
    
    // Configure the cell...
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/


// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

#pragma mark - UITextFieldDelegate

// this make return remove the keyboard
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return NO;
}

-(void)textFieldDidEndEditing:(UITextField *)textField {
    NSLog(@"ended editing %d", textField.tag);
    switch (textField.tag) {
        case 0:
            course.name = textField.text;
            break;
        case 1:
            course.waterway = textField.text;
            break;
        default:
            break;
    }
}

@end