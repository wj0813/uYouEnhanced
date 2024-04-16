#import "AppIconOptionsController.h"
#import <YouTubeHeader/YTAssetLoader.h>

@interface AppIconOptionsController () <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) UIImageView *iconPreview;
@property (strong, nonatomic) NSArray<NSString *> *appIcons;
@property (assign, nonatomic) NSInteger selectedIconIndex;
@property (assign, nonatomic) NSInteger defaultIconIndex;

@end

@implementation AppIconOptionsController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.selectedIconIndex = 0;
    
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.view addSubview:self.tableView];

    UIImage *backImage = [UIImage imageNamed:@"yt_outline_chevron_left_ios_24pt" inBundle:[NSBundle mainBundle] compatibleWithTraitCollection:nil];
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithImage:backImage style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    self.navigationItem.leftBarButtonItem = backButton;

    UIBarButtonItem *resetButton = [[UIBarButtonItem alloc] initWithTitle:@"Reset" style:UIBarButtonItemStylePlain target:self action:@selector(resetIcon)];
    [resetButton setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor whiteColor], NSFontAttributeName: [UIFont fontWithName:@"YTSans-Medium" size:17]} forState:UIControlStateNormal];
    
    UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStylePlain target:self action:@selector(saveIcon)];
    [saveButton setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor whiteColor], NSFontAttributeName: [UIFont fontWithName:@"YTSans-Medium" size:17]} forState:UIControlStateNormal];
    
    self.navigationItem.rightBarButtonItems = @[resetButton, saveButton];
    
    self.iconPreview = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.bounds.size.width - 80, self.view.bounds.size.height - 80, 60, 60)];
    self.iconPreview.layer.cornerRadius = 10.0;
    self.iconPreview.clipsToBounds = YES;
    [self.view addSubview:self.iconPreview];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"uYouPlus" ofType:@"bundle"];
    NSBundle *bundle = [NSBundle bundleWithPath:path];
    self.appIcons = [bundle pathsForResourcesOfType:@"png" inDirectory:@"AppIcons"];
    
    if (![UIApplication sharedApplication].supportsAlternateIcons) {
        NSLog(@"Alternate icons are not supported on this device.");
    }
}

- (NSArray<NSString *> *)sortedAppIcons {
    return [self.appIcons sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
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
    [self sortedAppIcons];
    NSString *iconPath = self.appIcons[indexPath.row];
    cell.textLabel.text = [iconPath.lastPathComponent stringByDeletingPathExtension];
    
    UIImage *iconImage = [UIImage imageWithContentsOfFile:iconPath];
    cell.imageView.image = [self resizedImageWithImage:iconImage];
    cell.imageView.layer.cornerRadius = 10.0;
    cell.imageView.clipsToBounds = YES;
        
    if (indexPath.row == self.selectedIconIndex) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == 0) {
        self.selectedIconIndex = -1;
        [self.tableView reloadData];
        self.iconPreview.image = nil;
    } else {
        self.defaultIconIndex = 0;
        NSString *selectedIconPath = self.appIcons[indexPath.row - 1];
        UIImage *selectedIconImage = [UIImage imageWithContentsOfFile:selectedIconPath];
        self.iconPreview.image = [self resizedImageWithImage:selectedIconImage];
    }
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
            self.iconPreview.image = nil;
        }
    }];
}

- (void)saveIcon {
    NSString *selectedIconPath;
    if (self.selectedIconIndex == -1) {
        selectedIconPath = nil;
    } else {
        selectedIconPath = self.appIcons[self.selectedIconIndex];
    }
    
    [[UIApplication sharedApplication] setAlternateIconName:selectedIconPath completionHandler:^(NSError * _Nullable error) {
        if (error) {
            NSLog(@"Error setting alternate icon: %@", error.localizedDescription);
            [self showAlertWithTitle:@"Error" message:@"Failed to set alternate icon"];
        } else {
            NSLog(@"Alternate icon set successfully");
            [self showAlertWithTitle:@"Success" message:@"Alternate icon set successfully"];
        }
    }];
}

- (UIImage *)resizedImageWithImage:(UIImage *)image {
    CGFloat scale = [UIScreen mainScreen].scale;
    CGSize newSize = CGSizeMake(image.size.width / scale, image.size.height / scale);
    UIGraphicsBeginImageContextWithOptions(newSize, NO, scale);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *resizedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return resizedImage;
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
