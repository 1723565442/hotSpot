import web_webview from '@ohos.web.webview';
import router from '@ohos.router';
import promptAction from '@ohos.promptAction';

@Entry
@Component
struct WebPage {
  private webviewController: web_webview.WebviewController = new web_webview.WebviewController();
  @State fontSize: number = 12
  @State progress: number = 0
  @State hideProgress: boolean = true
  private searchUrl: string = 'https://www.baidu.com'

  aboutToAppear(){
    let url = router.getParams()['url']
    let query = router.getParams()['query']
    this.searchUrl = url ? url : "https://cn.bing.com/search?q=" + query
  }
  build() {
    Column() {
      Progress({ total: 100, value: this.progress })
        .color('#ff5cea20')
        .visibility(this.hideProgress ? Visibility.None : Visibility.Visible)

      Row({ space: 10 }) {
        Image($r('app.media.web_back'))
          .width('30vp')
          .height('30vp')
          .onClick(() => {
            try {
              if (this.webviewController.accessBackward())
                this.webviewController.backward();
              else router.back();
            } catch (error) {
              console.error(`ErrorCode: ${error.code},  Message: ${error.message}`);
            }
          })
        Image($r('app.media.web_front'))
          .width('30vp')
          .height('30vp')
          .onClick(() => {
            try {
              this.webviewController.forward();
            } catch (error) {
              console.error(`ErrorCode: ${error.code},  Message: ${error.message}`);
            }
          })
      }
      .width('93%')
      .justifyContent(FlexAlign.Start)
      .margin({ top: '24vp', bottom: '5vp' })

      Stack({ alignContent: Alignment.TopStart }) {
        Web({ src: this.searchUrl, controller: this.webviewController })
          // 添加onProgressChange事件
          .onProgressChange(e => {
            this.progress = e.newProgress
            // 当进度100%时，进度条消失
            if (this.progress == 100) this.hideProgress = true
            else this.hideProgress = false
          })
      }
    }
    .width('100%')
    .height('100%')
  }

}

// import web_view from '@ohos.web.webview';
//
// @Entry
//
// @Component
//
// struct RemoteWebPage {
//
//   @State progress: number = 0
//
//   @State hideProgress: boolean = true
//
//   controller: web_view.WebviewController = new web_view.WebviewController()
//
//   build() {
//
//     Column() {
//
//       Progress({ total: 100, value: this.progress })
//
//         .color('#ff5cea20')
//
//         .visibility(this.hideProgress ? Visibility.None : Visibility.Visible)
//
//       Web({ src: 'https://www.douban.com/', controller: this.controller })
//
//         .height('100%')
//
//           // 添加onProgressChange事件
//
//         .onProgressChange(e => {
//
//           this.progress = e.newProgress
//
//           // 当进度100%时，进度条消失
//
//           if (this.progress == 100) {
//
//             this.hideProgress = true
//
//           } else {
//
//             this.hideProgress = false
//
//           }
//
//         })
//
//     }.backgroundColor('0xFFFFFF')
//
//   }
//
// }

