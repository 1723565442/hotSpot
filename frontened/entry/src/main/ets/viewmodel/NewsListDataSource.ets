import NewsItem from '../common/bean/NewsItem';
import ViewModel from './ViewModel';

/**
 * create a List range
 */
const createListRange = () => {
  let result = [];
  for (let i = 0; i < 2; i++) { // 增加两组
    result = [...result, ...ViewModel.getNewsInitialList()];
  }
  return result;
}

/**
 * LazyLoad Class
 */
class BasicDataSource implements IDataSource {
  private listeners: DataChangeListener[] = []

  public totalCount(): number {
    return 0;
  }

  public getData(index: number): NewsItem {
    return undefined;
  }

  registerDataChangeListener(listener: DataChangeListener): void {
    if (this.listeners.indexOf(listener) < 0) {
      this.listeners.push(listener);
    }
  }

  unregisterDataChangeListener(listener: DataChangeListener): void {
    const position = this.listeners.indexOf(listener);
    if (position >= 0) {
      this.listeners.splice(position, 1);
    }
  }

  notifyDataReload(): void {
    this.listeners.forEach(listener => {
      listener.onDataReloaded();
    })
  }

  notifyDataAdd(index: number): void {
    this.listeners.forEach(listener => {
      listener.onDataAdd(index);
    })
  }

  notifyDataChange(index: number): void {
    this.listeners.forEach(listener => {
      listener.onDataChange(index);
    })
  }

  notifyDataDelete(index: number): void {
    this.listeners.forEach(listener => {
      listener.onDataDelete(index);
    })
  }

  notifyDataMove(from: number, to: number): void {
    this.listeners.forEach(listener => {
      listener.onDataMove(from, to);
    })
  }
}

export class ListDataSource extends BasicDataSource {
  private listData = createListRange();

  public totalCount(): number {
    return this.listData.length;
  }

  public getData(index: number): NewsItem {
    return this.listData[index];
  }

  public addData(index: number, data: string): void {
    this.listData.splice(index, 0, data);
    this.notifyDataAdd(index);
  }

  public pushData(): void {
    if(this.listData.length <  12) {
      this.listData = [...this.listData, ...ViewModel.getNewsInitialList()];
      this.notifyDataAdd(this.listData.length - 1);
    }
  }
}
