import router from '@ohos.router'
import { Permissions } from '@ohos.abilityAccessCtrl';
import { LabelItem } from '../common/bean/LabelItem'
import CommonUtils from '../common/utils/CommonUtils';
import ViewModel from '../viewmodel/ViewModel'
import DialogUtils from '../common/utils/DialogUtils';
import Context from '@ohos.app.ability.common';


const permissions: Array<Permissions> = ['ohos.permission.ACCESS_NOTIFICATION_POLICY', 'ohos.permission.NOTIFICATION_CONTROLLER'];

@Entry
@Component
struct SettingPage {
  @State showToast: boolean = true;

  build() {
    Scroll() {
      Column() {
        Row() {
          Image($r('app.media.ic_back'))
            .width('20vp')
            .height('20vp')
            .onClick(() => {
              router.back();
            })
          Text('设置')
            .fontSize('24fp')
            .fontWeight(FontWeight.Medium)
          Text()
        }
        .width('90%')
        .justifyContent(FlexAlign.SpaceBetween)
        .margin({ top: 36, bottom: 20 })

        if (this.showToast) {
          Row() {
            Row({ space: 8 }) {
              Text('x')
                .fontSize('16fp')
                .opacity(0.5)
                .onClick(()=>{
                  this.showToast = false;
                })
              Column({ space: 5 }) {
                Text('开启通知权限')
                  .fontSize('15fp')
                Text('不再错过hotSpot通知、小说更新、热点资讯')
                  .fontSize('10fp')
                  .opacity(0.7)
              }
              .alignItems(HorizontalAlign.Start)
            }

            Button('开启', { type: ButtonType.Normal, stateEffect: true })
              .borderRadius('10vp')
              .backgroundColor(0x317aff)
              .width('60vp')
              .height('30vp')
              .onClick(() => {
                // let context = getContext(this) as Context.UIAbilityContext;
                DialogUtils.alertPermissionDialog();
                this.showToast = false;
              })
          }
          .width('90%')
          .borderRadius('16vp')
          .justifyContent(FlexAlign.SpaceBetween)
          .padding(12)
          .backgroundColor('#F1F3F5')
          .margin({ bottom: 20 })
        }

        List() {
          ForEach(ViewModel.getSettingLabels(), (item: LabelItem, index: number) => {
            ListItem() {
              Row() {
                Row({ space: 8 }) {
                  Image(item.img)
                    .width('30vp')
                    .height('30vp')
                  Text(item.label)
                    .fontSize('15fp')
                }
                Image($r('app.media.ic_forward'))
                  .width('20vp')
                  .height('20vp')
              }
              .justifyContent(FlexAlign.SpaceBetween)
              .width('90%')
              .height('60vp')
            }
            .onClick(()=>{
              router.pushUrl({
                url: 'pages/GuidePage'
              })
            })
          }, (item:LabelItem) => JSON.stringify(item))
        }
        .alignListItem(ListItemAlign.Center)
      }
      .height('100%')
    }
    .backgroundColor(Color.White)
    .edgeEffect(EdgeEffect.Spring)
    .width('100%')
    .height('100%')
  }

}