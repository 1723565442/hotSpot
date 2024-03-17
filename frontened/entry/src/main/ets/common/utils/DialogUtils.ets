import common from '@ohos.app.ability.common';
import Context from '@ohos.app.ability.common';
import router from '@ohos.router'
import abilityAccessCtrl, { Permissions } from '@ohos.abilityAccessCtrl';
import UserItem from '../bean/User';
import geoLocationManager from '@ohos.geoLocationManager';
import CommonUtils from './CommonUtils';

export class DialogUtils {

  alterAdviceDialog(title: string, mes: string){
    AlertDialog.show({
      title: '                '+title,
      message: mes+'\n',
      alignment: DialogAlignment.Center,
      offset: {
        dx: 0,
        dy: 0
      },
      confirm: {
        value: '确认',
        action: () => {
          //router.back();
          console.info('CommonUtil', 'Callback definite button is clicked');
        }
      },
    })
  }
  /**
   * Alert dialog dialog
   */
  alterGuideDialog(title: string, mes: string){
    AlertDialog.show({
      title: '                 '+title,
      message: mes+'\n\n\n\n\n\n',
      alignment: DialogAlignment.Bottom,
      offset: {
        dx: 0,
        dy: -20
      },
      confirm: {
        value: '明白了！',
        action: () => {
          //router.back();
          console.info('CommonUtil', 'Callback definite button is clicked');
        }
      },
    }
    )
  }

  /**
   * Alert dialog dialog
   */
  alterErrorDialog(mes: string){
    AlertDialog.show({
      message: mes,
      alignment: DialogAlignment.Center,
      offset: {
        dx: 0,
        dy: 0
      },
      confirm: {
        value: '确认',
        action: () => {
          console.info('CommonUtil', 'Callback definite button is clicked');
        }
      },
    }
    )
  }
  /**
   * Alert dialog dialog
   */
  alertPermissionDialog() {
    AlertDialog.show({
      message: '是否在设置中授权？',
      alignment: DialogAlignment.Bottom,
      offset: {
        dx: 0,
        dy: -20
      },
      primaryButton: {
        value: '确认',
        action: () => {
          CommonUtils.openPermissionsInSystemSettings();
          console.info('CommonUtil', 'Callback definite button is clicked');
        }
      },
      secondaryButton: {
        value: '取消',
        action: () => {
          router.back();
          console.info('CommonUtil', 'Callback cancel button is clicked');
        }
      }
    });
  }

  /**
   * Alert dialog dialog
   */
  alertDialog(msg: string, callBack: Function) {
    AlertDialog.show({
      message: msg,
      alignment: DialogAlignment.Bottom,
      offset: {
        dx: 0,
        dy: -20
      },
      primaryButton: {
        value: '确认',
        action: () => { callBack(); }
      },
      secondaryButton: {
        value: '取消',
        action: () => {}
      }
    });
  }

  /**
   * Date dialog dialog
   */
  datePickerDialog(dateCallback: Function) {
    DatePickerDialog.show({
      start: new Date('1900-1-1'),
      end: new Date(),
      selected: new Date('2003-7-16'),
      lunar: false,
      onAccept: (value: DatePickerResult) => {
        let year: number = Number(value.year);
        let month: number = Number(value.month) + 1;
        let day: number = Number(value.day);
        let birthdate: string = CommonUtils.getBirthDateValue(year, month, day);
        dateCallback(birthdate);
      }
    });
  }

  /**
   * Text dialog dialog
   */
  textPickerDialog(sexArray: Resource, sexCallback: Function) {
    if (CommonUtils.isEmpty(sexArray)) {
      console.error('CommonUtil', 'sex is null');
      return;
    }
    TextPickerDialog.show({
      range: sexArray,
      selected: 0,
      onAccept: (result: TextPickerResult) => {
        sexCallback(result.value);
      },
      onCancel: () => {
        console.info('CommonUtil', 'TextPickerDialog onCancel');
      }
    });
  }
}

export default new DialogUtils();