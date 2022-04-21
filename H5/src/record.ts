class PlayBackRecord {
  constructor() {
  }

  record(el: Element) {
    let content = this.getContent(el as HTMLElement);
    let paths = [];
    while (el && el.nodeName.toLowerCase() !== 'body') {
      let selector = el.nodeName.toLowerCase();
      if (el.id) {
        selector += '#' + el.id;
      } else {
        let className = el.className.split(' ').filter(value => value.trim() !== '').join('.');
        var needClassName = !(className === null || className === '');
        let sib = el;
        let nth = 1;
        while (sib.previousElementSibling) {
          sib = sib.previousElementSibling;
          if (needClassName && sib.className.split(' ').filter(value => value.trim() !== '').join('.') === className) {
            needClassName = false;
          }
          nth = nth + 1;
        };
        if (needClassName) {
          sib = el;
          while (sib.nextElementSibling) {
            sib = sib.nextElementSibling;
            if (needClassName && sib.className.split(' ').filter(value => value.trim() !== '').join('.') === className) {
              needClassName = false;
              break;
            }
          };
        }
        if (needClassName) {
          selector += '.' + className;
        }
        else if (nth > 1) {
          selector += ":nth-child(" + nth + ")"
        }
      }
      paths.unshift(selector);
      el = el.parentElement as Element;
    }
    paths.unshift('body');
    // console.log(paths.join(">"))
    // console.log('content', content)
    let result = {
      "instruct": paths.join(">"),
      "content": content
    }
    return result;
  }

  getContent(el: HTMLElement) {
    if (el.innerText) {
      return this.getText(el as HTMLElement);
    } else if (el.getAttribute('src')) { 
      return el.getAttribute('src')
    } else if (el.querySelectorAll('img') && el.querySelectorAll('img').length > 0) {
      return this.getImgSrc(el as HTMLElement)
    } else { 
      return ''
    }
  }

  getText(el: HTMLElement) {
    if (el.childNodes && el.childNodes.length > 0) {
      for (let i = 0; i < el.childNodes.length; i++) {
        if (el.childNodes[i].childNodes) {
          let value : any = this.getText(el.childNodes[i] as HTMLElement);
          if (value) { 
            return value;
          }
        }
      }
    } else { 
      let result = el.innerText || el.nodeValue
      return result
    }
  }

  getImgSrc(el: HTMLElement) {
    let imgList = el.querySelectorAll('img');
    return imgList && imgList[0] && imgList[0].src;
  }
}

export default PlayBackRecord;
