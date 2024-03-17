import http from '@ohos.net.http';
import promptAction from '@ohos.promptAction';
import Location from '../bean/Location';
import Novel from '../bean/Novel';
import UserItem from '../bean/User';
import { CommonConstants } from '../constants/CommonConstants';
import CommonUtils from './CommonUtils';

let TAG = "ServiceApiUtilsDebug";
let httpRequest = http.createHttp();

export class ServiceApiUtils {

  public async getAnswerFromOpenAi(question: string): Promise<string> {
    question = '用中文回复，不要换行，' + question;
    let answer = ""
    await httpRequest.request(CommonConstants.openAIUrl + "?" + encodeURI(question), // 切记中文需要经过url编码！！！
      {
        expectDataType: http.HttpDataType.STRING, // 可选，指定返回数据的类型
      })
      .then((data) => {
        var res: any = data.result;
        answer += res;
        console.info(TAG, answer);
      }).catch((err) => {
        console.info(TAG, 'error:' + JSON.stringify(err));
      });
    return answer;
  }

  public async getUser(user: UserItem): Promise<UserItem> {
    await httpRequest.request(CommonConstants.serviceUrl + "/user/log",
      {
        method: http.RequestMethod.POST, // 可选，默认为http.RequestMethod.GET
        // 当使用POST请求时此字段用于传递内容
        extraData: {
          "username": user.username,
          "password": user.password
        },
        expectDataType: http.HttpDataType.OBJECT, // 可选，指定返回数据的类型
      })
      .then((data) => {
        var res: any = data.result;
        if (res.code == 0) {
          user = res.data as UserItem;
          AppStorage.SetOrCreate('isLogin', true);
        }
        else promptAction.showToast({ message: res.msg });
      }).catch((err) => {
        console.info(TAG, 'error:' + JSON.stringify(err));
        promptAction.showToast({ message: '服务器连接出错，请管理员排查' });
      });
    return user;
  }

  public async createUser(user: UserItem): Promise<void> {
    await httpRequest.request(CommonConstants.serviceUrl + "/user/reg",
      {
        method: http.RequestMethod.POST, // 可选，默认为http.RequestMethod.GET
        // 当使用POST请求时此字段用于传递内容
        extraData: JSON.parse(JSON.stringify(user)),
        expectDataType: http.HttpDataType.OBJECT // 可选，指定返回数据的类型
      })
      .then((data) => {
        var res: any = data.result;
        if (res.code == 0) AppStorage.SetOrCreate('isLogin', true);
        else promptAction.showToast({ message: res.msg });
      }).catch((err) => {
        console.info(TAG, 'error:' + JSON.stringify(err));
        promptAction.showToast({ message: '服务器连接出错，请管理员排查' });
      });
  }

  public async editUser(user: UserItem): Promise<void> {
    await httpRequest.request(CommonConstants.serviceUrl + "/user/edit",
      {
        method: http.RequestMethod.PUT, // 可选，默认为http.RequestMethod.GET
        // 当使用POST请求时此字段用于传递内容
        extraData: JSON.parse(JSON.stringify(user)),
        expectDataType: http.HttpDataType.OBJECT // 可选，指定返回数据的类型
      })
      .then((data)=>{
        var res: any = data.result;
        if (res.code != 0) promptAction.showToast({ message: '上传失败' });
      })
      .catch((err) => {
        console.info(TAG, 'error:' + JSON.stringify(err));
        promptAction.showToast({ message: '服务器连接出错，请管理员排查' });
      });
  }

  public async addLocation(location: Location): Promise<void> {
    let username = (AppStorage.Get('user') as UserItem).username;
    const locationWithUsername = { ...location, username };
    await httpRequest.request(CommonConstants.serviceUrl + "/weather/adduserlocation",
      {
        method: http.RequestMethod.POST, // 可选，默认为http.RequestMethod.GET
        // 当使用POST请求时此字段用于传递内容
        extraData: JSON.parse(JSON.stringify(locationWithUsername)),
        expectDataType: http.HttpDataType.OBJECT // 可选，指定返回数据的类型
      })
      .then((data)=>{
        var res: any = data.result;
        if (res.code != 0) promptAction.showToast({ message: '添加失败' });
        else promptAction.showToast({ message: '添加成功' });
      })
      .catch((err) => {
        console.info(TAG, 'error:' + JSON.stringify(err));
        promptAction.showToast({ message: '服务器连接出错，请管理员排查' });
      });
  }

  public async getLocations(): Promise<Location[]> {
    let locations: Location[] = [];
    await httpRequest.request(CommonConstants.serviceUrl + "/weather/getuserlocation/" + (AppStorage.Get('user') as UserItem).username,
      {
        expectDataType: http.HttpDataType.OBJECT, // 可选，指定返回数据的类型
      })
      .then((data)=>{
        var res: any = data.result;
        res.data.forEach(location => {
          locations.push(location as Location);
        });
      })
      .catch((err) => {
        console.info(TAG, 'error:locations' + JSON.stringify(err));
      });
    return locations;
  }

  public async addView(title: string): Promise<void> {
    await httpRequest.request(CommonConstants.serviceUrl + "/bookshelf/addview/" + encodeURI(title),
      {
        method: http.RequestMethod.PUT, // 可选，默认为http.RequestMethod.GET
      })
      .catch((err) => {
        console.info(TAG, 'error:' + JSON.stringify(err));
      });
  }

  public async addNovel(novel: Novel): Promise<void> {
    await httpRequest.request(CommonConstants.serviceUrl + "/bookshelf/addbook",
      {
        method: http.RequestMethod.POST, // 可选，默认为http.RequestMethod.GET
        // 当使用POST请求时此字段用于传递内容
        extraData: {
          "title": novel.title,
          "image": novel.image,
          "label": novel.title,
          "username": (AppStorage.Get('user') as UserItem).username
        },
        expectDataType: http.HttpDataType.OBJECT // 可选，指定返回数据的类型
      })
      .then((data)=>{
        var res: any = data.result;
        if (res.code != 0) promptAction.showToast({ message: '添加失败' });
        else promptAction.showToast({ message: '添加成功' });
      })
      .catch((err) => {
        console.info(TAG, 'error:' + JSON.stringify(err));
        promptAction.showToast({ message: '服务器连接出错，请管理员排查' });
      });
  }

  public async getBookshelf(): Promise<Novel[]> {
    let novels: Novel[] = [];
    await httpRequest.request(CommonConstants.serviceUrl + "/bookshelf/getbookshelf/" + (AppStorage.Get('user') as UserItem).username,
      {
        expectDataType: http.HttpDataType.OBJECT, // 可选，指定返回数据的类型
      })
      .then((data)=>{
        var res: any = data.result;
        res.data.forEach(novel => {
          novels.push(new Novel(novel.image, novel.title, novel.label));
        });
      })
      .catch((err) => {
        console.info(TAG, 'error: bookshelf' + JSON.stringify(err));
      });
    return novels;
  }

  public async getAllBooks(): Promise<Novel[]> {
    let novels: Novel[] = [];
    await httpRequest.request(CommonConstants.serviceUrl + "/administrator/getallbook",
      {
        expectDataType: http.HttpDataType.OBJECT, // 可选，指定返回数据的类型
      })
      .then((data)=>{
        var res: any = data.result;
        if (res.code != 0) promptAction.showToast({ message: '服务器故障，小说获取失败 -_-' });
        else {
          res.data.forEach(novel => {
            novels.push(novel as Novel);
          });
        }
      })
      .catch((err) => {
        console.info(TAG, 'error: allBooks' + JSON.stringify(err));
        promptAction.showToast({ message: '服务器连接出错，请管理员排查' });
      });
    return novels;
  }


  public async getNovelByTitle(title: string): Promise<Novel> {
    let novel;
    await httpRequest.request(CommonConstants.serviceUrl + "/bookshelf/selectbook/" + encodeURI(title),
      {
        expectDataType: http.HttpDataType.OBJECT, // 可选，指定返回数据的类型
      })
      .then((data) => {
        var res: any = data.result;
        if (res.code != 0) promptAction.showToast({ message: res.msg });
        else novel = res.data as Novel;
      }).catch((err) => {
        console.info(TAG, 'error:' + JSON.stringify(err));
        promptAction.showToast({ message: '服务器连接出错，请管理员排查' });
      });
    return novel;
  }
}

export default new ServiceApiUtils();