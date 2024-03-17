import router from '@ohos.router';
import prompt from '@ohos.prompt';
import Novel from '../common/bean/Novel'
import ServiceApiUtils from '../common/utils/ServiceApiUtils';
import ViewModel from '../viewmodel/ViewModel'
import { LabelItem } from '../common/bean/LabelItem';
import promptAction from '@ohos.promptAction';
import { CategoryItem } from '../common/bean/CategoryItem';

let TAG = 'NovelCategoryFragmentDebug'
@Component
export struct NovelCategoryFragment {
  private categoryGridData: CategoryItem[] = [];
  private labelGridData: LabelItem[] = [];
  private total: number = 0;

  aboutToAppear(){
    this.categoryGridData
      .map((item: CategoryItem) => {
        this.total += item.number
      })
  }


  build() {
    Column() {
      Row({ space: 10 }){
        Text('全部')
          .fontWeight(FontWeight.Medium)
          .fontSize('18fp')
        Text(this.total + '本')
          .opacity(0.5)
          .fontSize('14fp')
      }
      .width('90%')
      .justifyContent(FlexAlign.Start)

      Grid() {
        ForEach(this.categoryGridData, (item: CategoryItem) => {
          GridItem() {
            Row() {
              Image(item.img)
                .height('66vp')
                .borderRadius('10vp')
              Column({ space: 10 }) {
                Text(item.text)
                  .fontSize('16fp')
                Text(item.number + '本')
                  .opacity(0.5)
                  .fontSize('14fp')
              }
              .margin({ left: '10vp' })
            }
            .alignItems(VerticalAlign.Center)
            .padding({ top: '10vp', bottom: '8vp', left: '10vp', right: '10vp' })
            .backgroundColor('#F1F3F5')
            .borderRadius('16vp')
            .onClick(() => {
              promptAction.showToast({ message: '功能暂未开放，敬请期待' })
            })
          }
        }, (item: Novel) => JSON.stringify(item))
      }
      .columnsTemplate('1fr 1fr')
      .rowsGap('15vp')
      .padding({ top: '12vp' })
      .height('320vp')
      .width('98%')

      Line().lineStyle()

      Text('热门标签')
        .fontWeight(FontWeight.Medium)
        .fontSize('18fp')
        .alignSelf(ItemAlign.Start)
        .margin({ bottom: '15vp', left: '15vp' })

      Grid() {
        ForEach(this.labelGridData, (item: LabelItem) => {
          GridItem() {
            Row() {
              Image(item.img)
                .height('24vp')
                .width('24vp')
              Text(item.label)
                .fontSize(13)
            }
            .width(33+item.label.length * 13)
            .alignItems(VerticalAlign.Center)
            .padding({ top: '6vp', bottom: '6vp', left: '4vp', right: '4vp' })
            .backgroundColor('#F1F3F5')
            .borderRadius('36vp')
            .onClick(() => {
              promptAction.showToast({ message: '功能暂未开放，敬请期待' })
            })
          }
        }, (item: Novel) => JSON.stringify(item))
      }
      .columnsTemplate('1fr 1fr 1fr 1fr')
      .rowsGap('15vp')
      .padding({left: '5vp', right: '5vp', bottom: '12vp' })
      .height('130vp')
    }
    .padding({ top: '15vp', bottom: '15vp' })
    .borderRadius('16vp')
    .margin({ top: '10vp', bottom: '12vp' })
    .backgroundColor(Color.White)
    .width('95%')
  }

}

@Extend(Line)
function lineStyle() {
  .width('90%')
  .height('1vp')
  .backgroundColor(Color.Orange)
  .opacity(0.5)
  .margin( { top: '20vp', bottom: '15vp' })
}