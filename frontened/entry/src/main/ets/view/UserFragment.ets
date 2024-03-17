import router from '@ohos.router';
import CommonUtils from '../common/utils/CommonUtils';
import { LabelItem } from '../common/bean/LabelItem';
import ViewModel from '../viewmodel/ViewModel';
import { UserIconList } from './UserIconList';
import UserItem from '../common/bean/User';
import promptAction from '@ohos.promptAction';
import DialogUtils from '../common/utils/DialogUtils';

@Component
export struct UserFragment {
  @Consume user: UserItem;
  @Consume isLogin: boolean;

  build() {
    Scroll(){
      Column({ space: 10 }) {
        Image($r('app.media.ic_setting'))
          .width('30vp')
          .height('30vp')
          .alignSelf(ItemAlign.End)
          .margin({ top: '20vp', bottom: '8vp', right: '10vp' })
          .onClick(()=>{
            router.pushUrl({
              url: 'pages/SettingPage'
            })
          })
        Row(){
          Row({ space: 15 }) {
            Image($r('app.media.account'))
              .width(60)
              .height(60)
            Column({ space: 5 }) {
              Text(this.user.nickname)
                .fontSize('20fp')
                .fontWeight(FontWeight.Bold)
              Text(this.user.email)
                .fontSize('14fp')
                .opacity(0.5)
            }
            .alignItems(HorizontalAlign.Start)
          }
          .onClick(()=>{
            router.pushUrl({
              url: this.isLogin ? 'pages/UserInfoPage' : 'pages/LoginPage'
            })
          })
          Button(this.isLogin ? '详情' : '登录', { type: ButtonType.Normal, stateEffect: true })
            .borderRadius('24vp')
            .backgroundColor(0x317aff)
            .width(90)
            .height(40)
            .onClick(()=>{
              router.pushUrl({
                url: this.isLogin ? 'pages/UserInfoPage' : 'pages/LoginPage'
              })
            })
        }
        .width('95%')
        .justifyContent(FlexAlign.SpaceBetween)

        Grid() {
          ForEach(ViewModel.getUserLabels_1(), (item: LabelItem, index: number) => {
            GridItem() {
              Column({ space: 10 }) {
                Image(item.img)
                  .width('24vp')
                  .height('24vp')
                Text(item.label)
                  .fontSize('12vp')
                  .fontWeight(FontWeight.Medium)
              }
              .width('60vp')
              .onClick(() => {
                if (item.label == '书架')
                  CommonUtils.pushUrlWithCheckLogin('pages/BookshelfPage');
                else promptAction.showToast({ message: '功能暂未实现，敬请期待' })
              })
            }
          }, service => service.label)
        }
        .height('150vp')
        .rowsTemplate('1fr 1fr')
        .borderRadius('16vp')
        .margin({ top: '10vp' })
        .padding({ top: '10vp', bottom: '12vp', left: '20vp', right: '20vp'})
        .backgroundColor(Color.White)
        .scrollBar(BarState.On)
        .scrollBarWidth('2vp')
        .scrollBarColor('#F1F3F5')

        UserIconList({
          text: '工具',
          labels: ViewModel.getUserLabels_2()
        })

        Image($r('app.media.dizhu'))
          .width('100%')
          .onClick(() => {
          })

        UserIconList({
          text: '便民服务',
          labels: ViewModel.getUserLabels_3()
        })

        UserIconList({
          text: '小游戏',
          labels: ViewModel.getUserLabels_4()
        })

        Column({ space: 15 }){
          Row(){
            Text('热门小说')
              .fontSize('18vp')
              .fontWeight(FontWeight.Medium)
            Text('更多 >')
              .fontSize('13vp')
              .opacity(0.5)
              .onClick(() => {
                promptAction.showToast({ message: '功能暂未实现，敬请期待' })
              })
          }
          .justifyContent(FlexAlign.SpaceBetween)
          .borderRadius('16vp')
          .width('100%')

          List({ space: 30 }) {
            ForEach(ViewModel.getUserLabels_5(), (item: LabelItem, index) => {
              ListItem() {
                Column({ space: 10 }){
                  Image(item.img)
                    .width(80)
                    .height(110)
                    .borderRadius('16vp')
                  Text(item.label)
                    .fontSize('14vp')
                }
                .onClick(() => {
                  router.pushUrl({
                    url: 'pages/NovelDetailPage',
                    params: {
                      title: item.label
                    }
                  })
                })
              }
            }, item => item )
          }
          .listDirection(Axis.Horizontal)
        }
        .padding({ top: '20vp', bottom: '15vp', left: '18vp', right: '18vp' })
        .width('100%')
        .borderRadius('16vp')
        .backgroundColor(Color.White)
      }
    }
    .edgeEffect(EdgeEffect.Spring)
    .padding({ bottom: '15vp' })
  }
}
