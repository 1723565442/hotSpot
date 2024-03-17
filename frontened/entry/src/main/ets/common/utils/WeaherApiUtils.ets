import geoLocationManager from '@ohos.geoLocationManager';
import Location from '../bean/Location';
import http from '@ohos.net.http';
import WeatherNowItem from '../bean/WeatherNowItem';
import WeatherHourItem from '../bean/WeatherHourItem';
import WeatherDayItem from '../bean/WeatherDayItem';
import CommonUtils from './CommonUtils';
import promptAction from '@ohos.promptAction';
import url from '@ohos.url';
import { CommonConstants } from '../constants/CommonConstants';

let TAG = "ApiUtilsDebug";
let httpRequest = http.createHttp();

export class WeatherApiUtils {

  public async getCurrentLocation(): Promise<Location> {
    let currentLocation = new Location();
    try {
      let geoLocation = await geoLocationManager.getCurrentLocation();
      currentLocation.latitude = geoLocation.latitude.toString();
      currentLocation.longitude = geoLocation.longitude.toString();
      await this.getLocationByCoordinate(currentLocation);
    } catch (e) {
      console.error(TAG, "error while obtaining geo location", e);
    }
    return currentLocation;
  }

  public async getLocationByCoordinate(location: Location): Promise<Location> {
    await httpRequest.request(
      "https://geoapi.qweather.com/v2/city/lookup?key=" + CommonConstants.weatherApiKey + "&location=" +  location.longitude + ',' + location.latitude,
      {
        expectDataType: http.HttpDataType.OBJECT, // 可选，指定返回数据的类型
      })
      //{"code":"200","location":[{"name":"栖霞","id":"101190112","lat":"32.10214","lon":"118.80870","adm2":"南京","adm1":"江苏省",
      // "country":"中国","tz":"Asia/Shanghai","utcOffset":"+08:00","isDst":"0","type":"city","rank":"35","fxLink":"http://hfx.link/1tu61"}],
      // "refer":{"sources":["QWeather"],"license":["QWeather Developers License"]}}
      .then((data) => {
        var res: any = data.result;
        res = res.location[0]
        location.city = res.adm2
        location.district = res.name
      }).catch((err) => {
        console.info(TAG, 'error:' + JSON.stringify(err));
      });
    return location;
  }

  public async getLocationByPlaceName(place: string): Promise<Location> {
    let location = new Location();
    await httpRequest.request("https://geoapi.qweather.com/v2/city/lookup?key=" + CommonConstants.weatherApiKey + "&location=" + encodeURI(place), // 切记中文需要经过url编码！！！
      {
        expectDataType: http.HttpDataType.OBJECT, // 可选，指定返回数据的类型
      })
      //{"code":"200","location":[{"name":"栖霞","id":"101190112","lat":"32.10214","lon":"118.80870","adm2":"南京","adm1":"江苏省",
      // "country":"中国","tz":"Asia/Shanghai","utcOffset":"+08:00","isDst":"0","type":"city","rank":"35","fxLink":"http://hfx.link/1tu61"}],
      // "refer":{"sources":["QWeather"],"license":["QWeather Developers License"]}}
      .then((data) => {
        var res: any = data.result;
        res = res.location[0]
        location.city = res.adm2
        location.district = res.name
        location.latitude = res.lat
        location.longitude = res.lon
      }).catch((err) => {
        console.info(TAG, 'error:' + JSON.stringify(err));
      });
    return location;
  }

  public async getAQINow(location: Location, weatherNow: WeatherNowItem): Promise<WeatherNowItem> {
    await httpRequest.request(
      "https://devapi.qweather.com/v7/air/now?key=" + CommonConstants.weatherApiKey + "&location=" + location.longitude + ',' + location.latitude,
      {
        expectDataType: http.HttpDataType.OBJECT, // 可选，指定返回数据的类型
      })
      //{"code":"200","updateTime":"2023-11-16T08:58+08:00","fxLink":"https://www.qweather.com/air/chongqing-101040100.html",
      // "now":{"pubTime":"2023-11-16T08:00+08:00","aqi":"41","level":"1","category":"优","primary":"NA","pm10":"41","pm2p5":"25",
      // "no2":"27","so2":"8","co":"0.7","o3":"8"},"station":[{...}]
      .then((data) => {
        var res: any = data.result;
        weatherNow.AQI = res.now.aqi;
        weatherNow.AQIText = res.now.category;
      }).catch((err) => {
        weatherNow.AQI = 0;
        weatherNow.AQIText = '';
        promptAction.showToast({ message: '空气质量查询失败，此地无权限' });
      });
    return weatherNow;
  }

  public async getWeatherNow(location: Location): Promise<WeatherNowItem> {
    let result: WeatherNowItem = new WeatherNowItem()
    // 每一个httpRequest对应一个HTTP请求任务，不可复用
    let httpRequest = http.createHttp();
    // 填写HTTP请求的URL地址，可以带参数也可以不带参数。URL地址需要开发者自定义。请求的参数可以在extraData中指定
    await httpRequest.request(
      "https://devapi.qweather.com/v7/weather/now?key=" + CommonConstants.weatherApiKey + "&location=" + location.longitude + ',' + location.latitude,
      {
        expectDataType: http.HttpDataType.OBJECT, // 可选，指定返回数据的类型
      })
      //{"code":"200","updateTime":"2022-12-03T15:27+08:00","fxLink":"http://hfx.link/1tu61",
      // "now":{"obsTime":"2022-12-03T15:12+08:00","temp":"4","feelsLike":"0","icon":"101","text":"多云","wind360":"135",
      // "windDir":"东南风","windScale":"3","windSpeed":"13","humidity":"78","precip":"0.0","pressure":"1020","vis":"7","cloud":"100","dew":"0"},
      // "refer":{"sources":["QWeather","NMC","ECMWF"],"license":["CC BY-SA 4.0"]}},
      .then(async (data) => {
        var res: any = data.result;
        result = res.now as WeatherNowItem;
        await this.getAQINow(location, result);
      }).catch((err) => {
        promptAction.showToast({ message: '实时天气数据获取失败' });
      });
    return result;
  }
  public async getWeatherToday(location: Location): Promise<WeatherHourItem[]> {
    let result: WeatherHourItem[] = [];
    await httpRequest.request(
      "https://devapi.qweather.com/v7/weather/24h?key=" + CommonConstants.weatherApiKey + "&location=" + location.longitude + ',' + location.latitude,
      {
        expectDataType: http.HttpDataType.OBJECT, // 可选，指定返回数据的类型
      })
      //{"code":"200","updateTime":"2022-12-03T14:35+08:00","fxLink":"http://hfx.link/1tu61",
      // "hourly":[{"fxTime":"2022-12-03T16:00+08:00","temp":"4","icon":"305","text":"小雨","wind360":"84","windDir":"东风",
      // "windScale":"3-4","windSpeed":"18","humidity":"76","pop":"55","precip":"0.3","pressure":"1027","cloud":"100","dew":"0"},{}...]
      .then((data) => {
        var res: any = data.result;
        var items = res.hourly;
        // var today = new Date().getDate();
        for (const item of items) {
          result.push(new WeatherHourItem(item.temp, item.icon, item.text))
          // var day = new Date(item.fxTime).getDate();
          // if (day != today) { //截止当天晚上
          //   break;
          // }
        }
      }).catch((err) => {
        promptAction.showToast({ message: '当日天气数据获取失败' });
      });
    return result;
  }
  public async getWeatherWeek(location: Location): Promise<WeatherDayItem[]> {
    let result: WeatherDayItem[] = [];
    await httpRequest.request(
      "https://devapi.qweather.com/v7/weather/7d?key=" + CommonConstants.weatherApiKey + "&location=" + location.longitude + ',' + location.latitude,
      {
        expectDataType: http.HttpDataType.OBJECT, // 可选，指定返回数据的类型
      })
      //"daily":[{"fxDate":"2022-12-03","sunrise":"06:49","sunset":"17:02","moonrise":"14:05","moonset":"01:51",
      // "moonPhase":"盈凸月","moonPhaseIcon":"803","tempMax":"6","tempMin":"4","iconDay":"305","textDay":"小雨",
      // "iconNight":"305","textNight":"小雨","wind360Day":"0","windDirDay":"北风","windScaleDay":"1-2","windSpeedDay":"3",
      // "wind360Night":"0","windDirNight":"北风","windScaleNight":"3-4","windSpeedNight":"16","humidity":"82","precip":"1.0",
      // "pressure":"1027","vis":"22","cloud":"55","uvIndex":"2"},{}...]
      .then((data) => {
        var res: any = data.result;
        var items = res.daily;
        for (const item of items) {
          result.push(new WeatherDayItem(item.tempMax, item.tempMin, item.icon))
        }
      }).catch((err) => {
        promptAction.showToast({ message: '本周数据获取失败' });
      });
    return result;
  }
}

export default new WeatherApiUtils();