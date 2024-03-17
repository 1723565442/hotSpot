import window from '@ohos.window';

export class SubWindowUtils {
  // private  sub_windowClass: window.Window;
  // private  windowClass: window.Window;
  // private windowStage: window.WindowStage;

  resizeSubWindow(width: number, height: number){
    let sub_windowClass: window.Window = AppStorage.Get('sub_windowClass');
    sub_windowClass.resize(width, height, (err) => {
      if (err.code) {
        console.error('Failed to change the window size. Cause:' + JSON.stringify(err));
        return;
      }
      console.info('Succeeded in changing the window size.');
    });
  }

  initSubWindow(){
    let windowStage: window.WindowStage = AppStorage.Get('windowStage');
    // 1.获取应用主窗口。
    windowStage.getMainWindow((err, data) => {
      if (err.code) {
        console.error('Failed to obtain the main window. Cause: ' + JSON.stringify(err));
        return;
      }
      data.setWindowTouchable(false);
      data.setBrightness(0.1);
      AppStorage.SetOrCreate('windowClass', data);
      console.info('Succeeded in obtaining the main window. Data: ' + JSON.stringify(data));
    })
    this.showSubWindow();
  }

  exitSubWindow() {
    let sub_windowClass: window.Window = AppStorage.Get('sub_windowClass');
    let windowClass: window.Window = AppStorage.Get('windowClass');
    sub_windowClass.destroyWindow((err) => {
      if (err.code) {
        console.error('Failed to destroy the window. Cause: ' + JSON.stringify(err));
        return;
      }
      console.info('Succeeded in destroying the window.');
    });

    windowClass.setWindowTouchable(true);
    windowClass.setBrightness(1);
  }

  moveSubWindow(x: number, y: number){
    let sub_windowClass: window.Window = AppStorage.Get('sub_windowClass');
    sub_windowClass.moveWindowTo(x, y, (err) => {
      if (err.code) {
        console.error('Failed to move the window. Cause:' + JSON.stringify(err));
        return;
      }
      console.info('Succeeded in moving the window.');
    });
  }

  showSubWindow() {
    let windowStage: window.WindowStage = AppStorage.Get('windowStage');
    // 1.创建应用子窗口。
    windowStage.createSubWindow("mySubWindow", (err, data) => {
      if (err.code) {
        console.error('Failed to create the subwindow. Cause: ' + JSON.stringify(err));
        return;
      }
      let sub_windowClass = data;
      AppStorage.SetOrCreate('sub_windowClass', sub_windowClass);
      console.error('Succeeded in creating the subwindow. Data: ' + JSON.stringify(err));
      // 3.为子窗口加载对应的目标页面。
      sub_windowClass.setUIContent("pages/BeginnerPage", (err) => {
        if (err.code) {
          console.error('Failed to load the content. Cause: ' + JSON.stringify(err));
          return;
        }
        console.info('Succeeded in loading the content.');
        // 3.显示子窗口。
        sub_windowClass.showWindow((err) => {
          if (err.code) {
            console.error('Failed to show the window. Cause: ' + JSON.stringify(err));
            return;
          }
          console.info('Succeeded in showing the window.');
        });
      });
    })
  }
}

export default new SubWindowUtils();