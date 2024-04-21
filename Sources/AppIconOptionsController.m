#import "AppIconOptionsController.h"
#import <YouTubeHeader/YTAssetLoader.h>

@interface AppIconOptionsController () <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSArray<NSString *> *appIcons;
@property (assign, nonatomic) NSInteger selectedIconIndex;
@property (strong, nonatomic) UIImageView *backButton;

@end

@implementation AppIconOptionsController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"Change App Icon";
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName: [UIFont fontWithName:@"YTSans-Bold" size:22], NSForegroundColorAttributeName: [UIColor whiteColor]}];

    self.selectedIconIndex = -1;
    
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.view addSubview:self.tableView];

    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    UIImage *backImage = [UIImage imageNamed:@"yt_outline_chevron_left_ios_24pt" inBundle:[NSBundle mainBundle] compatibleWithTraitCollection:nil];
    if (!backImage) {
        backButton.image = [UIImage systemImageNamed:@"chevron.backward"];
    } else {
        backButton.image = backImage;
    }
    [backButton setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor whiteColor], NSFontAttributeName: [UIFont fontWithName:@"YTSans-Medium" size:17]} forState:UIControlStateNormal];
    self.navigationItem.leftBarButtonItem = backButton;

    UIColor *buttonColor = [UIColor colorWithRed:203.0/255.0 green:22.0/255.0 blue:51.0/255.0 alpha:1.0];
    UIBarButtonItem *resetButton = [[UIBarButtonItem alloc] initWithTitle:@"Reset" style:UIBarButtonItemStylePlain target:self action:@selector(resetIcon)];
    [resetButton setTitleTextAttributes:@{NSForegroundColorAttributeName: buttonColor, NSFontAttributeName: [UIFont fontWithName:@"YTSans-Medium" size:17]} forState:UIControlStateNormal];
    
    UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStylePlain target:self action:@selector(saveIcon)];
    [saveButton setTitleTextAttributes:@{NSForegroundColorAttributeName: buttonColor, NSFontAttributeName: [UIFont fontWithName:@"YTSans-Medium" size:17]} forState:UIControlStateNormal];
    
    self.navigationItem.rightBarButtonItems = @[saveButton, resetButton];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"uYouPlus" ofType:@"bundle"];
    NSBundle *bundle = [NSBundle bundleWithPath:path];
    self.appIcons = [bundle pathsForResourcesOfType:@"png" inDirectory:@"AppIcons"];
    
    if (![UIApplication sharedApplication].supportsAlternateIcons) {
        NSLog(@"Alternate icons are not supported on this device.");
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.appIcons.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    }
    
    NSString *iconPath = self.appIcons[indexPath.row];
    cell.textLabel.text = [iconPath.lastPathComponent stringByDeletingPathExtension];
    
    UIImage *iconImage = [UIImage imageWithContentsOfFile:iconPath];
    cell.imageView.image = iconImage;
    cell.imageView.layer.cornerRadius = 10.0;
    cell.imageView.clipsToBounds = YES;
    cell.imageView.frame = CGRectMake(10, 10, 40, 40);
    cell.textLabel.frame = CGRectMake(60, 10, self.view.frame.size.width - 70, 40);
    
    if (indexPath.row == self.selectedIconIndex) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    self.selectedIconIndex = indexPath.row;
    [self.tableView reloadData];
}

- (void)resetIcon {
    [[UIApplication sharedApplication] setAlternateIconName:nil completionHandler:^(NSError * _Nullable error) {
        if (error) {
            NSLog(@"Error resetting icon: %@", error.localizedDescription);
            [self showAlertWithTitle:@"Error" message:@"Failed to reset icon"];
        } else {
            NSLog(@"Icon reset successfully");
            [self showAlertWithTitle:@"Success" message:@"Icon reset successfully"];
            [self.tableView reloadData];
        }
    }];
}

- (void)saveIcon {
    NSString *selectedIconPath = self.selectedIconIndex >= 0 ? self.appIcons[self.selectedIconIndex] : nil;
    if (selectedIconPath) {
        NSURL *iconURL = [NSURL fileURLWithPath:selectedIconPath];
        if ([[UIApplication sharedApplication] respondsToSelector:@selector(setAlternateIconName:completionHandler:)]) {
            [[UIApplication sharedApplication] setAlternateIconName:selectedIconPath completionHandler:^(NSError * _Nullable error) {
                if (error) {
                    NSLog(@"Error setting alternate icon: %@", error.localizedDescription);
                    [self showAlertWithTitle:@"Error" message:@"Failed to set alternate icon"];
                } else {
                    NSLog(@"Alternate icon set successfully");
                    [self showAlertWithTitle:@"Success" message:@"Alternate icon set successfully"];
                }
            }];
        } else {
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            [dict setObject:iconURL forKey:@"iconURL"];
            [dict writeToFile:[[NSBundle mainBundle] pathForResource:@"Info" ofType:@"plist"] atomically:YES];
            
            [self showAlertWithTitle:@"Alternate Icon" message:@"Please restart the app to apply the alternate icon"];
        }
    }
}

- (void)showAlertWithTitle:(NSString *)title message:(NSString *)message {
    dispatch_async(dispatch_get_main_queue(), ^{
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:okAction];
        [self presentViewController:alert animated:YES completion:nil];
    });
}

- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
