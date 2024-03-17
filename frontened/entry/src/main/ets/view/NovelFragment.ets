import router from '@ohos.router';
import { LabelItem } from '../common/bean/LabelItem';
import Novel from '../common/bean/Novel';
import { CommonConstants } from '../common/constants/CommonConstants';
import CommonUtils from '../common/utils/CommonUtils';
import DialogUtils from '../common/utils/DialogUtils';
import ServiceApiUtils from '../common/utils/ServiceApiUtils';
import ViewModel from '../viewmodel/ViewModel';
@Component
export struct NovelFragment {
  @State categoryGridData: Novel[] = ViewModel.getManBooks().slice(0, 6);
  private swiperController: SwiperController = new SwiperController();
  @State currentIndex: number = 0;
  @State isEditing: boolean = false;
  @StorageLink('bookshelf') bookshelf: Novel[] = [];
  @State freeNovels: Novel[] = [];
  @State newNovels: Novel[] = [];
  @State completedNovels: Novel[] = [];
  private query: string = '';

  aboutToAppear(){
    ServiceApiUtils.getAllBooks()
      .then((novels)=>{
        if (novels.length <= 0) {
          this.freeNovels = ViewModel.getWomanBooks().slice(0, 6);
          this.newNovels = ViewModel.getWomanBooks().slice(10, 16);
          this.completedNovels = ViewModel.getWomanBooks().slice(20, 26);
        }
        else {
          this.freeNovels = novels.slice(0, 6);
          this.newNovels = novels.slice(6, 12);
          this.completedNovels = novels.slice(12, 18);
          if(novels.length > 28) this.newNovels = [...novels.slice(28), ...this.newNovels]
          this.categoryGridData = this.freeNovels;
        }
        // AppStorage.SetOrCreate('freeNovels_men', this.freeNovels);
        // AppStorage.SetOrCreate('newNovels_men', this.newNovels);
        // AppStorage.SetOrCreate('completedNovels_men', this.completedNovels);
        // AppStorage.SetOrCreate('freeNovels_women', novels.);
        // AppStorage.SetOrCreate('newNovels_women', this.newNovels);
        // AppStorage.SetOrCreate('completedNovels_women', this.completedNovels);

        AppStorage.SetOrCreate('books', [...this.freeNovels, ...this.newNovels, ...this.completedNovels, ...novels.slice(18, 28), ...novels.slice(20, 28)]);
      });
  }

  build() {

    Scroll(){
      Column() {
        Image($r('app.media.ic_book'))
          .width('80vp')
          .height('80vp')
          .borderRadius('48vp')
          .backgroundColor(Color.White)
          .margin({ top: 24 })

        Row({ space: 8 }) {
          Stack({ alignContent: Alignment.Start }) {
            TextInput({ placeholder: this.isEditing ? '' : '        搜索书名、作者、分类' })
              // .padding({left: '10vp'})
              .textAlign(TextAlign.Start)
              .maxLength(20)
              .type(InputType.Normal)
              .enterKeyType(EnterKeyType.Done)
              .onChange((value: string) => {
                this.query = value;
              })
              .onClick(()=>{
                this.isEditing = true;
              })
              .onSubmit((enterKey: EnterKeyType) => {
                router.pushUrl({
                  url: 'pages/WebPage',
                  params: {
                    query: this.query
                  }
                })
              })
            if (!this.isEditing) {
              Image($r("app.media.icon"))
                .margin({ left: '8vp' })
                .width('30vp')
                .height('30vp')
            }
          }
          .width('88%')
          Image($r('app.media.ic_search'))
            .width('10%')
            .onClick(() => {
              router.pushUrl({
                url: 'pages/WebPage',
                params: {
                  query: this.query
                }
              })
            })
        }
        .margin({ top: 16 })

        Row() {
          Swiper(this.swiperController) {
            ForEach(ViewModel.getSwiperNovels(), (item: LabelItem) => {
              Image(item.img)
                .borderRadius('8vp')
                .onClick(() => {
                  router.pushUrl({
                    url: 'pages/NovelDetailPage',
                    params: {
                      title: item.label
                    }
                  })
                })
            }, (item: LabelItem) => JSON.stringify(item))
          }
          .autoPlay(true)
          .width('32%')

          Column({ space: 10 }) {
            Row(){
              Text('我的书架')
                .fontSize('18fp')
                .fontWeight(FontWeight.Bold)
              Row({ space: 5 }) {
                Text('去书架')
                  .fontSize('16fp')
                  .opacity(0.5)
                Image($r('app.media.ic_arrow'))
                  .width('10vp')
                  .height('16vp')
              }
              .onClick(()=>{
                CommonUtils.pushUrlWithCheckLogin('pages/BookshelfPage');
              })
            }
            .width('100%')
            .justifyContent(FlexAlign.SpaceBetween)

            List({ space: 18 }) {
              ForEach(this.bookshelf, (item: Novel, index) => {
                ListItem() {
                  Column({ space: 10 }) {
                    Image(CommonConstants.serviceUrl + '/' + item.image)
                      .width(66)
                      .height(90)
                      .borderRadius('10vp')
                    Text(item.title)
                      .fontSize('14vp')
                      .width(66)
                      .maxLines(1)
                      .textOverflow({ overflow: TextOverflow.Ellipsis })
                  }
                  .onClick(() => {
                    router.pushUrl({
                      url: 'pages/NovelDetailPage',
                      params: {
                        title: item.title
                      }
                    })
                  })
                }
              }, item => item)
            }
            .listDirection(Axis.Horizontal)
          }
          .width('64%')
          .height('180vp')
          .backgroundColor(Color.White)
          .borderRadius('16vp')
          .padding({ right: 10, left: 10, top: 15, bottom: 15})
        }
        .width('100%')
        .justifyContent(FlexAlign.SpaceBetween)
        .margin({ top: '18vp' })

        Row() {
          Column() {
            Image($r('app.media.ic_category'))
              .width('32vp')
              .height('32vp')
            Text('分类')
              .fontSize('12fp')
              .margin({ top: '4vp' })
          }
          .onClick(() => {
            router.pushUrl({
              url: 'pages/NovelCategoryPage'
            })
          })
          Column() {
            Image($r('app.media.ic_sort'))
              .width('32vp')
              .height('32vp')
            Text('排行')
              .fontSize('12fp')
              .margin({ top: '4vp' })
          }
          .onClick(() => {
            router.pushUrl({
              url: 'pages/NovelRankPage'
            })
          })
        }
        .justifyContent(FlexAlign.SpaceAround)
        .margin({ top: '18vp' })
        .alignItems(VerticalAlign.Center)
        .width('100%')
        .height('72vp')
        .backgroundColor(Color.White)
        .borderRadius('16vp')

        Column() {
          Row() {
            Text('排行榜')
              .fontSize('18fp')
            Row({ space: 5 }) {
              Text('更多')
                .fontSize('16fp')
                .opacity(0.5)
              Image($r('app.media.ic_arrow'))
                .width('10vp')
                .height('16vp')
            }
            .onClick(() => {
              router.pushUrl({
                url: 'pages/NovelRankPage'
              })
            })
          }
          .margin({ top: '12vp', bottom: '10vp' })
          .width('90%')
          .justifyContent(FlexAlign.SpaceBetween)


          Row(){
            Row() {
              Text('免费榜')
                .fontColor(this.currentIndex == 0 ? Color.Orange : Color.Black)
                .fontSize('14vp')
                .fontWeight(this.currentIndex == 0 ? FontWeight.Bold : FontWeight.Normal)
                .onClick(() => {
                  this.currentIndex = 0;
                  this.categoryGridData = this.freeNovels;
                })
            }
            .justifyContent(FlexAlign.Center)
            .backgroundColor(this.currentIndex == 0 ? Color.White : '#F1F3F5')
            .borderRadius('16vp')
            .margin({ left: '2vp' })
            .height('32vp')
            .width('80vp')

            Row() {
              Text('完结榜')
                .fontColor(this.currentIndex == 1 ? Color.Orange : Color.Black)
                .fontSize('14vp')
                .fontWeight(this.currentIndex == 1 ? FontWeight.Bold : FontWeight.Normal)
                .onClick(()=>{
                  this.currentIndex = 1;
                  this.categoryGridData = this.completedNovels;
                })
            }
            .justifyContent(FlexAlign.Center)
            .backgroundColor(this.currentIndex == 1 ? Color.White : '#F1F3F5')
            .borderRadius('16vp')
            .height('32vp')
            .width('80vp')

            Row() {
              Text('新书榜')
                .fontColor(this.currentIndex == 2 ? Color.Orange : Color.Black)
                .fontSize('14vp')
                .fontWeight(this.currentIndex == 2 ? FontWeight.Bold : FontWeight.Normal)
                .onClick(()=>{
                  this.currentIndex = 2;
                  this.categoryGridData = this.newNovels;
                })
            }
            .justifyContent(FlexAlign.Center)
            .backgroundColor(this.currentIndex == 2 ? Color.White : '#F1F3F5')
            .borderRadius('16vp')
            .margin({ right: '2vp' })
            .height('32vp')
            .width('80vp')
          }
          .justifyContent(FlexAlign.SpaceBetween)
          .backgroundColor('#F1F3F5')
          .borderRadius('26vp')
          .height('36vp')


          Grid() {
            ForEach(this.categoryGridData, (item: Novel, index: number) => {
              GridItem() {
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
                  .onClick(() => {
                    router.pushUrl({
                      url: 'pages/NovelDetailPage',
                      params: {
                        title: item.title
                      }
                    })
                  })
                  Column({ space: 10 }) {
                    Text(item.title)
                      .fontSize('16fp')
                      .maxLines(2)
                      .textOverflow({ overflow: TextOverflow.Ellipsis })
                    Text(item.label)
                      .fontColor(Color.Orange)
                      .fontSize('14fp')
                      .maxLines(2)
                      .textOverflow({ overflow: TextOverflow.Ellipsis })
                  }
                  .width('70vp')
                  .alignItems(HorizontalAlign.Start)
                }
              }
            }, (item: Novel) => JSON.stringify(item))
          }
          .columnsTemplate('1fr 1fr')
          .rowsTemplate('1fr 1fr 1fr')
          .padding({ top: '8vp', bottom: '12vp' })
          .height('350vp')
        }
        .backgroundColor(Color.White)
        .borderRadius('16vp')
        .margin({ top: '10vp' })

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
        .width('100%')
        // .height('100vp')
        .borderRadius('16vp')
      }
      .onClick(()=>{
        this.isEditing = false;
      })
    }
    .width('100%')
    .height('100%')
    .edgeEffect(EdgeEffect.Spring)
  }


}
