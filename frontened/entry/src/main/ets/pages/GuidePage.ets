import router from '@ohos.router';
import Guide from '../common/bean/Guide';
import DialogUtils from '../common/utils/DialogUtils';
import ViewModel from '../viewmodel/ViewModel';

@Entry
@Component
struct GuidePage{
  guides: Guide[] = [];

  aboutToAppear(){
    this.guides = ViewModel.getGuides();
  }


  build(){
    Column(){
      Row(){
        Image($r('app.media.ic_back'))
          .width('22vp')
          .height('22vp')
          .onClick(() => {
            router.back();
          })
        Text('功能引导')
          .fontSize('24fp')
          .fontWeight(FontWeight.Medium)
          .margin({left: '280px'})
      }
      .width('90%')
      //.justifyContent(FlexAlign.SpaceBetween)
      .margin({ top: '24vp' })

      Grid(){
        ForEach(this.guides, (item: Guide, index)=>{
          GridItem(){
            Column({space: 5}){
              Image(item.img)
                .borderRadius('10vp')
                .width('30vp')
                .height('30vp')
              //.margin({left: 10})
              Text(item.title)
                .fontSize('14fp')
                .maxLines(2)
                .textOverflow({ overflow: TextOverflow.Ellipsis })
              Text(item.label)
                .opacity(0.5)
                .fontSize('12fp')
                .maxLines(1)
                .textOverflow({ overflow: TextOverflow.Ellipsis })
            }
            .height('100vp')
            .width('120vp')
            .alignItems(HorizontalAlign.Center)
            .margin({top: '20px'})
          }
          .onClick(()=>{
            DialogUtils.alterGuideDialog(item.title, item.content)
          })
        },item => item)
      }
      .margin({top: '150px'})
    }
    .width('100%')
    .height('100%')

  }
}