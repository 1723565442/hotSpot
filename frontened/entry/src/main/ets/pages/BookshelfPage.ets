import promptAction from '@ohos.promptAction';
import router from '@ohos.router';
import Novel from '../common/bean/Novel';
import { CommonConstants } from '../common/constants/CommonConstants';
import CommonUtils from '../common/utils/CommonUtils';
import ViewModel from '../viewmodel/ViewModel';

@Entry
@Component
struct BookshelfPage {
  private novel: Novel;
  @State novels: Novel[] = [];

  aboutToAppear(){
    this.novels = AppStorage.Get('bookshelf')
  }
  build() {
    Column() {
      Row() {
        Image($r('app.media.ic_back'))
          .width('22vp')
          .height('22vp')
          .onClick(() => {
            router.back();
          })
        Text('书架')
          .fontSize('24fp')
          .fontWeight(FontWeight.Medium)
        Image($r('app.media.ic_more_normal'))
          .width('30vp')
          .height('30vp')
          .onClick(() => {
            promptAction.showToast({ message: '功能暂未开放，敬请期待' })
          })
      }
      .width('90%')
      .justifyContent(FlexAlign.SpaceBetween)
      .margin({ top: '24vp' })

      Row() {
        Row({ space: 5 }) {
          Text('我的藏书')
            .fontSize('16fp')
          Text(this.novels.length.toString())
            .fontWeight(FontWeight.Bold)
            .fontSize('20fp')
        }
        Row({ space: 5 }) {
          Image($r('app.media.ic_history'))
            .width('20vp')
            .height('20vp')
          Text('阅读历史')
            .fontSize('16fp')
          Line()
            .margin({ left: 6, right: 6 })
            .width('2vp')
            .height('14vp')
            .backgroundColor(Color.Grey)
            .opacity(0.5)
          Text('更多')
            .fontSize('16fp')
        }
      }
      .width('90%')
      .justifyContent(FlexAlign.SpaceBetween)
      .margin({ top: '24vp' })

      Grid() {
        ForEach(this.novels, (item: Novel, index: number) => {
          GridItem() {
            Column({ space: 5 }) {
              Image(CommonConstants.serviceUrl + '/' + item.image)
                .borderRadius('10vp')
                .width('80vp')
                .height('110vp')
              Text(item.title)
                .fontSize('14fp')
                .maxLines(2)
                .textOverflow({ overflow: TextOverflow.Ellipsis })
              Text(item.label)
                .opacity(0.5)
                .fontSize('12fp')
                .maxLines(1)
                .textOverflow({ overflow: TextOverflow.Ellipsis })
            }
            .height('180vp')
            .width('80vp')
            .alignItems(HorizontalAlign.Start)
            .onClick(() => {
              router.pushUrl({
                url: 'pages/NovelDetailPage',
                params: {
                  title: item.title
                }
              })
            })
          }
        }, (item: Novel) => JSON.stringify(item))
      }
      .columnsTemplate('1fr 1fr 1fr')
      .margin({ top: '20vp'})
      .height('666vp')
      .width('95%')
    }
    .width('100%')
    .height('100%')
  }
}
