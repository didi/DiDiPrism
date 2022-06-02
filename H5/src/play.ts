class PlayBack {
  constructor() {
  }

  play(str: string) {
    let result = document.querySelector(str);
    if (result) {
      result.scrollIntoView({ behavior: "smooth", block:"center", inline:"nearest" });
      this.change(result);
      setTimeout(() => {
        var rect = result!.getBoundingClientRect();
        this.sendTouchEvent((rect.left+rect.right)/2, (rect.top+rect.bottom)/2, result!, 'touchstart');
        this.sendTouchEvent((rect.left+rect.right)/2, (rect.top+rect.bottom)/2, result!, 'touchend');
        this.fireClick(result as HTMLElement);
      }, 200)
    }
  }

  fireClick(node: HTMLElement) {
    if (document.createEvent) {
      var event = document.createEvent('MouseEvents');
      event.initEvent('click', true, false);
      node.dispatchEvent(event);
    }
  }

  change(ele: Element) {
    let styleInfo = ele.getAttribute('style');
    const bg = 'background';
    const bgColor = 'background-color';
    var flag = 0;
    let timer = setTimeout(start, 0)
    function start() {
      if (!flag) {
        let newStyle = 'background-color: rgba(255, 0, 0,0.3)';
        if (styleInfo) {
          if (styleInfo.indexOf(bg) >= 0 || styleInfo.indexOf(bgColor) >= 0) {
            let styleArr = styleInfo.split(';');
            let bgIndex = styleArr.findIndex(item => {
              return item.indexOf(bg) !== -1 || item.indexOf(bgColor) !== -1
            })
            if (bgIndex !== -1) {
              styleArr.splice(bgIndex, 1, 'background-color: rgba(255, 0, 0,0.3)')
            }
            newStyle = styleArr.join(';');
          }
        }
        ele.setAttribute("style", newStyle);
        flag = 1;
        timer = setTimeout(start, 400);
      } else {
        if (styleInfo) {
          ele.setAttribute("style", styleInfo);
        } else {
          ele.setAttribute("style", '');
        }
        clearTimeout(timer)
      }
    }
  }

/* eventType is 'touchstart', 'touchmove', 'touchend'... */
  sendTouchEvent(x: number, y: number, element: Element, eventType: string) {
    const touchObj = new Touch({
      identifier: Date.now(),
      target: element,
      clientX: x,
      clientY: y,
      screenX: x,
      screenY: y,
      pageX: x,
      pageY: y,
      radiusX: 5.5,
      radiusY: 5.5,
      rotationAngle: 0,
      force: 1,
    });

    const touchEvent = new TouchEvent(eventType, {
      cancelable: true,
      bubbles: true,
      touches: [touchObj],
      targetTouches: [touchObj],
      changedTouches: [touchObj],
      shiftKey: true,
    });

    element.dispatchEvent(touchEvent);
  }

}

export default PlayBack;
