import promptAction from '@ohos.promptAction';
import prompt from '@ohos.promptAction';
import router from '@ohos.router';
import UserItem from '../common/bean/User';
import CommonUtils from '../common/utils/CommonUtils';
import DialogUtils from '../common/utils/DialogUtils';
import ServiceApiUtils from '../common/utils/ServiceApiUtils';



/**
 * Register page
 */
@Entry
@Component
struct RegisterPage {
  @StorageLink('user') user: UserItem = new UserItem();
  @State isShowProgress: boolean = false;
  private confirmPassword: string = '';

  @Builder
  imageButton(src: Resource) {
    Button({ type: ButtonType.Circle, stateEffect: true }) {
      Image(src)
    }
    .height('48vp')
    .width('48vp')
    .backgroundColor('#F1F3F5')
  }

  register(): void {
    if (CommonUtils.isEmpty(this.user.username) || CommonUtils.isEmpty(this.user.password) || CommonUtils.isEmpty(this.confirmPassword)) {
      DialogUtils.alterErrorDialog('用户名和密码不能为空');
    }else if(this.user.password != this.confirmPassword){
      DialogUtils.alterErrorDialog('两次密码输入不匹配');
    }else if(CommonUtils.validUsername(this.user.username) != null ){
      DialogUtils.alterErrorDialog(CommonUtils.validUsername(this.user.username));
    }else if(CommonUtils.validPassword(this.user.password) != null){
      DialogUtils.alterErrorDialog(CommonUtils.validPassword(this.user.password));
    } else {
      this.isShowProgress = true;
      ServiceApiUtils.createUser(this.user)
        .then(()=>{
          this.isShowProgress = false;
          if (CommonUtils.isLogin()) {
            promptAction.showToast({ message: '注册成功' })
            //初始化书架和天气
            CommonUtils.login();
            router.back({
              url: 'pages/HomePage'
            });
          }
        })
    }
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
      Text('注册界面')
        .fontSize('24fp')
        .fontWeight(FontWeight.Medium)
        .fontColor('#182431')
      Text('注册账号以获取更多服务')
        .fontSize('16fp')
        .fontColor('#99182431')
        .margin({ bottom: '30vp', top: '8vp' })

      TextInput({ placeholder: '用户名（4~16位）' })
        .maxLength(20)
        .type(InputType.Normal)
        .inputStyle()
        .onChange((value: string) => {
          this.user.username = value;
        })
      Line().lineStyle()

      TextInput({ placeholder: '密码（8~20位）' })
        .maxLength(20)
        .type(InputType.Password)
        .inputStyle()
        .onChange((value: string) => {
          this.user.password = value;
        })
      Line().lineStyle()

      TextInput({ placeholder: '确认密码' })
        .maxLength(20)
        .type(InputType.Password)
        .inputStyle()
        .onChange((value: string) => {
          this.confirmPassword = value;
        })
      Line().lineStyle()


      Text('登录')
        .fontSize('16fp')
        .fontColor('#007DFF')
        .lineHeight('19vp')
        .width('80%')
        .textAlign(TextAlign.End)
        .margin({ top: '20vp'})
        .onClick(() => {
          router.back();
        })

      Button('注册', { type: ButtonType.Capsule })
        .width('90%')
        .height('40vp')
        .fontSize('16fp')
        .fontWeight(FontWeight.Medium)
        .backgroundColor('#007DFF')
        .margin({ top: '72vp', bottom: '12vp' })
        .onClick(() => {
          this.register();
        })

      if (this.isShowProgress) {
        LoadingProgress()
          .color('#182431')
          .width('30vp')
          .height('30vp')
          .margin({ top: '20vp' })
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