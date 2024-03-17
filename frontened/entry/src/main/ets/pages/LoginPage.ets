import promptAction from '@ohos.promptAction';
import prompt from '@ohos.promptAction';
import router from '@ohos.router';
import Location from '../common/bean/Location';
import Novel from '../common/bean/Novel';
import UserItem from '../common/bean/User';
import CommonUtils from '../common/utils/CommonUtils';
import DialogUtils from '../common/utils/DialogUtils';
import ServiceApiUtils from '../common/utils/ServiceApiUtils';
import WeatherApiUtils from '../common/utils/WeaherApiUtils';


/**
 * Login page
 */

@Entry
@Component
struct LoginPage {
  @StorageLink('user') user: UserItem = new UserItem();
  @State isShowProgress: boolean = false;
  private timeOutId: number = -1;

  @Builder
  imageButton(src: Resource) {
    Button({ type: ButtonType.Circle, stateEffect: true }) {
      Image(src)
    }
    .height('48vp')
    .width('48vp')
    .backgroundColor('#F1F3F5')
  }

  login(): void {
    if (CommonUtils.isEmpty(this.user.username) || CommonUtils.isEmpty(this.user.password)) {
      DialogUtils.alterErrorDialog('用户名和密码不能为空');
    }else if(CommonUtils.validUsername(this.user.username) != null ){
      DialogUtils.alterErrorDialog(CommonUtils.validUsername(this.user.username))
    }else if(CommonUtils.validPassword(this.user.password) != null){
      DialogUtils.alterErrorDialog(CommonUtils.validPassword(this.user.password))
    } else {
      this.isShowProgress = true;
      ServiceApiUtils.getUser(this.user)
        .then((user)=>{
          this.isShowProgress = false;
          if (CommonUtils.isLogin()) {
            this.user = user;
            promptAction.showToast({ message: '登录成功' })
            //初始化书架和天气
            CommonUtils.login();
            router.back();
          }
        });

    }
  }

  aboutToDisappear() {
    clearTimeout(this.timeOutId);
    this.timeOutId = -1;
  }

  build() {
    Column() {
      Image($r('app.media.ic_back'))
        .width('26vp')
        .height('26vp')
        .alignSelf(ItemAlign.Start)
        .margin({
          left: '7.2%',
          top: 19
        })
        .onClick(() => {
          router.back()
        })
      Image($r('app.media.login'))
        .width('78vp')
        .height('78vp')
        .margin({ top: '100vp', bottom: '8vp' })
      Text('登录界面')
        .fontSize('24fp')
        .fontWeight(FontWeight.Medium)
        .fontColor('#182431')
      Text('登录界面以获取更多服务')
        .fontSize('16fp')
        .fontColor('#99182431')
        .margin({ bottom: '30vp', top: '8vp' })

      TextInput({ placeholder: '用户名' })
        .maxLength(20)
        .type(InputType.Normal)
        .inputStyle()
        .onChange((value: string) => {
          this.user.username = value;
        })
      Line().lineStyle()

      TextInput({ placeholder: '密码' })
        .maxLength(20)
        .type(InputType.Password)
        .inputStyle()
        .onChange((value: string) => {
          this.user.password = value;
        })
      Line().lineStyle()

      Text('注册')
        .fontSize('16fp')
        .fontColor('#007DFF')
        .lineHeight('19vp')
        .width('80%')
        .textAlign(TextAlign.End)
        .margin({ top: '20vp'})
        .onClick(() => {
          router.pushUrl({
            url: 'pages/RegisterPage'
          })
        })

      Button('登录', { type: ButtonType.Capsule })
        .width('90%')
        .height('40vp')
        .fontSize('16fp')
        .fontWeight(FontWeight.Medium)
        .backgroundColor('#007DFF')
        .margin({ top: '72vp', bottom: '12vp' })
        .onClick(() => {
          this.login();
        })

      if (this.isShowProgress) {
        LoadingProgress()
          .color('#182431')
          .width('30vp')
          .height('30vp')
          .margin({ top: '20vp' })
      }

      Text('其它登录方式')
        .fontColor('#838D97')
        .fontSize('12fp')
        .fontWeight(FontWeight.Medium)
        .margin({ top: '50vp', bottom: '12vp' })
      Row({ space: 45 }) {
        this.imageButton($r('app.media.login_method1'))
        this.imageButton($r('app.media.login_method2'))
        this.imageButton($r('app.media.login_method3'))
      }

    }
    .backgroundColor('#F1F3F5')
    .height('100%')
    .width('100%')
  }
}

@Extend(TextInput)
function inputStyle() {
  .placeholderColor('#99182431')
  .height('45vp')
  .fontSize('18vp')
  .backgroundColor('#F1F3F5')
  .width('100%')
  .margin({ top: '12vp' })
}

@Extend(Line)
function lineStyle() {
  .width('100%')
  .height('1vp')
  .backgroundColor('#33182431')
}

@Extend(Text)
function blueTextStyle() {
  .fontColor('#007DFF')
  .fontSize('14fp')
  .fontWeight(FontWeight.Medium)
}
