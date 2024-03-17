import common from '@ohos.app.ability.common';
import Context from '@ohos.app.ability.common';
import router from '@ohos.router'
import abilityAccessCtrl, { Permissions } from '@ohos.abilityAccessCtrl';
import UserItem from '../bean/User';
import geoLocationManager from '@ohos.geoLocationManager';
import DialogUtils from './DialogUtils';
import Location from '../bean/Location';
import Novel from '../bean/Novel';
import window from '@ohos.window';
import ServiceApiUtils from './ServiceApiUtils';
import WeatherApiUtils from './WeaherApiUtils';

export class CommonUtils {

  async reqPermissionsFromUser(permissions: Array<Permissions>): Promise<void> {
    let context = getContext(this) as common.UIAbilityContext;
    let atManager = abilityAccessCtrl.createAtManager();
    // requestPermissionsFromUser会判断权限的授权状态来决定是否唤起弹窗
    await atManager.requestPermissionsFromUser(context, permissions).then((data) => {
      let grantStatus: Array<number> = data.authResults;
      let length: number = grantStatus.length;
      for (let i = 0; i < length; i++) {
        if (grantStatus[i] === 0) {
          // 用户授权，可以继续访问目标操作
        } else {
          // 用户拒绝授权，提示用户必须授权才能访问当前页面的功能，并引导用户到系统设置中打开相应的权限
          // let context = getContext(this) as Context.UIAbilityContext;
          DialogUtils.alertPermissionDialog();
          return;
        }
      }
      // 授权成功
    }).catch((err) => {
      console.error(`requestPermissionsFromUser failed, code is ${err.code}, message is ${err.message}`);
    })
  }

  openPermissionsInSystemSettings(): void {
    let context = getContext(this) as common.UIAbilityContext;
    let wantInfo = {
      action: 'action.settings.app.info',
      parameters: {
        settingsParamBundleName: 'com.example.hotSpot' // 打开指定应用的详情页面
      }
    }
    context.startAbility(wantInfo).then(() => {
      // ...
    }).catch((err) => {
      // ...
    })
  }
  /**
   * Get default birth date
   *
   * @param {number} year year
   * @param {number} month month
   * @param {number} day day
   * @returns {string} return birth date
   */
  getBirthDateValue(year: number, month: number, day: number): string {
    let birthdate: string = `${year}年${month}月${day}日`;
    return birthdate;
  }
  getCurrentDate(): string {
    let date = new Date();
    let year = date.getFullYear();
    let month = date.getMonth() + 1;
    let day = date.getDate();
    return this.getBirthDateValue(year, month, day);
  }

  /**
   * Check obj is empty
   *
   * @param {object} obj
   * @return {boolean} true(empty)
   */
  isEmpty(obj: object | string): boolean {
    return obj === undefined || obj === null || obj === '';
  }

  isEmptyLocation(location: Location): boolean {
    return this.isEmpty(location) || this.isEmpty(location.latitude) || this.isEmpty(location.longitude)
  }
  locationIsIncomplete(location: Location): boolean {
    return this.isEmpty(location.latitude) || this.isEmpty(location.longitude) ||
           this.isEmpty(location.weatherCondition)
  }
  isLocationExist(location: Location): boolean{
    let locations: Location[] = AppStorage.Get('locations');
    if (this.isEmpty(locations) || locations.length == 0)
      return false;
    if(this.isEmpty(locations.find(item => item.city == location.city)))
      return false;
    return true;
  }

  isLogin(): boolean {
    return AppStorage.Get('isLogin') ? AppStorage.Get('isLogin') : false;
  }
  pushUrlWithCheckLogin(url: string): void {
    if (!this.isLogin())
      DialogUtils.alertDialog('您尚未登录，是否登录？', () => {
        router.pushUrl({ url: 'pages/LoginPage' })
      });
    else router.pushUrl({ url: url })
  }
  logout() {
    AppStorage.Set('isLogin', false);
    AppStorage.Set('user', new UserItem());
    AppStorage.Set('bookshelf', []);
    AppStorage.Set('locations', []);
  }
  login() {
    ServiceApiUtils.getBookshelf()
      .then((data)=>{
        let novels: Novel[] = [];
        novels = data;
        AppStorage.SetOrCreate('bookshelf', novels);
      });
    ServiceApiUtils.getLocations()
      .then((data)=>{
        let locations: Location[] = [];
        locations = data;
        for (let i = 0; i < locations.length; i++)
          this.getWeather(locations[i])
            .then((location)=>{locations[i] = location;});
        AppStorage.SetOrCreate('locations', locations);
      });
  }

  private async getWeather(location: Location): Promise<Location> {
    await WeatherApiUtils.getLocationByPlaceName(location.city + location.district)
      .then((result) => {
        location = result;
        console.log('TAG', JSON.stringify(location));
        WeatherApiUtils.getWeatherNow(location)
          .then((weather) => {
            location.temp = weather.temp ? weather.temp: location.temp;
            location.weatherCondition = weather.text ? weather.text : location.weatherCondition;
          })
        WeatherApiUtils.getWeatherWeek(location)
          .then((weather) => {
            if (weather.length > 0) {
              location.maxTemp = weather[0].tempMax;
              location.minTemp = weather[0].tempMin;
            }
          })
      })
    return location;
  }

  isInBookshelf(novel: Novel): boolean {
    let novels: Novel[] = AppStorage.Get('bookshelf')
    if (this.isEmpty(novels) || novels.length == 0)
      return false;
    if(this.isEmpty(novels.find(item => item.title == novel.title)))
      return false;
    return true;
  }
  // 获取时间
  getAccurateTime(): string {
    let date = new Date();
    let year = date.getFullYear();
    let month = date.getMonth() + 1; //从零开始
    let day = date.getDate();
    let hours = date.getHours();
    let minutes = date.getMinutes().toString();
    if (Number.parseInt(minutes) < 10) {
      minutes = `0${minutes}`;
    }
    let second = date.getSeconds().toString();
    if (Number.parseInt(second) < 10) {
      second = `0${second}`;
    }
    return `${year}/${month}/${day} ${hours}:${minutes}:${second}`;
  }

  // 获取时间
  getCurTime(): string {
    let date = new Date();
    let hours = date.getHours().toString();
    if (Number.parseInt(hours) < 10)
      hours = `0${hours}`;
    let minutes = date.getMinutes().toString();
    if (Number.parseInt(minutes) < 10)
      minutes = `0${minutes}`;
    return `${hours}:${minutes}`;
  }

  validPassword(password: string) :string| null{
    if (password.length < 8 || password.length > 16) {
      return '密码长度必须在8到20位之间';
    }
    const hasNumber = /\d/.test(password);
    const hasUpLetter = /[A-Z]/.test(password);
    const hasLowLetter = /[a-z]/.test(password);
    if (!hasNumber || !hasUpLetter || !hasLowLetter) {
      return '密码必须同时包含大小写字母和数字';
    }
    return null;
  }

  validUsername(username: string) :string|null{
    if (username.length < 4 || username.length > 16) {
      return '用户名长度必须在4到16位之间';
    }
    if (!/^[a-zA-Z0-9_-]+$/.test(username)) {
      return '用户名必须由字母、数字、下划线或连字符组成';
    }
    return null;
  }

  validUserInfo(user: UserItem) :string|null{
    if (!/^[a-zA-Z0-9_-]*$/.test(user.nickname)) {
      return '昵称必须由字母、数字、下划线或连字符组成';
    }
    if (!/^1[3-9]\d{9}$/.test(user.phone)) {
      return '电话格式错误';
    }
    if (!/[a-zA-Z0-9]+@[a-z]+$/.test(user.email)) {
      return '邮箱格式错误';
    }
    if (user.signature.length > 120) {
      return '个性签名不能超过120字';
    }
    return null;
  }

  getImage(weather, sunrise, sunset, time): Resource{
    if(!weather){return $r('app.media.weather_other')}
    else if(weather.indexOf('阴')!=-1){
      if(sunrise<time && time < sunset){return $r('app.media.weather_nosunny')}
      else{return $r('app.media.weather_nosunny_dark')}
    }
    else if(weather.indexOf('晴')!=-1){
      if(sunrise<time && time < sunset){
        return $r('app.media.weather_sunny')}
      else {return $r('app.media.weather_sunny_dark')}
    }
    else if(weather.indexOf('云')!=-1){
      if(sunrise<time && time < sunset){return $r('app.media.weather_cloudy')}
      else{return $r('app.media.weather_cloudy_dark')}
    }
    else if(weather.indexOf('雨')!=-1){
      if(sunrise<time && time < sunset){return $r('app.media.weather_rain')}
      else{return $r('app.media.weather_rain_dark')}
    }
    else if(weather.indexOf('雪')!=-1){
      if(sunrise<time && time < sunset){return $r('app.media.weather_snow')}
      else{return $r('app.media.weather_snow_dark')}
    }
    else{return $r('app.media.weather_other')}
  }

}

export default new CommonUtils();