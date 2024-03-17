import router from '@ohos.router';
import prompt from '@ohos.prompt';
import UserItem from '../common/bean/User';
import CommonUtils from '../common/utils/CommonUtils';
import { HomeFragment } from '../view/HomeFragment';
import { UserFragment } from '../view/UserFragment';
import { VideoFragment } from '../view/VideoFragment';
import { NovelFragment } from '../view/NovelFragment';
import promptAction from '@ohos.promptAction';
import Location from '../common/bean/Location';
import WeatherApiUtils from '../common/utils/WeaherApiUtils';
import Novel from '../common/bean/Novel';
import ViewModel from '../viewmodel/ViewModel';
import SubWindowUtils from '../common/utils/SubWindowUtils';
import ServiceApiUtils from '../common/utils/ServiceApiUtils';

let TAG = 'HomePageDebug'
PersistentStorage.PersistProp('firstUse', "true");
AppStorage.SetOrCreate('locations', []);
AppStorage.SetOrCreate('novels', []);

@Entry
@Component
struct HomePage {
  @Provide user: UserItem = new UserItem();
  @Provide isLogin: boolean = false;
  @State currentFragment: number = 0;
  private tabsController: TabsController = new TabsController();

  @Builder TabBuilder(title: string, pageIndex: number, selectedImg: Resource, normalImg: Resource){
    Column() {
      Image(this.currentFragment == pageIndex ? selectedImg : normalImg)
        .width('25vp')
        .height('25vp')
      Text(title)
        .margin({ top: '4vp' })
        .fontSize('10fp')
        .fontColor(this.currentFragment === pageIndex ? '#1698CE' : '#6B6B6B')
    }
    .justifyContent(FlexAlign.Center)
    .height('56vp')
    .width('100%')
    .onClick(() => {
      this.currentFragment = pageIndex;
      this.tabsController.changeIndex(this.currentFragment);
      // 跳转到登录界面
      if (!this.isLogin && this.currentFragment == 3)
        router.pushUrl({ url: 'pages/LoginPage' });
    })
  }


  aboutToAppear(){
    // ServiceApiUtils.getAdviceByTemperature('12');
    if (AppStorage.Get('firstUse') === "true")
      SubWindowUtils.initSubWindow();
  }

  onPageShow() {
    // 获取user
    this.isLogin = AppStorage.Get('isLogin');
    this.user = AppStorage.Get('user');
  }

  build() {
    Tabs({barPosition: BarPosition.End, controller: this.tabsController}){
      TabContent(){
        HomeFragment()
      }
      .padding({ left: '12vp', right: '12vp' })
      .backgroundColor('#F1F3F5')
      .tabBar(this.TabBuilder('首页', 0, $r('app.media.home_selected'), $r('app.media.home_normal')))

      TabContent(){
        VideoFragment()
      }
      .padding({ left: '12vp', right: '12vp' })
      .backgroundColor('#F1F3F5')
      .tabBar(this.TabBuilder('视频', 1, $r('app.media.video_selected'), $r('app.media.video_normal')))

      TabContent(){
        NovelFragment()
      }
      .padding({ left: '12vp', right: '12vp' })
      .backgroundColor('#F1F3F5')
      .tabBar(this.TabBuilder('小说', 2, $r('app.media.novel_selected'), $r('app.media.novel_normal')))

      TabContent(){
        UserFragment()
      }
      .padding({ left: '12vp', right: '12vp' })
      .backgroundColor('#F1F3F5')
      .tabBar(this.TabBuilder('用户', 3, $r('app.media.user_selected'), $r('app.media.user_normal')))
    }
    .width('100%')
    .height('100%')
    .backgroundColor(Color.White)
    .barHeight('56vp')
    .barMode(BarMode.Fixed)
    .onChange((index: number) => {
      this.currentFragment = index;
    })
  }

}

