import router from '@ohos.router';
import promptAction from '@ohos.promptAction';
import  Location  from '../common/bean/Location'
import { StyleConstant } from '../common/constants/StyleConstant'
import CommonUtils from '../common/utils/CommonUtils';
import WeatherApiUtils from '../common/utils/WeaherApiUtils';

let TAG = 'CityListPageDebug'

@Entry
@Component
struct CityListPage {

  @State locations: Location[] = []
  @State searchPlace: string = ''
  private searchLocation: Location;

  aboutToAppear() {
    this.searchLocation = new Location();
  }

  onPageShow(){
    this.locations = AppStorage.Get('locations');
  }

  search(){
    if (!CommonUtils.isEmpty(this.searchPlace)) {
      WeatherApiUtils.getLocationByPlaceName(this.searchPlace)
        .then((location) => {
          this.searchLocation = location;
          if (!CommonUtils.isEmptyLocation(this.searchLocation)){
            router.pushUrl({
              url: 'pages/WeatherPage',
              params: {
                location: this.searchLocation
              }
            })
          }
          else promptAction.showToast({ message: '无法查询此地名，请重新输入'})
        })
    }
    else promptAction.showToast({ message: '输入不能为空'})
  }

  build(){
    Stack(){
      Column({space: 20}){
        Row() {
          Image($r('app.media.ic_public_back_white'))
            .width('30vp')
            .height('30vp')
            .onClick(() => {
              router.back();
            })
          Text('天气')
            .fontSize(StyleConstant.PAGE_TITLE_FONT_SIZE)
            .fontColor(StyleConstant.DEFAULT_FONT_COLOR)
          Image($r('app.media.ic_more_white'))
            .width('30vp')
            .height('30vp')
            .onClick(() => {
              promptAction.showToast({ message: '功能暂未开放，敬请期待' })
            })
        }
        .width('100%')
        .justifyContent(FlexAlign.SpaceBetween)

        List({space: 15}){
          ForEach(this.locations, (item: Location, index: number) =>{
            ListItem(){
              Row() {
                // 左侧
                Column() {
                  Text(item.city)
                    .fontColor(StyleConstant.DEFAULT_FONT_COLOR)
                    .fontSize(24)
                  Text(item.weatherCondition) // 天气情况
                    .fontColor(StyleConstant.DEFAULT_FONT_COLOR)
                    .fontSize(StyleConstant.WIDGET_FONT_SIZE)
                }
                .alignItems(HorizontalAlign.Start)
                .justifyContent(FlexAlign.SpaceBetween)
                .height('100%')


                // 右侧
                Column(){
                  Text(item.temp.toString() + '℃')
                    .fontSize(50)
                    .fontColor(StyleConstant.DEFAULT_FONT_COLOR)
                    .fontWeight(FontWeight.Lighter)

                  Text(item.minTemp + ' ~ ' + item.maxTemp + '℃')
                    .fontColor(StyleConstant.DEFAULT_FONT_COLOR)
                    .fontSize(StyleConstant.WIDGET_FONT_SIZE)
                }
                .alignItems(HorizontalAlign.End)
                .justifyContent(FlexAlign.SpaceBetween)
                .height('100%')

              }
              .backgroundColor("#ff303030")
              .justifyContent(FlexAlign.SpaceBetween)
              .height(100)
              .width('100%')
              .padding(13)
              .borderRadius(17)
              .onClick(() => {
                this.searchPlace = item.city + item.district;
                this.search();
              })
            }
          }, item => item )

        }
        .width('100%')
        .borderRadius(StyleConstant.DEFAULT_RADIUS)
        .padding(StyleConstant.EDIT_PAGE_LIST_PADDING)
        .edgeEffect(EdgeEffect.Spring)

      }
      .height('100%')
      //.padding(25)
      .padding({left: 25, right: 25})

      Column(){
        Stack(){
          TextInput({placeholder: '搜索城市或机场'})
            .borderRadius(7)
            .height(35)
            .type(InputType.Normal)
            .padding({ left: 35 })
            .backgroundColor(StyleConstant.SEARCH_BACKGROUND)
            .fontColor(StyleConstant.DEFAULT_FONT_COLOR)
            .placeholderColor(StyleConstant.DEFAULT_FONT_COLOR)
            .onChange((value: string)=>{
              this.searchPlace = value
            })
            .onSubmit((enterKey: EnterKeyType) => {
              this.search()
            })

          Image($r('app.media.ic_public_search'))
            .size({ width: 24, height: 24 })
            .margin({ left: 7 })
            .onClick(() => {
              this.search()
            })
        }
        .width('100%')
        .alignContent(Alignment.Start)
      }
      .padding(17)
      .width('100%')
      .height(StyleConstant.BOTTOM_BAR_HEIGHT)
      .linearGradient(StyleConstant.LINER_GRADIENT_CONFIG.BOTTOM_BAR_DARK)
      .border(StyleConstant.BOTTOM_BAR_BORDER)


    }
    .alignContent(Alignment.Bottom)
    .padding(StyleConstant.EDIT_PAGE_PADDING)
    .backgroundColor(StyleConstant.DEFAULT_PAGE_BACKGROUND_COLOR)

  }
}