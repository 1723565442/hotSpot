import window from '@ohos.window'
import promptAction from '@ohos.promptAction';
import SubWindowUtils from '../common/utils/SubWindowUtils';

let sub_windowClass: window.Window = AppStorage.Get('sub_windowClass');
let windowClass: window.Window = AppStorage.Get('windowClass');

@Entry
@Component
struct BeginnerPage {
  @State index: number = 0;
  @State message: string = '欢迎使用hotSpot浏览器! \n\n\n      点击进入新手指导';
  @State fontSize: number = 16;

  aboutToAppear() {
      // 2.子窗口创建成功后，设置子窗口的位置、大小及相关属性等。
    SubWindowUtils.moveSubWindow(232, 930);
    SubWindowUtils.resizeSubWindow(620, 320);
  }

  aboutToDisappear(){
    //以后不再出现
    AppStorage.Set('firstUse', "false");
  }

  build() {
    Row() {
      Column({ space: 10 }) {
        Text(this.message)
          .fontSize(this.fontSize)
          .fontWeight(FontWeight.Bold)
          .fontColor(Color.White)
        if (this.index == 0){
          Row(){
            Text('跳过')
              .fontSize(16)
              .fontColor(Color.Orange)
          }
          .justifyContent(FlexAlign.Center)
          .width('64vp')
          .height('32vp')
          .borderRadius('16vp')
          .backgroundColor(Color.White)
          .onClick(()=>{
            SubWindowUtils.exitSubWindow();
          })
        }
      }
      .width('100%')
    }
    // .borderRadius((this.index == 0 || this.index == 6) ? '16vp' : '0vp')
    .height('100%')
    .backgroundColor(Color.Orange)
    .onClick(()=>{
      switch (this.index){
        case 0: {
          SubWindowUtils.moveSubWindow(270, 260);
          SubWindowUtils.resizeSubWindow(400, 100);
          this.message = '1. 点此进入天气预报';
          this.fontSize = 14;
          break;
        }
        case 1: {
          SubWindowUtils.moveSubWindow(135, 2165);
          this.message = '2. 点此进入主页面'
          break;
        }
        case 2: {
          SubWindowUtils.moveSubWindow(410, 2165);
          this.message = '3. 点此进入视频播放'
          break;
        }
        case 3: {
          SubWindowUtils.moveSubWindow(673, 2165);
          this.message = '4. 点此进入精品小说'
          break;
        }
        case 4: {
          SubWindowUtils.moveSubWindow(546, 2165);
          this.message = '5. 点此进入用户中心'
          break;
        }
        case 5: {
          SubWindowUtils.moveSubWindow(232, 930);
          SubWindowUtils.resizeSubWindow(620, 250);
          this.message = '指导结束，祝您使用愉快！'
          break;
        }
        default: SubWindowUtils.exitSubWindow();
      }
      this.index++;
    })
  }
}
// import window from '@ohos.window'
// import promptAction from '@ohos.promptAction';
// import SubWindowUtils from '../common/utils/SubWindowUtils';
//
// let sub_windowClass: window.Window = AppStorage.Get('sub_windowClass');
// let windowClass: window.Window = AppStorage.Get('windowClass');
//
// @Entry
// @Component
// struct BeginnerPage {
//   @State index: number = 0;
//   @State message: string = '欢迎使用hotSpot浏览器! \n\n\n      点击进入新手指导';
//   @State fontSize: number = 16;
//
//   aboutToAppear() {
//     // 2.子窗口创建成功后，设置子窗口的位置、大小及相关属性等。
//     SubWindowUtils.moveSubWindow(310, 920);
//     SubWindowUtils.resizeSubWindow(620, 320);
//   }
//
//   aboutToDisappear(){
//     //以后不再出现
//     AppStorage.Set('firstUse', "false");
//   }
//
//   build() {
//     Row() {
//       Column({ space: 10 }) {
//         Text(this.message)
//           .fontSize(this.fontSize)
//           .fontWeight(FontWeight.Bold)
//           .fontColor(Color.White)
//         if (this.index == 0){
//           Row(){
//             Text('跳过')
//               .fontSize(16)
//               .fontColor(Color.Orange)
//           }
//           .justifyContent(FlexAlign.Center)
//           .width('64vp')
//           .height('32vp')
//           .borderRadius('16vp')
//           .backgroundColor(Color.White)
//           .onClick(()=>{
//             SubWindowUtils.exitSubWindow();
//           })
//         }
//       }
//       .width('100%')
//     }
//     // .borderRadius((this.index == 0 || this.index == 6) ? '16vp' : '0vp')
//     .height('100%')
//     .backgroundColor(Color.Orange)
//     .onClick(()=>{
//       switch (this.index){
//         case 0: {
//           SubWindowUtils.moveSubWindow(230, 243);
//           SubWindowUtils.resizeSubWindow(400, 100);
//           this.message = '1. 点此进入天气预报';
//           this.fontSize = 14;
//           break;
//         }
//         case 1: {
//           SubWindowUtils.moveSubWindow(135, 2320);
//           this.message = '2. 点此进入主页面'
//           break;
//         }
//         case 2: {
//           SubWindowUtils.moveSubWindow(450, 2320);
//           this.message = '3. 点此进入视频播放'
//           break;
//         }
//         case 3: {
//           SubWindowUtils.moveSubWindow(756, 2320);
//           this.message = '4. 点此进入精品小说'
//           break;
//         }
//         case 4: {
//           SubWindowUtils.moveSubWindow(680, 2310);
//           this.message = '5. 点此进入用户中心'
//           break;
//         }
//         case 5: {
//           SubWindowUtils.moveSubWindow(310, 920);
//           SubWindowUtils.resizeSubWindow(620, 250);
//           this.message = '指导结束，祝您使用愉快！'
//           break;
//         }
//         default: SubWindowUtils.exitSubWindow();
//       }
//       this.index++;
//     })
//   }
// }