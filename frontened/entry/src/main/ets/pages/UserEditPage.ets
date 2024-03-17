import Context from '@ohos.app.ability.common';
import CommonUtils from '../common/utils/CommonUtils';
import TextInputWidget from '../view/TextInputWidget';
import TextCommonWidget from '../view/TextCommonWidget';
import UserItem from '../common/bean/User';
import router from '@ohos.router';
import DialogUtils from '../common/utils/DialogUtils';
import ServiceApiUtils from '../common/utils/ServiceApiUtils';
import promptAction from '@ohos.promptAction';

@Entry
@Component
struct UserEditPage {
  @State user: UserItem = new UserItem();
  @State birthday: string = '';
  @State sex:string = '';
  private sexArray: Resource = $r('app.strarray.sex_array');

  aboutToAppear(){
    this.user = AppStorage.Get('user');
    this.birthday = this.user.birthday;
    this.sex = this.user.sex;
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
          DialogUtils.alertDialog('信息编辑未保存，确定退出？', () => {router.back();});
        })
      Image($r('app.media.ic_avatar'))
        .width('56vp')
        .height('56vp')
        .margin({ top: '5.5%' })
      Text('个人信息')
        .fontColor(Color.Black)
        .fontSize('16fp')
        .margin({ top: '2.1%' })
      TextInputWidget({
        inputImage: $r('app.media.ic_nickname'),
        title: '昵称',
        text: this.user.nickname,
        onItemClick: (val: string) => {
          this.user.nickname = val;
        }
      })
      TextInputWidget({
        inputImage: $r('app.media.ic_phone'),
        title: '电话',
        text: this.user.phone,
        onItemClick: (val: string) => {
          this.user.phone = val;
        }
      })
      TextInputWidget({
        inputImage: $r('app.media.ic_email'),
        title: '邮箱',
        text: this.user.email,
        onItemClick: (val: string) => {
          this.user.email = val;
        }
      })
      TextCommonWidget({
        textImage: $r('app.media.ic_birthdate'),
        title: '出生日期',
        content: $birthday,
        onItemClick: () => {
          DialogUtils.datePickerDialog((birthValue: string) => {
            this.user.birthday = birthValue;
            this.birthday = birthValue;
          });
        }
      })
      TextCommonWidget({
        textImage: $r('app.media.ic_sex'),
        title: '性别',
        content: $sex,
        onItemClick: () => {
          DialogUtils.textPickerDialog(this.sexArray, (sexValue: string) => {
            this.user.sex = sexValue;
            this.sex = sexValue;
          });
        }
      })
      TextInputWidget({
        inputImage: $r('app.media.ic_signature'),
        title: '个性签名',
        text: this.user.signature,
        onItemClick: (val: string) => {
          this.user.signature = val;
        }
      })

      Blank()

      Button('保存', { type: ButtonType.Capsule })
        .width('90%')
        .height('40vp')
        .fontSize('16fp')
        .fontColor('#FA2A2D')
        .fontWeight(FontWeight.Medium)
        .backgroundColor('#E5E8EA')
        .margin({ bottom: '55vp' })
        .onClick(()=>{
          if (CommonUtils.validUserInfo(this.user) != null)
            DialogUtils.alterErrorDialog(CommonUtils.validUserInfo(this.user));
          else {
            AppStorage.Set('user', this.user);
            promptAction.showToast({ message: '保存成功' })
            ServiceApiUtils.editUser(this.user);
            router.back();
          }
        })

    }
    .backgroundColor('#F5F5F5')
    .width('100%')
    .height('100%')
  }

}