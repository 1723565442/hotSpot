import router from '@ohos.router';

import WeatherNowItem from '../common/bean/WeatherNowItem'
import WeatherHourItem from '../common/bean/WeatherHourItem'
import WeatherDayItem from '../common/bean/WeatherDayItem'

import CommonUtils from '../common/utils/CommonUtils';
import { Permissions } from '@ohos.abilityAccessCtrl';

import Location from '../common/bean/Location';
import { StyleConstant } from '../common/constants/StyleConstant';
import WeatherApiUtils from '../common/utils/WeaherApiUtils';
import promptAction from '@ohos.promptAction';
import ServiceApiUtils from '../common/utils/ServiceApiUtils';
import DialogUtils from '../common/utils/DialogUtils';

const permissions: Array<Permissions> = ['ohos.permission.APPROXIMATELY_LOCATION','ohos.permission.LOCATION'];

let TAG = "WeatherPageDebug";

@Entry
@Component
struct WeatherPage {
  // @StorageLink('curLocation') curLocation: Location = new Location();
  @State weatherNow: WeatherNowItem = new WeatherNowItem();
  @State weatherToday: WeatherHourItem[] = [];
  @State weatherWeek: WeatherDayItem[] = [];
  @State searchLocation: Location = new Location();
  @State sunrise: string = '06:00';
  @State sunset: string = '18:00'
  private week: string[] = ['星期一', '星期二', '星期三', '星期四', '星期五', '星期六', '星期日']
  private weekDay: number = 0;
  private scroller: Scroller = new Scroller();
  private swiperController: SwiperController = new SwiperController();
  @State openAIAdvice: string = '网络繁忙，请稍后重试。。。';
  @State buttonPosition: { x: number; y: number } = { x: 330, y: 300 };
  @State offsetX: number = -160;
  @State offsetY: number = 80;
  @State positionX: number = -160;
  @State positionY: number = 80;

  add(location: Location){
    if (CommonUtils.isEmpty(location) || CommonUtils.isEmpty(location.city)) {
      promptAction.showToast({ message: '数据正在加载，请稍后重试。。。' });
      return;
    }
    let locations: Location[] = AppStorage.Get('locations');
    for(let i = 0; i < locations.length; i++) {
      if (locations[i].city === location.city) {
        locations[i] = location;
        promptAction.showToast({ message: '已添加' });
        return;
      }
    }
    locations.push(location);
    if (CommonUtils.isLogin())
      ServiceApiUtils.addLocation(location);
    promptAction.showToast({ message: '添加成功，未登录无法同步' });

    AppStorage.Set('locations', locations);
  }

  aboutToAppear() {
    this.searchLocation = router.getParams()?.['location'];
    if (!this.searchLocation) {
      this.searchLocation = new Location();
    }
    // 授权
    CommonUtils.reqPermissionsFromUser(permissions)
      .then(() => {
        if (CommonUtils.isEmptyLocation(this.searchLocation)) {
          let curLocation: Location = AppStorage.Get('curLocation');
          if (CommonUtils.isEmptyLocation(curLocation)) {
            WeatherApiUtils.getCurrentLocation()
              .then((location) => {
                if (CommonUtils.isEmptyLocation(location)) {
                  promptAction.showToast({ message: '位置获取失败 -_-'});
                  router.back();
                }
                this.searchLocation = location;
                this.getWeather();
                AppStorage.SetOrCreate('curLocation', this.searchLocation);
              })
          }
          else {
            this.searchLocation = curLocation
            this.getWeather();
          }
        }
        else this.getWeather();
      })
    this.weekDay = new Date().getDay();
  }

  private async getWeather(): Promise<void>{
    await WeatherApiUtils.getWeatherNow(this.searchLocation)
      .then((weather) => {
        this.weatherNow = weather;
        this.searchLocation.temp = weather.temp ? weather.temp: 24;
        this.searchLocation.weatherCondition = weather.text ? weather.text : '小雨'
        // OpenAI
        let question = "现在的天气为" + JSON.stringify(this.weatherNow) + "，以”根据现在的天气“作为开头，给出衣食住行方面的建议";
        ServiceApiUtils.getAnswerFromOpenAi(question)
          .then((answer) => {
            this.openAIAdvice = answer;
          });
      })
    await WeatherApiUtils.getWeatherToday(this.searchLocation)
      .then((weather) => {
        this.weatherToday = weather;
      })
    await WeatherApiUtils.getWeatherWeek(this.searchLocation)
      .then((weather) => {
        this.weatherWeek = weather;
        this.sunrise = AppStorage.Get('sunrise');
        this.sunset = AppStorage.Get('sunset');
        if (this.weatherWeek.length > 0) {
          this.searchLocation.maxTemp = weather[0].tempMax;
          this.searchLocation.minTemp = weather[0].tempMin;
        }
        else {
          this.searchLocation.maxTemp = 18;
          this.searchLocation.minTemp = 33;
        }
      })
  }
  
  build() {
    Stack({ alignContent: Alignment.Top }) {
      Column() {
        Row() {
          Image($r('app.media.ic_back'))
            .width(24)
            .height(24)
            .onClick(() => {
              router.back()
            })
          // if (!this.isExist) {
            Image($r('app.media.ic_more_normal'))
              .width(28)
              .height(28)
              .onClick(() => {
                router.pushUrl({
                  url: 'pages/CityListPage',
                })
              })
          // }
        }
        .backgroundColor(Color.White)
        .justifyContent(FlexAlign.SpaceBetween)
        .padding(StyleConstant.BOTTOM_BAR_ROW_PADDING)
        .margin({ top: 12, bottom: 12 })
        .borderRadius('16vp')
        .width('95%')

        Scroll(this.scroller) {
          Column({ space: 13 }) {
            // 首页上半部分 此刻的详细信息
            Stack() {
              Image(CommonUtils.getImage(this.weatherNow.text, this.sunrise, this.sunset, CommonUtils.getCurTime()))
                .width('100%')
                .height('280vp')
              Column() {
                Text(this.searchLocation.city == this.searchLocation.district ? this.searchLocation.city + '市' : this.searchLocation.city + '市' + this.searchLocation.district + '区')
                  .fontSize(31)
                  .fontWeight(FontWeight.Bold)
                  .fontColor(StyleConstant.DEFAULT_FONT_COLOR)
                Text(this.weatherNow.temp + "℃")
                  .fontSize(StyleConstant.TEMP_FONT_SIZE)
                  .fontColor(StyleConstant.DEFAULT_FONT_COLOR)
                  .margin(StyleConstant.TEMP_FONT_MARGIN)
                Text(this.weatherNow.text)
                  .fontColor(StyleConstant.DEFAULT_FONT_COLOR)
                Text(this.weatherWeek.length == 0 ? "最高100℃ 最低0℃" : "最高" + this.weatherWeek[0].tempMax.toString() + "℃ 最低" + this.weatherWeek[0].tempMin.toString() + "℃")
                  .fontColor(StyleConstant.DEFAULT_FONT_COLOR)
              }
              .justifyContent(FlexAlign.SpaceAround)
            }

            // TODO 警告界面 可以做成出行建议
            //空气质量 可以
            Column({ space: 15 }) {
              Row({ space: 5 }) {
                Line()
                  .backgroundColor('#2F80ED')
                  .width(3)
                  .height(16)
                Text('空气质量')
                  .fontWeight(FontWeight.Bold)
                  .fontSize(StyleConstant.WIDGET_FONT_SIZE)
                  .width('100%')
              }

              Column({ space: 13 }) {
                Text(this.weatherNow.AQI.toString() + ' - ' + this.weatherNow.AQIText)
                  .fontSize(20)
                  .fontWeight(FontWeight.Bold)
                  .textAlign(TextAlign.Start)
                Text('当前的AQI(CN)为' + this.weatherNow.AQI + '。')
                  .textAlign(TextAlign.Start)
                  .opacity(0.5)
                  .margin({ bottom: '3vp' })
                Progress({ value: this.weatherNow.AQI, total: 500, type: ProgressType.Linear })

              }
              .alignItems(HorizontalAlign.Start)
            }
            .width('90%')
            .backgroundColor(Color.White)
            .backdropBlur(24)
            .borderRadius(12)
            .padding(15)

            // 24小时预报
            Column({ space: 15 }) {
              Row({ space: 5 }) {
                Line()
                  .backgroundColor('#2F80ED')
                  .width(3)
                  .height(16)
                Text('24小时天气预报')
                  .fontWeight(FontWeight.Bold)
                  .fontSize(StyleConstant.WIDGET_FONT_SIZE)
                  .width('100%')
              }

              List({ space: 27 }) {
                ForEach(this.weatherToday, (item, index) => {
                  ListItem() {
                    Column({ space: 7 }) {
                      Text(index + '时')
                        .opacity(0.5)
                      Image($r('app.media.sunny'))
                        .width(24)
                        .height(24)
                      Text(this.weatherToday[index].temp + '℃')
                        .opacity(0.5)
                    }
                  }
                }, item => item)
              }
              .listDirection(Axis.Horizontal)
            }
            .width('90%')
            .height('150vp')
            .backgroundColor(Color.White)
            .backdropBlur(24)
            .borderRadius(12)
            .padding(15)

            // 未来一周
            Column({ space: 15 }) {
              Row({ space: 5 }) {
                Line()
                  .backgroundColor('#2F80ED')
                  .width(3)
                  .height(16)
                Text('未来一周天气')
                  .fontWeight(FontWeight.Bold)
                  .fontSize(StyleConstant.WIDGET_FONT_SIZE)
                  .width('100%')
              }

              List({ space: 8 }) {
                ForEach(this.weatherWeek, (item, index) => {
                  ListItem() {
                    Row() {
                      Text(this.week[(this.weekDay + index - 1 + 7) % 7])
                        .opacity(0.5)
                      Image($r('app.media.sunny'))
                        .width(24)
                        .height(24)
                      Text(this.weatherWeek[index].tempMin.toString() + ' ~ ' + this.weatherWeek[index].tempMax.toString() + "℃")
                        .opacity(0.5)
                        .width(60)
                    }
                    .width('100%')
                    .justifyContent(FlexAlign.SpaceBetween)
                  }
                }, item => item)
              }
              .width('100%')
            }
            .width('90%')
            .backgroundColor(Color.White)
            .backdropBlur(24)
            .borderRadius(12)
            .padding(15)
          }
          .margin({ bottom: 90 })
          // .linearGradient(StyleConstant.LINER_GRADIENT_CONFIG.CLOUDY)
        }
        .width('100%')
        .edgeEffect(EdgeEffect.Spring)
        .scrollBar(BarState.Off)
      }
      .backgroundColor('#F1F3F5')

      // if (!this.isExist) {
        Image($r('app.media.weather_add'))
          .width(40)
          .height(40)
          .offset({ x: 160, y: 80 })
          .onClick(() => {
            this.add(this.searchLocation);
          })
      // }
      Image($r('app.media.ic_gallery_create'))
        .width(40)
        .height(40)
        .onClick(() => {
          DialogUtils.alterAdviceDialog('出行建议', this.openAIAdvice);
        })
        .translate({ x: this.offsetX, y: this.offsetY, z: 0 })
        .gesture(
          // 绑定拖动手势
          PanGesture()
            .onActionStart((event: GestureEvent|undefined) => {
              console.info('Pan start');
            })
              // 当触发拖动手势时，根据回调函数修改组件的布局位置信息
            .onActionUpdate((event: GestureEvent|undefined) => {
              if(event){
                this.offsetX = this.positionX + event.offsetX;
                this.offsetY = this.positionY + event.offsetY;
              }
            })
            .onActionEnd(() => {
              this.positionX = this.offsetX;
              this.positionY = this.offsetY;
            })
        )
    }
  }


}