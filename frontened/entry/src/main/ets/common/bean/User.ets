import CommonUtils from '../utils/CommonUtils';
export default class UserItem {
  username?: string;
  password?: string;
  img?: Resource;
  nickname?: string;
  phone?: string;
  email?: string;
  birthday?: string;
  sex?: string;
  signature?: string;

  constructor(username?: string, password?: string, img?: Resource, nickname?: string, phone?: string, email?: string, birthday?: string, sex?: string, signature?: string) {
    this.username = username;
    this.password = password;
    this.img = img? img : $r('app.media.ic_avatar');
    this.nickname = nickname? nickname : 'nidaye';
    this.phone = phone? phone : '18888888888';
    this.email = email? email : 'xxx@xxx';
    this.birthday = birthday? birthday : CommonUtils.getCurrentDate();
    this.sex = sex? sex : '男';
    this.signature = signature? signature : '...';
  }

}