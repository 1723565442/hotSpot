import router from '@ohos.router';
import promptAction from '@ohos.promptAction';
import UserItem from '../common/bean/User';
import CommonUtils from '../common/utils/CommonUtils';
import Location from '../common/bean/Location';
import ServiceApiUtils from '../common/utils/ServiceApiUtils';

@Entry
@Component
struct UserInfoPage {
  @State user: UserItem = new UserItem();

  aboutToAppear(){
    this.user = AppStorage.Get('user');
  }

  build() {
    Scroll() {
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
            router.back();
          })

        Text('用户中心')
          .fontWeight(FontWeight.Medium)
          .fontSize('24fp')
          .margin({ top: '2vp' })
          .padding({ left: '12vp' })
          .alignSelf(ItemAlign.Center)

        Row() {
          Image($r('app.media.ic_avatar'))
            .width('48vp')
            .height('48vp')
          Column() {
            Text(this.user.nickname)
              .fontSize('20fp')
            Text(this.user.email)
              .fontSize('12fp')
              .margin({ top: '4vp' })
          }
          .alignItems(HorizontalAlign.Start)
          .margin({ left: '24vp' })
        }
        .margin({ top: '24vp' })
        .alignItems(VerticalAlign.Center)
        .width('100%')
        .height('96vp')
        .backgroundColor(Color.White)
        .padding({ left: '24vp' })
        .borderRadius('16vp')

        Text('编辑')
          .fontSize('16fp')
          .fontColor('#007DFF')
          .lineHeight('19vp')
          .width('80%')
          .textAlign(TextAlign.End)
          .margin({ top: '20vp', bottom: '5vp' })
          .onClick(() => {
            router.pushUrl({
              url: 'pages/UserEditPage',
              params: {
                user: this.user
              }
            })
          })

        Row() {
          Image($r('app.media.ic_phone'))
            .infoImageStyle()
          Text('电话')
            .infoTextStyle()
            .opacity(0.5)
            .padding({ left: '12vp' })
          Blank()
          Text(this.user.phone)
            .infoTextStyle()
        }
        .infoRowStyle()

        Row() {
          Image($r('app.media.ic_sex'))
            .infoImageStyle()
          Text('性别')
            .infoTextStyle()
            .opacity(0.5)
            .padding({ left: '12vp' })
          Blank()
          Text(this.user.sex)
            .infoTextStyle()
        }
        .infoRowStyle()

        Row() {
          Image($r('app.media.ic_birthdate'))
            .infoImageStyle()
          Text('出生日期')
            .infoTextStyle()
            .opacity(0.5)
            .padding({ left: '12vp' })
          Blank()
          Text(this.user.birthday)
            .infoTextStyle()
        }
        .infoRowStyle()

        Row() {
          Image($r('app.media.ic_signature'))
            .infoImageStyle()
          Text('个性签名')
            .infoTextStyle()
            .opacity(0.5)
            .padding({ left: '12vp' })
          Blank()
          Text(this.user.signature)
            .infoTextStyle()
        }
        .infoRowStyle()

        Blank()

        Button('退出登录', { type: ButtonType.Capsule })
          .width('90%')
          .height('40vp')
          .fontSize('16fp')
          .fontColor('#FA2A2D')
          .fontWeight(FontWeight.Medium)
          .backgroundColor('#E5E8EA')
          .margin({ bottom: '55vp' })
          .onClick(()=>{
            CommonUtils.logout();
            promptAction.showToast({ message: '退出登录成功' })
            router.back();
          })
      }
      .width('100%')
      .height('100%')
      .padding('12vp')
      .backgroundColor('#F1F3F5')
    }
    .width('100%')
    .height('100%')
  }
}

@Extend(Image) function infoImageStyle() {
  .width('24vp')
  .height('24vp')
  .margin({ left: '24vp' })
}
@Extend(Text) function infoTextStyle() {
  .fontSize('16fp')
  .margin({ right: '32vp' })
  .height('48vp')
}
@Extend(Row) function infoRowStyle() {
  .margin({ bottom: '24vp' })
  .borderRadius('24vp')
  .backgroundColor(Color.White)
  .width('93.3%')
  .height('64vp')
}
