import Novel from '../common/bean/Novel'
import { NovelListFragment } from './NovelListFragment';

let TAG = 'NovelRankFragment'
@Component
export struct NovelRankFragment {
  private categoryGridData: Novel[] = [];
  @State currentIndex: number = 0;
  private tabsController: TabsController = new TabsController();

  @Builder TabBuilder(title: string, pageIndex: number) {
    Row({ space:3 }) {
      Text(title)
        .fontSize('13fp')
        .fontWeight(this.currentIndex == pageIndex ? FontWeight.Bold : FontWeight.Normal)
        .fontColor(this.currentIndex == pageIndex ? Color.Orange : Color.Black)
      Line()
        .backgroundColor(this.currentIndex == pageIndex ? Color.Orange : '#F1F3F5')
        .width(3)
        .height(10)
    }
    .padding({ top: '6vp', bottom: '6vp', left: '8vp', right: '8vp' })
    .borderRadius('20vp')
    .onClick(() => {
      this.currentIndex = pageIndex;
      this.tabsController.changeIndex(this.currentIndex);
    })
  }

  build() {
    Tabs({ barPosition: BarPosition.Start, controller: this.tabsController }) {
      TabContent() {
        Row({ space: 10 }){
          Line().lineStyle()
          NovelListFragment({
            nos: this.categoryGridData.slice(0, 6)
          })
        }
      }
      .tabBar(this.TabBuilder('免费榜', 0))

      TabContent() {
        Row({ space: 10 }) {
          Line().lineStyle()
          NovelListFragment({
            nos: this.categoryGridData.slice(6, 12)
          })
        }
      }
      .tabBar(this.TabBuilder('新书榜', 1))

      TabContent() {
        Row({ space: 10 }) {
          Line().lineStyle()
          NovelListFragment({
            nos: this.categoryGridData.slice(12, 18)
          })
        }
      }
      .tabBar(this.TabBuilder('完结榜', 2))
    }
    .padding({bottom: 30})
    .backgroundColor(Color.White)
    .vertical(true)
    .barWidth(66)
    .barHeight(200)
    .onChange((index: number) => {
      this.currentIndex = index;
    })
  }
}
@Extend(Line) function lineStyle() {
  .width('2vp')
  .height('100%')
  .backgroundColor('#F1F3F5')
}