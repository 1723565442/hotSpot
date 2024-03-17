import UserItem from './User';
export class Comment{
  author: UserItem;
  date: string;
  content: string;
  comments?: Comment[];

  constructor(author: UserItem, date: string, content: string, comments?: Comment[]) {
    this.author = author;
    this.date = date;
    this.content = content;
    this.comments = comments;
  }

}