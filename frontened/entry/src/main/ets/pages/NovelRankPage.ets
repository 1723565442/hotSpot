import router from '@ohos.router';
import prompt from '@ohos.prompt';
import Novel from '../common/bean/Novel'
import ServiceApiUtils from '../common/utils/ServiceApiUtils';
import ViewModel from '../viewmodel/ViewModel'
import { NovelCategoryFragment } from '../view/NovelCategoryFragment';
import promptAction from '@ohos.promptAction';
import { NovelRankFragment } from '../view/NovelRankFragment';
import CommonUtils from '../common/utils/CommonUtils';

let TAG = 'NovelRankPageDebug'
@Entry
@Component
struct NovelRankPage {
  @State currentIndex: number = 0;
  private tabsController: TabsController = new TabsController();
  private menNovels: Novel[];
  private womenNovels: Novel[];

  @Builder TabBuilder(title: string, pageIndex: number){
    Row() {
      Text(title)
        .fontSize('16fp')
        .fontColor(this.currentIndex == pageIndex ? Color.Orange : Color.Black)
        .opacity(this.currentIndex == pageIndex ? 1 : 0.5)
    }
    .padding({ top: '6vp', bottom: '6vp', left: '50vp', right: '50vp' })
    .borderRadius('20vp')
    .borderWidth('1vp')
    .borderColor(this.currentIndex == pageIndex ? Color.Orange : '#F1F3F5')
    .onClick(() => {
      this.currentIndex = pageIndex;
      this.tabsController.changeIndex(this.currentIndex);
    })
  }

  aboutToAppear(){
    let books: Novel[] = AppStorage.Get('books');
    this.womenNovels = AppStorage.Get('books');
    if (CommonUtils.isEmpty(books) || books.length == 0) {
      promptAction.showToast({ message: '小说获取失败' })
      this.menNovels = [];
      this.womenNovels = [];
    }
    else{
      this.menNovels = books.slice(0, 18);
      this.womenNovels = books.slice(18, 36);
    }
  }

  build() {
    Column() {
      Row() {
        Image($r('app.media.ic_back_orange'))
          .width('26vp')
          .height('26vp')
          .alignSelf(ItemAlign.Start)
          .onClick(() => {
            router.back()
          })
        Text('小说排行')
          .fontSize('24fp')
          .fontColor(Color.Orange)
          .fontWeight(FontWeight.Bold)
        Image($r('app.media.ic_more'))
          .width('26vp')
          .height('26vp')
          .alignSelf(ItemAlign.Start)
          .onClick(() => {
            promptAction.showToast({ message: '功能暂未开放，敬请期待' })
          })
      }
      // .height('10%')
      .width('90%')
      .justifyContent(FlexAlign.SpaceBetween)
      .margin({ top: '24vp' })

      Line()
        .backgroundColor(Color.Orange)
        .width('10%')
        .height('3vp')
        .margin({ top: '8vp', bottom: '12vp' })

      Tabs({barPosition: BarPosition.Start, controller: this.tabsController}){
        TabContent(){
          Column() {
            Text('根据阅读热度和用户口碑推荐')
              .fontSize('14')
              .opacity(0.5)
            Line().lineStyle()
            NovelRankFragment({
              categoryGridData: this.menNovels
            })
          }
        }
        .tabBar(this.TabBuilder('男频', 0))

        TabContent(){
          Column() {
            Text('根据阅读热度和用户口碑推荐')
              .fontSize('14')
              .opacity(0.5)
            Line().lineStyle()
            NovelRankFragment({
              categoryGridData: this.womenNovels
            })
          }
        }
        .tabBar(this.TabBuilder('女频', 1))
      }
      .padding({ bottom: '80vp' })
      .backgroundColor(Color.White)
      .barHeight('56vp')
      .barMode(BarMode.Fixed)
      .barWidth('90%')
      .width('95%')
      .onChange((index: number) => {
        this.currentIndex = index;
      })
    }
    .height('100%')
    .width('100%')
    .backgroundColor('#F1F3F5')

  }
}

@Extend(Line) function lineStyle() {
  .width('100%')
  .height('2vp')
  .margin({ top: '8vp' })
  .backgroundColor('#F1F3F5')
}