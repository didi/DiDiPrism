

declare var document: Document;
declare var window: Window;
interface Window {
  webkit: any;
}

import PlayBackRecord from './record';

const play = new PlayBackRecord();
var isMoving = false;

document.addEventListener('touchmove', function () {
	if (isMoving === true) return;
	isMoving = true;
});

document.addEventListener('touchend', function (e) {
	if (isMoving === true) {
		isMoving = false;
		return;
	}
	if (e.target) {
		try {
			// iOS
			if (window.webkit.messageHandlers.prism_record_instruct) { 
				window.webkit.messageHandlers.prism_record_instruct.postMessage(play.record(e.target as Element))
			}
			// Android myObj注入的桥接对象
            myObj.onClick(play.record(e.target))
		} catch (error) {
		}
	}
});
