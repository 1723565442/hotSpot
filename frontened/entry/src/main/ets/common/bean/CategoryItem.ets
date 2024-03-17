export class CategoryItem{
  img: Resource;
  text: string;
  number: number;

  constructor(img: Resource, text: string, number: number) {
    this.img = img;
    this.text = text;
    this.number = number;
  }

}