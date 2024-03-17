import router from '@ohos.router';
import promptAction from '@ohos.promptAction';
import { LabelItem } from '../common/bean/LabelItem';
import Novel from '../common/bean/Novel'
import { StyleConstant } from '../common/constants/StyleConstant';

@Component
export struct UserIconList {
  private labels: LabelItem[] = [];
  private text: string = '';

  build(){
    Column({ space: 15 }){
      Row(){
        Text(this.text)
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
        ForEach(this.labels, (item: LabelItem, index: number) => {
          ListItem() {
            Column({ space: 10 }){
              Image(item.img)
                .width(30)
                .height(30)
              Text(item.label)
                .fontSize('14vp')
            }
            .onClick(() => {
               promptAction.showToast({ message: '功能暂未实现，敬请期待' })
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
