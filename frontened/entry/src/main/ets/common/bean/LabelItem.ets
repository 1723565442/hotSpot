export class LabelItem{
  img?: Resource;
  label: string;

  constructor(label: string, img?: Resource) {
    this.img = img;
    this.label = label
  }

}