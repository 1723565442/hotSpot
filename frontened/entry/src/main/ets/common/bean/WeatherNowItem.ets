export default class WeatherNowItem{
  temp: number;
  feelsLike: number; //体感温度
  icon: number;     //天气状况的图标代码
  text: string;     //天气状况的文字描述(阴晴雨雪)
  wind360: number;  //360度风向
  windDir: string;  //风向（东南）
  windScale: number;  //风力等级
  windSpeed: number;  //风速
  humidity: number;   //相对湿度
  precip: number;     //降水量
  pressure: number;   //气压
  vis: number;        //空气能见度
  cloud: number;
  dew: number;
  AQI: number;
  AQIText: string;

  constructor() {
    this.temp = 0;
    this.feelsLike = 0;
    this.icon = 0;
    this.text = '';
    this.wind360 = 0;
    this.windDir = '';
    this.windScale = 0;
    this.windSpeed = 0;
    this.humidity = 0;
    this.precip = 0;
    this.pressure = 0;
    this.vis = 0;
    this.cloud = 0;
    this.dew = 0;
    this.AQI = 0;
    this.AQIText = '';
  }

}