

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
			// Android
			// myObj为注入的桥接对象，onClick为桥接对象的方法。对象名myObj和方法名onClick可按需要更改。
            // myObj.onClick(play.record(e.target as Element))
		} catch (error) {
		}
	}
});
