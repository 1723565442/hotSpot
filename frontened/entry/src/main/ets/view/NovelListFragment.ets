import router from '@ohos.router';
import Novel from '../common/bean/Novel'
import { CommonConstants } from '../common/constants/CommonConstants';
import { StyleConstant } from '../common/constants/StyleConstant';

@Component
export struct NovelListFragment {
  private nos: Novel[]

  build(){
    Column() {
      List({ space: 8 }) {
        ForEach(this.nos, (item: Novel, index) => {
          ListItem() {
            Row({ space: 10 }) {
              Stack({ alignContent: Alignment.TopStart }) {
                Image(CommonConstants.serviceUrl + '/' + item.image)
                  .height('90vp')
                  .borderRadius('10vp')
                Path()
                  .commands('M0 25 C0 25 6 6 25 0 L 60 0 L 60 40 C60 40 54 54 40 60 L 0 60 Z')
                  .fill(Color.Orange)
                  .strokeOpacity(0)
                Text((index + 1).toString())
                  .fontSize('12fp')
                  .fontColor(Color.White)
                  .margin({ top: '4vp', left: '6vp' })
              }

              Column() {
                Text(item.title)
                  .fontSize(18)
                Text(item.introduction)
                  .fontSize(14)
                  .opacity(0.5)
                  .maxLines(1)
                  .textOverflow({ overflow: TextOverflow.Ellipsis })
                Row() {
                    Text(item.author)
                      .opacity(0.5)
                      .fontSize(14)
                  Text(item.view + '万')
                    .fontSize(14)
                    .fontColor(Color.Orange)
                }
                .width('100%')
                .justifyContent(FlexAlign.SpaceBetween)
              }
              .alignItems(HorizontalAlign.Start)
              .justifyContent(FlexAlign.SpaceAround)
              .height('80%')
              .width('64%')
            }
            .width('100%')
            .onClick(() => {
              router.pushUrl({
                url: 'pages/NovelDetailPage',
                params: {
                  title: item.title
                }
              })
            })
          }
          .borderRadius(17)
          .width('100%')
          .height('100vp')
          .backgroundColor('#ffff')
        }, novel => novel)
      }
      .margin({top: '10vp'})
      .width('100%')
      //.height('100%')
    }
    .height('100%')
  }
}
