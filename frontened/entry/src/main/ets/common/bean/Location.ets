export default class Location{
  city?: string;
  district?: string;
  latitude: string;
  longitude: string;
  weatherCondition?: string;
  temp?: number;
  minTemp?: number;
  maxTemp?: number;

  constructor(){
    this.city = '';
    this.district = '';
    this.latitude = '';
    this.longitude = '';
    this.weatherCondition = '';
    this.minTemp = 0;
    this.maxTemp = 0;
    this.temp = 0;
  }
}
