import router from '@ohos.router';
import prompt from '@ohos.prompt';
import Novel from '../common/bean/Novel'
import ServiceApiUtils from '../common/utils/ServiceApiUtils';
import ViewModel from '../viewmodel/ViewModel'
import promptAction from '@ohos.promptAction';
import CommonUtils from '../common/utils/CommonUtils';
import { LabelItem } from '../common/bean/LabelItem';
import { CommonConstants } from '../common/constants/CommonConstants';
import DialogUtils from '../common/utils/DialogUtils';

let TAG = 'NovelPageDebug'
@Entry
@Component
struct NovelPage {
  @State novel: Novel = ViewModel.getExampleNovel();
  @State inBookshelf: boolean = false;
  private swiperController: SwiperController = new SwiperController();

  onPageShow(){
    let title = router.getParams()?.['title'];
    ServiceApiUtils.getNovelByTitle(title)
      .then((novel) => {
        if (CommonUtils.isEmpty(novel))
          this.novel = ViewModel.getExampleNovel();
        else this.novel = novel
        this.inBookshelf = CommonUtils.isInBookshelf(this.novel);
      })
  }

  readBook(){
    ServiceApiUtils.addView(this.novel.title);
    router.pushUrl({
      url: 'pages/WebPage',
      params: {
        url: this.novel.url
      }
    })
  }

  build() {
    Column() {
      Scroll() {
        Column() {
          Row() {
            Image($r('app.media.ic_back'))
              .width('20vp')
              .height('20vp')
              .onClick(() => {
                router.back()
              })
            Text('hotSpot小说')
              .fontSize('24fp')
              .fontWeight(FontWeight.Bold)
            Image($r('app.media.ic_more'))
              .width('26vp')
              .height('26vp')
              .onClick(() => {
                promptAction.showToast({ message: '功能暂未开放，敬请期待' })
              })
          }
          .width('90%')
          .justifyContent(FlexAlign.SpaceBetween)
          .margin({ top: '24vp' })

          Row() {
            Stack({ alignContent: Alignment.TopStart }) {
              Image(CommonConstants.serviceUrl + '/' + this.novel.image)
                .borderRadius('8vp')
                .width('100vp')
              Path()
                .commands('M0 20 C0 20 6 6 20 0 L 120 0 L 120 54 C120 46 114 60 100 66 L 0 66 Z')
                .fill(Color.Red)
                .strokeOpacity(0)
              Text('免费')
                .fontSize('12fp')
                .fontColor(Color.White)
                .margin({ top: '5vp', left: '5vp' })
            }
            .onClick(() => {
              this.readBook();
            })

            Column() {
              Text(this.novel.title)
                .fontSize('22fp')
                .fontWeight(FontWeight.Medium)
                .maxLines(1)
                .textOverflow({ overflow: TextOverflow.Ellipsis })
              Text(this.novel.author)
                .opacity(0.5)
                .fontSize('15fp')
                .maxLines(1)
                .textOverflow({ overflow: TextOverflow.Ellipsis })
                .margin({ top: '15vp' })
              Text('完结 | 约888万字 | 0元/千字')
                .opacity(0.5)
                .fontSize('15fp')
                .maxLines(1)
                .textOverflow({ overflow: TextOverflow.Ellipsis })
                .margin({ top: '5vp' })
              Text('hotSpot特惠，免费看小说')
                .fontSize('14fp')
                .fontColor(Color.Orange)
                .margin({ top: '5vp' })
            }
            .alignItems(HorizontalAlign.Start)
            .height('90%')
            .margin({ left: '10vp' })

          }
          .width('80%')
          .height('120vp')
          .margin({ top: '24vp' })


          Row() {
            Column() {
              Row() {
                Text('第 ')
                  .fontSize('14fp')
                Text(this.novel.rank)
                  .fontSize('25fp')
                  .fontWeight(FontWeight.Bold)
                  .margin({ bottom: '8vp' })
                Text(' 名')
                  .fontSize('14fp')
              }

              Text('男频完结榜')
                .fontSize('14fp')
                .fontColor(Color.Orange)
                .margin({ top: '4vp' })
            }

            Column() {
              Row() {
                Text(this.novel.view)
                  .fontSize('25fp')
                  .fontWeight(FontWeight.Bold)
                  .margin({ bottom: '8vp' })
                Text(' 万')
                  .fontSize('14fp')
              }

              Text('正在读')
                .opacity(0.5)
                .fontSize('14fp')
                .margin({ top: '4vp' })
            }

            Column() {
              Row() {
                Text(this.novel.score)
                  .fontSize('25fp')
                  .fontWeight(FontWeight.Bold)
                  .margin({ bottom: '8vp' })
                Text(' 分')
                  .fontSize('14fp')
              }

              Text('3000+人评分')
                .opacity(0.5)
                .fontSize('14fp')
                .margin({ top: '4vp' })
            }
          }
          .justifyContent(FlexAlign.SpaceAround)
          .margin({ top: '18vp' })
          .alignItems(VerticalAlign.Center)
          .width('95%')
          .padding({ top: '15vp', bottom: '15vp' })
          .backgroundColor(Color.White)
          .borderRadius('16vp')

          Column({ space: 7 }) {
            Text('简介')
              .fontWeight(FontWeight.Medium)
              .fontSize('18fp')
            Text(this.novel.introduction)
              .fontSize('14vp')
              .lineHeight(22)
              .margin({ top: '5vp' })
            Stack({ alignContent: Alignment.Center }) {
              Path()
                // .commands('M40 0 L80 0 C80 0 110 5 120 20 L 120 40 C120 40 110 55 80 60 L40 60 C40 60 10 55 0 40 L0 20 C 0 20 10 5 40 0 Z')
                .commands('M40 0 L160 0 C160 0 190 5 200 20 L 200 40 C200 40 190 55 160 60 L40 60 C40 60 10 55 0 40 L0 20 C 0 20 10 5 40 0 Z')
                .fill('#F1F3F5')
                .strokeOpacity(0)
              Text(this.novel.label.split('，')[0])
                .fontSize('12fp')
                .opacity(0.5)
            }

            Line()
              .lineStyle()
              .margin({ top: '10vp', bottom: '15vp' })
              .alignSelf(ItemAlign.Center)
            Row() {
              Row({ space: 5 }) {
                Text('目录')
                  .fontWeight(FontWeight.Medium)
                  .fontSize('18fp')
                Text('共3602章')
                  .fontSize('14fp')
                  .opacity(0.5)
              }
              Image($r('app.media.ic_arrow'))
                .width('12vp')
                .height('24vp')
            }
            .width('100%')
            .justifyContent(FlexAlign.SpaceBetween)
            .onClick(() => {
              this.readBook();
            })
          }
          .alignItems(HorizontalAlign.Start)
          .padding({ left: '20vp', right: '20vp', top: '15vp', bottom: '15vp' })
          .width('95%')
          .backgroundColor(Color.White)
          .borderRadius('16vp')
          .margin({ top: '10vp' })

          Row() {
            Column() {
              Row() {
                Text('打赏')
                  .fontWeight(FontWeight.Medium)
                  .fontSize('18fp')
                Image($r('app.media.ic_cup'))
                  .width('12vp')
                  .height('26vp')
                  .margin({ left: '10vp' })
                Stack({ alignContent: Alignment.Start }) {
                  Path()
                    // .commands('M40 0 L80 0 C80 0 110 5 120 20 L 120 40 C120 40 110 55 80 60 L40 60 C40 60 10 55 0 40 L0 20 C 0 20 10 5 40 0 Z')
                    .commands('M0 0 L140 0 C140 0 180 25 140 50 L0 50 Z')
                    .fill(Color.Grey)
                    .strokeOpacity(0)
                  Text('未上榜')
                    .fontSize('13fp')
                    .opacity(0.5)
                    .fontColor(Color.White)
                    .margin({ left: '5vp' })
                }
              }

              Swiper(this.swiperController) {
                ForEach(ViewModel.getSwiperTexts(), (text: string) => {
                  Text(text)
                    .fontSize('14fp')
                    .opacity(0.5)
                }, (text: string) => JSON.stringify(text))
              }
              .margin({ top: '10vp' })
              .autoPlay(true)
              .vertical(true)
              .indicator(false)
              .borderRadius('16vp')
            }
            .alignItems(HorizontalAlign.Start)

            Image($r('app.media.ic_gift'))
              .width('50vp')
              .height('50vp')
          }
          .justifyContent(FlexAlign.SpaceBetween)
          .padding({ left: '20vp', right: '20vp', top: '15vp', bottom: '15vp' })
          .width('95%')
          .backgroundColor(Color.White)
          .borderRadius('16vp')
          .margin({ top: '10vp' })

          Column({ space: 3 }) {
            Text('正文抢先看')
              .fontWeight(FontWeight.Medium)
              .fontSize('18fp')
              .width('100%')
              .align(Alignment.Start)
            Text(this.novel.text)
              .lineHeight(36)
              .fontSize('16fp')
              .opacity(0.8)
            Stack({ alignContent: Alignment.Center }) {
              Path()
                .commands('M80 0 L830 0 C830 0 910 50 830 100 L 80 100 C80 100 0 50 80 0 Z')
                .fillOpacity(0)
                .stroke(Color.Orange)
              Text('继续阅读')
                .fontSize('12fp')
                .fontColor(Color.Orange)
            }
            .margin({ top: '12vp' })
            .onClick(() => {
              this.readBook();
            })
          }
          .padding({ left: '20vp', right: '20vp', top: '15vp', bottom: '15vp' })
          .width('95%')
          .backgroundColor(Color.White)
          .borderRadius('16vp')
          .margin({ top: '10vp', bottom: '10vp' })

          Swiper(this.swiperController) {
            ForEach(ViewModel.getSwiperBanners(), (item: LabelItem) => {
              Stack({ alignContent: Alignment.TopStart }) {
                Image(item.img)
                Path()
                  .commands('M0 0 L120 0 C120 32 80 72 60 72 L 0 72 Z')
                  .fill(Color.Red)
                  .strokeOpacity(0)
                Text('热门')
                  .fontSize('12fp')
                  .fontColor(Color.White)
                  .margin({ top: '5vp', left: '5vp' })
              }
              .onClick(() => {
                router.pushUrl({
                  url: 'pages/WebPage',
                  params: {
                    url: item.label
                  }
                })
              })
            }, (item) => JSON.stringify(item))
          }
          .margin({ top: '10vp' })
          .autoPlay(true)
          .width('95%')
          .borderRadius('16vp')

          Column({ space: 10 }) {
            Text('图书信息')
              .fontWeight(FontWeight.Medium)
              .fontSize('18fp')
            Text('本书数字版权由『zongheng.com』提供并授权发行，如有任何疑问请通过“我的-帮助与反馈”告知我们')
              .fontSize('14fp')
              .opacity(0.5)
          }
          .alignItems(HorizontalAlign.Start)
          .padding({ left: '20vp', right: '20vp', top: '15vp', bottom: '15vp' })
          .width('95%')
          .backgroundColor(Color.White)
          .borderRadius('16vp')
          .margin({ top: '10vp', bottom: '10vp' })

        }
        .width('100%')
        .backgroundColor('#F1F3F5')
      }
      .width('100%')
      .height('92%')
      .edgeEffect(EdgeEffect.Spring)

      Line()
        .lineStyle()
        .width('100%')

      Row() {
        Image($r('app.media.home_yellow'))
          .width('30vp')
          .height('30vp')
          .onClick(() => {
            router.back({
              url: 'pages/HomePage'
            })
          })
        Row({ space: 8 }) {
          Row() {
            Text(this.inBookshelf ? '去书架' : '加入书架')
              .fontColor(Color.Orange)
              .fontSize('14fp')
              .fontWeight(FontWeight.Medium)
          }
          .padding({ top: 8, bottom: 8, left: 12, right: 12 })
          .borderColor(Color.Orange)
          .borderWidth(1)
          .borderRadius('16vp')
          .onClick(() => {
            if (!CommonUtils.isLogin()) {
              DialogUtils.alertDialog('您尚未登录，是否登录？', () => {
                router.pushUrl({ url: 'pages/LoginPage' })
              });
              return;
            }
            if (!this.inBookshelf) {
              let novels: Novel[] = AppStorage.Get('bookshelf')
              if (!CommonUtils.isEmpty(novels) && !CommonUtils.isEmpty(this.novel) && !CommonUtils.isEmpty(this.novel.title)) {
                novels.push(this.novel);
                this.inBookshelf = true;
                ServiceApiUtils.addNovel(this.novel);
                AppStorage.Set('bookshelf', novels);
              }
            }
            else router.pushUrl({ url: 'pages/BookshelfPage' })
          })
          Row() {
            Text('去广告')
              .fontColor(Color.Orange)
              .fontSize('14fp')
              .fontWeight(FontWeight.Medium)
          }
          .padding({ top: 8, bottom: 8, left: 12, right: 12 })
          .borderColor(Color.Orange)
          .borderWidth(1)
          .borderRadius('16vp')
          .onClick(() => {
            promptAction.showToast({ message: '功能暂未开放，敬请期待' })
          })
          Row() {
            Text('免费阅读')
              .fontColor(Color.White)
              .fontSize('14fp')
              .fontWeight(FontWeight.Medium)
          }
          .padding({ top: 8, bottom: 8, left: 12, right: 12 })
          .backgroundColor(Color.Orange)
          .borderRadius('16vp')
          .onClick(() => {
            this.readBook();
          })
        }
      }
      .width('100%')
      .backgroundColor(Color.White)
      .padding({ top: 8, bottom: 12, left: 12, right: 12 })
      .justifyContent(FlexAlign.SpaceBetween)
    }
  }
}

@Extend(Line)
function lineStyle() {
  .width('95%')
  .height('2vp')
  .backgroundColor('#F1F3F5')
}