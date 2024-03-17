import { ListDataSource } from '../viewmodel/NewsListDataSource';
import prompt from '@ohos.promptAction';
import router from '@ohos.router';
import Location from '../common/bean/Location';
import CommonUtils from '../common/utils/CommonUtils';

@Component
export struct HomeFragment {
  @State isRefreshing: boolean = false;
  @State isEditing: boolean = false;
  @StorageLink('curLocation') curLocation: Location = new Location();
  @Provide newsListData: ListDataSource = new ListDataSource();
  private query:string = '';

  aboutToAppear(){
    if (CommonUtils.isEmptyLocation(this.curLocation)) {
      this.curLocation = new Location();
      this.curLocation.city = '重庆';
      this.curLocation.temp = 15;
    }
  }
  build() {
    Column() {
      Stack( { alignContent: Alignment.TopStart }) {
        Image($r('app.media.weather'))
          .width('64vp')
          .height('64vp')
          .offset({ x: 24, y: -18 })
        Column({ space: 5 }) {
          Text(this.curLocation.city)
            .fontSize('22fp')
            .opacity(0.6)
          Text(this.curLocation.temp + '℃')
            .fontSize('15fp')
            .fontColor('#2F80ED')
            .opacity(0.7)
        }
        .width('80%')
        .alignItems(HorizontalAlign.Start)
      }
      .padding({ top: 36 })
      .height(88)
      .onClick(() => {
        router.pushUrl({
          url: 'pages/WeatherPage'
        })
      })

      Column() {
        Image($r("app.media.title_hotspot"))
          .width(200)
          .margin(15)
        Row() {
          Stack({ alignContent: Alignment.Start }) {
            TextInput({ placeholder: this.isEditing ? '' : '        搜索' })
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
              // .onFocus(()=>{
              //   this.isEditing = true;
              // })
              // .onBlur(()=>{
              //   this.isEditing = false;
              // })
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
          .width('80%')
          Image($r('app.media.ic_search'))
            .width('30vp')
            .height('30vp')
            .margin({ left: '10vp' })
            .onClick(() => {
              router.pushUrl({
                url: 'pages/WebPage',
                params: {
                  query: this.query
                }
              })
            })
        }
      }

      Refresh({ refreshing: $$this.isRefreshing, offset: 120, friction: 100 }) {
        this.NewsList()
      }
      .onStateChange((refreshStatus: RefreshStatus) => {
        console.info('Refresh onStatueChange state is ' + refreshStatus)
      })
      .onRefreshing(() => {
        this.newsListData.pushData()
        setTimeout(function() {
          prompt.showToast({message: '刷新成功，新增一组新闻'})
        }, 1200);

        setTimeout(() => {
          this.isRefreshing = false
        }, 1000)
        console.log('onRefreshing test')
      })
    }
    .onClick(()=>{
      this.isEditing = false;
    })
    .justifyContent(FlexAlign.SpaceBetween)
    .width('100%')
    .height('100%')
  }

  @Builder NewsList(){
    List({ space: 12 }) {
      LazyForEach(this.newsListData, (item) => {
        ListItem() {
          Row() {
            Image(item?.newsImg)
              .width('40%')
              .height('100%')
            Column() {
              Text(item?.newsName)
                .fontSize('16fp')
                .margin({ bottom: '10vp' })
                .maxLines(3)
                .textOverflow({overflow: TextOverflow.Ellipsis})
              Text(item?.notes)
                .fontColor('#989A9C')
                .fontSize('12fp')
                .margin({ right: '32vp', bottom: '10vp' })
              Row() {
                Text(item?.evaluate).fontSize('12fp').fontColor('#182431')
                Text(item?.views).fontSize('16fp').fontColor('#E92F4F')
              }
              .justifyContent(FlexAlign.SpaceAround)
              .width('94%')
            }
            .padding('8vp')
            .width('60%')
            .height('100%')
          }
          .justifyContent(FlexAlign.SpaceBetween)
          .height('120vp')
          .width('100%')
          .onClick(() => {
            router.pushUrl({
              url: 'pages/WebPage',
              params: {
                url: item?.url
              }
            })
          })
        }
      })
    }
    .width('94%')
    .height('400vp')
    .divider({
      strokeWidth: '0.25vp',
      color: Color.Grey,
      startMargin: '42vp',
      endMargin: '24vp'
    })
    .borderRadius('16vp')
    .padding({ top: '4vp', bottom: '4vp' })
  }

}

