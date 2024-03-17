import router from '@ohos.router';
import prompt from '@ohos.prompt';
import Novel from '../common/bean/Novel'
import ServiceApiUtils from '../common/utils/ServiceApiUtils';
import ViewModel from '../viewmodel/ViewModel'
import { NovelCategoryFragment } from '../view/NovelCategoryFragment';
import promptAction from '@ohos.promptAction';

let TAG = 'NovelCategoryPageDebug'
@Entry
@Component
struct NovelCategoryPage {
  @State currentIndex: number = 0;
  private tabsController: TabsController = new TabsController();

  @Builder TabBuilder(title: string, pageIndex: number){
    Row() {
      Text(title)
        .fontSize('15fp')
        .fontColor(this.currentIndex == pageIndex ? Color.White : Color.Black)
        .opacity(this.currentIndex == pageIndex ? 1 : 0.5)
    }
    .padding({ top: '6vp', bottom: '6vp', left: '13vp', right: '13vp' })
    .borderRadius('20vp')
    .backgroundColor(this.currentIndex == pageIndex ? Color.Orange : '#F1F3F5')
    .onClick(() => {
      this.currentIndex = pageIndex;
      this.tabsController.changeIndex(this.currentIndex);
    })
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
          Text('小说分类')
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
            NovelCategoryFragment({
              categoryGridData: ViewModel.getMenCategories(),
              labelGridData: ViewModel.getMenLabels()
            })
          }
          .backgroundColor('#F1F3F5')
          .tabBar(this.TabBuilder('男生', 0))

          TabContent(){
            NovelCategoryFragment({
              categoryGridData: ViewModel.getWomenCategories(),
              labelGridData: ViewModel.getWomenLabels()
            })
          }
          .backgroundColor('#F1F3F5')
          .tabBar(this.TabBuilder('女生', 1))
        }
        .padding({ bottom: '80vp' })
        .backgroundColor(Color.White)
        .barHeight('56vp')
        .barMode(BarMode.Fixed)
        .barWidth('150vp')
        .onChange((index: number) => {
          this.currentIndex = index;
        })
      }
      .height('100%')
      .width('100%')
      .backgroundColor('#F1F3F5')
  }
}
