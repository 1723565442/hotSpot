export default class Guide{
  img: Resource
  title: string;
  label: string;
  content: string;

  constructor(img: Resource, title: string, label: string, cont: string) {
    this.title = title;
    this.content = cont;
    this.label = label;
    this.img = img;
  }
}