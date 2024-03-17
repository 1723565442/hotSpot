export default class WeatherDayItem{
  tempMax: number;
  tempMin: number;
  icon: number;

  constructor(tempMax: number, tempMin: number, icon: number) {
    this.tempMax = tempMax;
    this.tempMin = tempMin;
    this.icon = icon;
  }

}