export default class Novel {
  image: string;
  title: string;
  label: string;
  author?: string;
  rank?: string;
  view?: string;
  score?: string;
  introduction?: string;
  url?: string;
  text?: string;

  constructor(image: string, title: string, label: string, author?: string, rank?: string,
              view?: string, score?: string, introduction?: string, url?: string, text?: string)
  {
    this.image = image;
    this.title = title;
    this.label = label;
    this.author = author ? author : '';
    this.rank = rank ? rank : '';
    this.view = view ? view : '';
    this.score = score ? score : '';
    this.introduction = introduction ? introduction : '';
    this.url = url ? url : '';
    this.text = text ? text : '';
  }
}