import {makeAutoObservable} from 'mobx';

class Store {
  count = 0;
  constructor() {
    makeAutoObservable(this);
  }

  increment() {
    this.count++;
  }

  decrement() {
    this.count--;
  }
}
const UserStore = new Store();
export default UserStore;
