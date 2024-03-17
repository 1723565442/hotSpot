export default class WeatherHourItem{
  temp: number;
  icon: number;
  text: string;

  constructor(temp: number, icon: number, text: string) {
    this.icon = icon;
    this.temp = temp;
    this.text = text;
  }
}