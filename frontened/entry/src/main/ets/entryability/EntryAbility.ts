import hilog from '@ohos.hilog';
import Ability from '@ohos.app.ability.UIAbility';
import window from '@ohos.window';
import brightness from '@system.brightness';

let TAG = 'AbilityDebug'

/**
 * Lift cycle management of Ability.
 */
export default class entryAbility extends Ability {
  onCreate(want, launchParam) {
    hilog.isLoggable(0x0000, 'testTag', hilog.LogLevel.INFO);
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onCreate');
    hilog.info(0x0000, 'testTag', '%{public}s', 'want param:' + JSON.stringify(want) ?? '');
    hilog.info(0x0000, 'testTag', '%{public}s', 'launchParam:' + JSON.stringify(launchParam) ?? '');
  }

  onDestroy() {
    hilog.isLoggable(0x0000, 'testTag', hilog.LogLevel.INFO);
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onDestroy');
  }

  onWindowStageCreate(windowStage: window.WindowStage) {
    // Main window is created, set main page for this ability
    hilog.isLoggable(0x0000, 'testTag', hilog.LogLevel.INFO);
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onWindowStageCreate');

    // 3.为主窗口加载对应的目标页面。
    windowStage.loadContent('pages/HomePage', (err, data) => {
      if (err.code) {
        hilog.isLoggable(0x0000, 'testTag', hilog.LogLevel.ERROR);
        hilog.error(0x0000, 'testTag', 'Failed to load the content. Cause: %{public}s', JSON.stringify(err) ?? '');
        return;
      }
      hilog.isLoggable(0x0000, 'testTag', hilog.LogLevel.INFO);
      hilog.info(0x0000, 'testTag', 'Succeeded in loading the content. Data: %{public}s', JSON.stringify(data) ?? '');
    });

    AppStorage.SetOrCreate('windowStage', windowStage);
  }

  floatWindow(){
    // 1.创建悬浮窗。
    let windowClass = null;
    // let config = {name: "floatWindow", windowType: window.WindowType.TYPE_FLOAT, ctx: this.context, };
    let config = {name: "alertWindow", windowType: window.WindowType.TYPE_FLOAT, ctx: this.context};

    window.createWindow(config, (err, data) => {
      if (err.code) {
        console.error(TAG, 'Failed to create the floatWindow. Cause: ' + JSON.stringify(err));
        return;
      }
      console.info(TAG, 'Succeeded in creating the floatWindow. Data: ' + JSON.stringify(data));
      windowClass = data;
      // 2.悬浮窗窗口创建成功后，设置悬浮窗的位置、大小及相关属性等。
      windowClass.moveWindowTo(300, 300, (err) => {
        if (err.code) {
          console.error(TAG, 'Failed to move the window. Cause:' + JSON.stringify(err));
          return;
        }
        console.info(TAG, 'Succeeded in moving the window.');
      });
      windowClass.resize(20, 20, (err) => {
        if (err.code) {
          console.error(TAG, 'Failed to change the window size. Cause:' + JSON.stringify(err));
          return;
        }
        console.info(TAG, 'Succeeded in changing the window size.');
      });
      let color = '#00ff33';
      try {
        windowClass.setWindowBackgroundColor(color);
      } catch (exception) {
        console.error(TAG, 'Failed to set the background color. Cause: ' + JSON.stringify(exception));
      }
      let brightness = 1;
      try {
        windowClass.setWindowBrightness(brightness, (err) => {
          if (err.code) {
            console.error(TAG, 'Failed to set the brightness. Cause: ' + JSON.stringify(err));
            return;
          }
          console.info(TAG, 'Succeeded in setting the brightness.');
        });
      } catch (exception) {
        console.error(TAG, 'Failed to set the brightness. Cause: ' + JSON.stringify(exception));
      }
      // 3.为悬浮窗加载对应的目标页面。
      windowClass.setUIContent("pages/TransparentPage", (err) => {
        if (err.code) {
          console.error(TAG, 'Failed to load the content. Cause:' + JSON.stringify(err));
          return;
        }
        console.info(TAG, 'Succeeded in loading the content.');
        // 3.显示悬浮窗。
        windowClass.showWindow((err) => {
          if (err.code) {
            console.error(TAG, 'Failed to show the window. Cause: ' + JSON.stringify(err));
            return;
          }
          console.info(TAG, 'Succeeded in showing the window.');
        });
      });
      // // 4.销毁悬浮窗。当不再需要悬浮窗时，可根据具体实现逻辑，使用destroy对其进行销毁。
      // windowClass.destroyWindow((err) => {
      //   if (err.code) {
      //     console.error('Failed to destroy the window. Cause: ' + JSON.stringify(err));
      //     return;
      //   }
      //   console.info('Succeeded in destroying the window.');
      // });
    });
  }

  onWindowStageDestroy() {
    // Main window is destroyed, release UI related resources
    hilog.isLoggable(0x0000, 'testTag', hilog.LogLevel.INFO);
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onWindowStageDestroy');
  }

  onForeground() {
    // Ability has brought to foreground
    hilog.isLoggable(0x0000, 'testTag', hilog.LogLevel.INFO);
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onForeground');
  }

  onBackground() {
    // Ability has back to background
    hilog.isLoggable(0x0000, 'testTag', hilog.LogLevel.INFO);
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onBackground');
  }
}
